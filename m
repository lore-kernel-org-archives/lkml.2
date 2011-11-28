Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1K1UbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:31:15 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:56461 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab1K1UbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:31:14 -0500
Date: Mon, 28 Nov 2011 21:31:13 +0100 (CET)
From: "Nicolas Kalkhof" <nkalkhof@web.de>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <492649473.3864850.1322512273580.JavaMail.fmail@mwmweb020>
Subject: Re: Too many poll_idle cpu calls in kernel 3.2 rc-series
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: normal
Sensitivity: Normal
X-Provags-ID: V01U2FsdGVkX19XpxYdMAmW1ArwEp2RoB386ZUlWbBoNrgCJH8joGBwnkfFMkv67ZkM
 uRH13VKkcKcskMC20JacfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

correct. The issue was introduced somewhere between 3.1 final and 3.2-rc1. I've tried to track down the bad commit but so far I haven't been successfull. The only workaround I found is to set the idle boot parameter to mwait and to disable CONFIG_INTEL_IDLE. Somehow the kernel seems to set idle to poll by default - no idea why :-(. I wonder if other mobile sandy bridge cpus are affected as well.

Regards,
Nic

-----Ursprüngliche Nachricht-----
Von: "Andi Kleen" <andi@firstfloor.org>
Gesendet: Nov 28, 2011 8:33:28 PM
An: "Nicolas Kalkhof" <nkalkhof@web.de>
Betreff: Re: Too many poll_idle cpu calls in kernel 3.2 rc-series

>"Nicolas Kalkhof" <nkalkhof@web.de> writes:
>
>> the kernel v3.2 series shows excessive poll_idle calls during system idle phases causing the cpu
>> (mobile i7 2620M) to heat up and draw additional 10% more power.  All kernel versions between
>> 3.2-rc1 and 3.2-rc3 are affected. Perf Top and Powertop both show the same issue.
>> I've posted a similar bug report before: http://marc.info/?l=linux-kernel&m=132164909313594&w=2
>> and used perf top -U to verify the poll_idle calls as requested.
>
>So it didn't happen with earlier kernels?
>I would suggest a git bisect in this case.
>
>-Andi
>
>--
>ak@linux.intel.com -- Speaking for myself only
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at http://www.tux.org/lkml/


___________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192
