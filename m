Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0CaC4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:56:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46763 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab0CaC4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uRqibr40QjA/fV9rhvFgU9r4K64WsWwEBg8S/qssQudRqfnlz/gxb1nigcdTRvnBBV
         z/QQVgPP+8nePxYpYQP2CQFHK1wx2SHklawoA3Gyq5vvtkaHaY6ntxdN7LY/sJ1Weug2
         akAk9kC16yETff9bijAIKMYsqj/h97UXCJ2fM=
MIME-Version: 1.0
In-Reply-To: <0D753D10438DA54287A00B027084269763691C3440@AUSP01VMBX24.collaborationhost.net>
References: <90b950fc1003252024i5ba8989bg95f0a81e8e5e708e@mail.gmail.com>
	 <20100330160257.e5f978a9.akpm@linux-foundation.org>
	 <0D753D10438DA54287A00B027084269763691C3440@AUSP01VMBX24.collaborationhost.net>
Date: Wed, 31 Mar 2010 11:56:50 +0900
Message-ID: <90b950fc1003301956mf8246f4sd060852dbead1407@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] added S6E63M0 AMOLED LCD Panel 
	driver.
From: InKi Dae <daeinki@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hertley,

it's a good way.
this way is more clear and also Andrew's concern could be solved.

I'd like to apply it to local repository and then I will send the patch
in the near future.

and Andrew, If you think that Hertley's way is clear then I would make
the patch. maybe it would become second patch.

Thank you.

2010/3/31 H Hartley Sweeten <hartleys@visionengravers.com>:
> On Tuesday, March 30, 2010 4:03 PM, Andrew Morton wrote:
>> On Fri, 26 Mar 2010 12:24:24 +0900
>> InKi Dae <daeinki@gmail.com> wrote:
>>
>>> +static int s6e63m0_ldi_init(struct s6e63m0 *lcd)
>>> +{
>>> +    int ret;
>>> +
>>> +    ret = s6e63m0_panel_send_sequence(lcd, SEQ_PANEL_CONDITION_SET);
>>> +    ret |= s6e63m0_panel_send_sequence(lcd, SEQ_DISPLAY_CONDITION_SET);
>>> +    ret |= s6e63m0_panel_send_sequence(lcd, SEQ_GAMMA_SETTING);
>>> +    ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ETC_CONDITION_SET);
>>> +    ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ACL_ON);
>>> +    ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ELVSS_ON);
>>> +
>>> +    return ret;
>>> +}
>>
>> Well.  If one call to s6e63m0_panel_send_sequence() returns -ENOMEM and
>> another call returns -EIO (for example), this function will return some
>> other, incorrect errno.
>>
>> Which is a rather minor problem, unless some caller is explicitly
>> looking for some particular error code, which doesn't happen often.
>
> Why not handle the calls with a loop?
>
> +static int s6e63m0_ldi_init(struct s6e63m0 *lcd)
> +{
> +       const unsigned short *init_seq[] = {
> +               SEQ_PANEL_CONDITION_SET,
> +               SEQ_DISPLAY_CONDITION_SET,
> +               SEQ_GAMMA_SETTING,
> +               SEQ_ETC_CONDITION_SET,
> +               SEQ_ACL_ON,
> +               SEQ_ELVSS_ON,
> +       };
> +       int i, ret;
> +
> +       for (i = 0; i < ARRAY_SIZE(init_seq); i++) {
> +               ret = s6e63m0_panel_send_sequence(lcd, init_seq[i]);
> +               if (ret)
> +                       break;
> +       }
> +       return ret;
> +}
>
> Note that _s6e63m0_gamma_ctl has the same issue.  Actually, the whole
> driver has issues with returning errors properly.
>
> Regards,
> Hartley
