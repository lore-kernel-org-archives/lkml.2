Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab1BQQqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:46:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56677 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1BQQqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:46:52 -0500
MIME-Version: 1.0
In-Reply-To: <20110217132612.GB13500@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
 <1295843342-1122-14-git-send-email-bigeasy@linutronix.de> <20110216221108.GJ22837@angua.secretlab.ca>
 <20110217132612.GB13500@www.tglx.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 17 Feb 2011 09:46:30 -0700
X-Google-Sender-Auth: m5SgsdrueDk0GunF0ATTnlxxChc
Message-ID: <AANLkTikqq9iKkZbg642PJq4hPJS493TrxY8Hx0e63rZv@mail.gmail.com>
Subject: Re: [sodaville] [PATCH OF 13/14] rtc/cmos: add OF bindings
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 6:26 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> * Grant Likely | 2011-02-16 15:11:08 [-0700]:
>
>>> diff --git a/Documentation/powerpc/dts-bindings/rtc-cmos.txt b/Documentation/powerpc/dts-bindings/rtc-cmos.txt
>>> new file mode 100644
>>> index 0000000..7382989
>>> --- /dev/null
>>> +++ b/Documentation/powerpc/dts-bindings/rtc-cmos.txt
>>
>>Move to Documentation/devicetree/bindings/rtc/
> moved.
>
>>> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
>>> index c7ff8df..2709e00 100644
>>> --- a/drivers/rtc/rtc-cmos.c
>>> +++ b/drivers/rtc/rtc-cmos.c
>>> @@ -1162,6 +1205,9 @@ static struct platform_driver cmos_platform_driver = {
>>>  #ifdef CONFIG_PM
>>>              .pm             = &cmos_pm_ops,
>>>  #endif
>>> +#if defined(CONFIG_OF)
>>> +            .of_match_table = of_cmos_match,
>>> +#endif
>>
>>The #if defined(CONFIG_OF) is no longer necessary around
>>.of_match_table, particularly if you have a #else above that #defines
>>of_cmos_match to NULL.
>
> Kinda does not work. I get here:
> |drivers/rtc/rtc-cmos.c:1209:3: error: unknown field â  of_match_tableâ   specified in initializer
>
> I rebased on top of -rc5. Is this something new you describing?

Base your patch on top of my devicetree/next branch.  That's the
branch that tglx will be applying them on top of them to get your
changes to generic pci dt support code.

g.
