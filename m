Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2F2HT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 03:19:28 -0400
Received: from nat.nue.novell.com ([195.135.221.2]:14910 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2F2HT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 03:19:27 -0400
Subject: Re: [PATCH] backlight: add support for disabling backlights via
 sysfs
From: joeyli <jlee@suse.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: seth.forshee@canonical.com, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>
In-Reply-To: <20120629025724.GB18605@srcf.ucam.org>
References: <1340910426-13269-1-git-send-email-seth.forshee@canonical.com>
	 <20120628191043.GA9777@srcf.ucam.org>
	 <20120628193017.GA29456@thinkpad-t410>
	 <20120628193652.GB10945@srcf.ucam.org>
	 <20120628211600.GB29456@thinkpad-t410>
	 <20120628211936.GA14286@srcf.ucam.org>
	 <1340937839.6196.212.camel@linux-s257.site>
	 <20120629025724.GB18605@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jun 2012 15:18:49 +0800
Message-ID: <1340954329.6196.273.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 五，2012-06-29 於 03:57 +0100，Matthew Garrett 提到：
> On Fri, Jun 29, 2012 at 10:43:59AM +0800, joeyli wrote:
> 
> > 	http://msdn.microsoft.com/en-us/windows/hardware/gg487382.aspx
> >
> > In WDDM architecture, in spec p.5, there have a "Monitor" driver to
> > check the WDDM driver support brightness DDI, if not, then it will use
> > standard acpi method to control brightness.
> 
> What's the interaction between GPU drivers and platform drivers? For 
> instance, on acer systems that have backlight control via WMI, does 
> Windows use WMI, the GPU driver or ACPI?
>  

I think GPU driver.

Because there have no wmi method support backlight control on modern
Acer machine and _BCM also broken on some machines.


On old machines that have 6AF4F258 wmi method, it supported to set
brightness level through wmi. But 6AF4F258 is really old now and almost
broken or not provide by new acer BIOS.

So, it is clear for modern Acer machines do NOT use wmi to control
backlight. It must control brightness through acpi or GPU driver.
(For very very new machine maybe changed again, need to check.)

Have a a period of time, acer BIOS provide healthful _BCM
implementation, in _BCM, they changed brightness through OPregion or
write EC register.

But now, some machines have broken _BCM and they are also not control
brightness through WMI, that means the brightness control is through GPU
driver.

Per WDDM spec, if WDDM driver support DDI, the NORMAL code path of
brightness control is:
	Mobility Center(userland) -> Monitor Driver -> WDDM Driver -> Graphics Adapter


Reviewed DSDT from Acer machines, I believe Acer didn't force ODM fully implement
Acer's WMI space. So, also need to check with Acer for how many ODM really follow WDDM spec.






 



