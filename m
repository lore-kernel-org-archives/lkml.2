Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1EBTKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:10:34 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33052 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab1EBTKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:10:33 -0400
Subject: Re: Long timeout when booting >= 2.6.38
From: john stultz <johnstul@us.ibm.com>
To: Christian Hoffmann <email@christianhoffmann.info>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4DBEFCBA.3070501@christianhoffmann.info>
References: <4DBEFCBA.3070501@christianhoffmann.info>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 12:09:35 -0700
Message-ID: <1304363375.3226.5.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 20:49 +0200, Christian Hoffmann wrote:
> I have a strange hang/timeout when booting kernel 2.6.38 and newer. It 
> hangs after a few initialization steps and then after 145 seconds, it 
> continues to boot.
> 
> I bisected kernel and found that offensive revision is:
> 
> 08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
> "x86: Improve TSC calibration using a delayed workqueue"
> 
> Older kernels before above revision work fine.
> 
> When passing acpi=off to kernel, the problem seems to disappear.

Hrm. So, on older kernels, what do you see from:
$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource 


> Dmesg output below where you can see the jump from 1.47 to 146.85.
> 
> The mainboard is an Asus M4A89GTD PRO/USB3 (latest BIOS revision).
> 
> Kind regards,
> Chris
> 
> PS: the problem has also been reported to ubuntu where more hw 
> information is attached.
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/765230
> PSS: dmesg output

Hrm. The delay in the dmesg logs doesn't really seem to correlate that
closely with the delayed tsc calibration. Hrmm..

thanks
-john


