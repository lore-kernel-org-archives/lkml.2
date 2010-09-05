Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0IEP25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 11:28:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61441 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab0IEP24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 11:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lXI0QKKT7tMR2yaP+ZeUeFNjcI5/kMezJaZ62tyo9dravMU4CZvrBa0r6UsVTdLvQQ
         yeL7LVeBY3aAqTnIj4Biu4idTpNIcjtJqBfU2ND6lUNJHwu6Qir1LpvvL+GeuS7VEreE
         Or3mxW2SQGAIVIxv6m5sqf+2t887JyJfWRWlA=
MIME-Version: 1.0
In-Reply-To: <AANLkTikOs0a45bfZ4jRd1_ROvcUMPmnwvcicpm1RZFCc@mail.gmail.com>
References: <1283552891-13966-1-git-send-email-mark.brown314@gmail.com>
	<1283552891-13966-5-git-send-email-mark.brown314@gmail.com>
	<4C834E9B.5080505@compulab.co.il>
	<AANLkTikOs0a45bfZ4jRd1_ROvcUMPmnwvcicpm1RZFCc@mail.gmail.com>
Date: Sun, 5 Sep 2010 11:28:51 -0400
Message-ID: <AANLkTik7H3qdbRa3NHKFyMvaFRJpisqs0=U-h7sxZQy4@mail.gmail.com>
Subject: Re: [PATCH v2 4/6 RESEND] ARM: pxa27x_keypad: added wakeup event
 handler for keypad interrupts
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 5, 2010 at 6:46 AM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Sun, Sep 5, 2010 at 4:02 PM, Igor Grinberg <grinberg@compulab.co.il> wrote:
>>  On 09/04/10 01:28, Mark F. Brown wrote:
>>> mach-mmp needs to clear wake event in order to clear the keypad interrupt
>>>
>>> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
>>> ---
>>>  arch/arm/plat-pxa/include/plat/pxa27x_keypad.h |    1 +
>>>  drivers/input/keyboard/pxa27x_keypad.c         |   10 ++++++++++
>>>  2 files changed, 11 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h b/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
>>> index 7b4eadc..73dacda 100644
>>> --- a/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
>>> +++ b/arch/arm/plat-pxa/include/plat/pxa27x_keypad.h
>>> @@ -52,6 +52,7 @@ struct pxa27x_keypad_platform_data {
>>>
>>>       /* key debounce interval */
>>>       unsigned int    debounce_interval;
>>> +     void            (*clear_wakeup_event)(void);
>>
>> I understand, this is a bit late... but still I want to ask a question:
>> As I understand, the clear_wakeup_event() function is called in interrupt context,
>> wouldn't it be wiser to add a comment on this, so platform (current/future) code
>> will be aware and will make no heavy stuff in it (accidentally).
>>
>
> A comment will be good to have indeed, not just explaining the context
> this function will be running, but also a bit about why this is introduced.
>
> Mark,
>
> If you come up with an updated patch, I'll help rebase my tree.
>
>>>  };
>>>
>>>  extern void pxa_set_keypad_info(struct pxa27x_keypad_platform_data *info);
>>> diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
>>> index 0610d10..b36d2be 100644
>>> --- a/drivers/input/keyboard/pxa27x_keypad.c
>>> +++ b/drivers/input/keyboard/pxa27x_keypad.c
>>> @@ -330,11 +330,21 @@ static void pxa27x_keypad_scan_direct(struct pxa27x_keypad *keypad)
>>>       keypad->direct_key_state = new_state;
>>>  }
>>>
>>> +static void clear_wakeup_event(struct pxa27x_keypad *keypad)
>>> +{
>>> +     struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
>>> +
>>> +     if (pdata->clear_wakeup_event)
>>> +             (pdata->clear_wakeup_event)();
>>> +}
>>> +
>>>  static irqreturn_t pxa27x_keypad_irq_handler(int irq, void *dev_id)
>>>  {
>>>       struct pxa27x_keypad *keypad = dev_id;
>>>       unsigned long kpc = keypad_readl(KPC);
>>>
>>> +     clear_wakeup_event(keypad);
>>> +
>>>       if (kpc & KPC_DI)
>>>               pxa27x_keypad_scan_direct(keypad);
>>>
>>
>> --
>> Regards,
>> Igor.
>>
>>
>

Ok will do!

-- Mark
