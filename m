Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416Ab1IOSlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:41:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40523 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934209Ab1IOSlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:41:12 -0400
Date: Thu, 15 Sep 2011 20:41:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "'Chaoming_Li'" <chaoming_li@realsil.com.cn>
Subject: Re: 3.1-rc6+ rtl8192se issue
Message-ID: <20110915184112.GA16533@gere.osrc.amd.com>
References: <20110915124406.GA14374@gere.osrc.amd.com>
 <4E721871.7040901@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E721871.7040901@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 10:23:29AM -0500, Larry Finger wrote:
> Thanks for the report. I have been running rtl8192se for the past
> few days and I have also noticed two such system freezes, but not

Ah ok, so it's not only me seeing this.

> I expect that you are running a mainline kernel from Linus's tree.

It is Linus' tree: v3.1-rc6-10-g003f6c9

> If not, please let me know. Mine is 3.1-rc4 from the
> wireless-testing tree. I don't recall any changes in out
> "next-flavored" version that are not in 3.1.
> 
> Which flavor of RTL8192SE card do you have? The one I'm running
> shows as "Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN
> Controller [10ec:8172] (rev 10)", but I have two others. The
> differences are in the number of TX and RX streams. Mine is the 1x2
> variety.

lspci says:

03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller [10ec:8172] (rev 10)

so it is exactly the same as yours.

> How frequently do your freezes occur? As I said before, I have only
> had two in 2 or 3 days, which would make bisection tricky.

Well, I can reproduce it pretty reliably: it happens shortly after I
up the iface and establish the WIFI connection with wpa_supplicant. A
couple of minutes after that, more or less, the box grinds down to a
halt.

> I see from the dump that you have x86_64 architecture. How many CPUs
> and how fast? There is one questionable report of problems on a box
> with an 8-way fast processor. That was on initialization and is not
> the same, but may indicate a problem. My system has a dual AMD CPU
> at 2.0 GHz.

I don't think that has any effect on the wifi iface but here it is: dual
core K8 laptop:

...
processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 107
model name      : AMD Turion(tm) Neo X2 Dual Core Processor L625
stepping        : 2
cpu MHz         : 800.000

this is of cource the lowest P-state freq - P0 is 1.6GHz.

> Would you also try loading rtl8192se with the "ips=0" option? As
> power save is implicated in your traceback, that may help. I will be
> trying "swlps=0 ips=0".

Ok, I'll run both just in case and let you know.

Thanks for looking into this.

-- 
Regards/Gruss,
Boris.
