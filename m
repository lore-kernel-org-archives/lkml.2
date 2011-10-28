Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab1J1Tx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 15:53:56 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33813 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1J1Txz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 15:53:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAAfyv35KsspWGAkmZmZOaDw5v3tngKuV8YqQ_fvZU4azHCUtYA@mail.gmail.com>
References: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com>
	<1319662641-28416-2-git-send-email-marek.belisko@open-nandra.com>
	<alpine.DEB.2.00.1110261405400.23111@chino.kir.corp.google.com>
	<CAAfyv35KsspWGAkmZmZOaDw5v3tngKuV8YqQ_fvZU4azHCUtYA@mail.gmail.com>
Date: Fri, 28 Oct 2011 21:53:54 +0200
Message-ID: <CACRpkdZ1Y1sHh1oQKFVYUEftyZnJnuUGLmXUHg3vaZKbSfra2Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinmux: Unify pin type from signed to unsigned.
From: Linus Walleij <linus.walleij@linaro.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: David Rientjes <rientjes@google.com>, swarren@nvidia.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 8:13 AM, Belisko Marek <marek.belisko@gmail.com> wrote:
> On Wed, Oct 26, 2011 at 11:06 PM, David Rientjes <rientjes@google.com> wrote:
>> On Wed, 26 Oct 2011, Marek Belisko wrote:
>>
>>>  /* Sufficiently stupid default function when pinctrl is not in use */
>>> -static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
>>> +static inline bool pin_is_valid(struct pinctrl_dev *pctldev, unsigned int pin)
>>>  {
>>>       return pin >= 0;
>>>  }
>>
>>
>> So this would just become return true, right?
>
> Right I've overlooked it. Will send update version.

Well, actually the idea was that the external interface to the pin control
should have a signed value, so as to detect negative pin numbers as
"invalid".

Internally, and towards the pin control driver backends it is supposed
to be unsigned, because we don't want to have to check it for being
negative all the time.

So can you please make a patch only patching pin_desc_get()
to begin with?

For pin_is_valid() we rather should find out if it will have
any external users (like for GPIO) or if we should just delete
that function (now that pin control doesn't use it internally
anymore).

Yours,
Linus Walleij
