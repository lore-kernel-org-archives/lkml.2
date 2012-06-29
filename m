Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab2F2Coj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 22:44:39 -0400
Received: from nat.nue.novell.com ([195.135.221.2]:50606 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2F2Coh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 22:44:37 -0400
Subject: Re: [PATCH] backlight: add support for disabling backlights via
 sysfs
From: joeyli <jlee@suse.com>
To: seth.forshee@canonical.com
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <20120628211936.GA14286@srcf.ucam.org>
References: <1340910426-13269-1-git-send-email-seth.forshee@canonical.com>
	 <20120628191043.GA9777@srcf.ucam.org>
	 <20120628193017.GA29456@thinkpad-t410>
	 <20120628193652.GB10945@srcf.ucam.org>
	 <20120628211600.GB29456@thinkpad-t410>
	 <20120628211936.GA14286@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jun 2012 10:43:59 +0800
Message-ID: <1340937839.6196.212.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2012-06-28 於 22:19 +0100，Matthew Garrett 提到：
> On Thu, Jun 28, 2012 at 04:16:00PM -0500, Seth Forshee wrote:
> 
> > What I still don't understand is your reason for preferring
> > driver-specific interfaces for disabling backlights to a single generic
> > interface. Are you afraid that allowing it to be done from userspace
> > will make it too easy, and as a result quirks will be applied without
> > attempting to fix the problem (i.e. the quriking should go through a
> > kernel dev to ensure someone tries to fix the problem is made before
> > applying a quirk)?
> 
> Yup, that. We'll just end up with three billion forum posts telling 
> people to add a line to a text file and nobody will ever fix the real 
> problem.
> 

Yes, we can not just hide this issue. It's entirely a manufacturers'
problem.

More and more machines have broken _BCM is because ODM didn't really
follow WDDM spec to maintain standard acpi interface for compatibility,
e.g. XP or Linux that don't support WDDM:
	http://msdn.microsoft.com/en-us/windows/hardware/gg487382.aspx

In WDDM architecture, in spec p.5, there have a "Monitor" driver to
check the WDDM driver support brightness DDI, if not, then it will use
standard acpi method to control brightness.

Unfortunately, no OEM preload Windows XP, now. So, more and more ODM
didn't test _BCM, actaully, they never test it, ODM QA just test the
brightness control UI available on newest Windows version (Windows 7).

We cann't just follow windows approach because it causes standard acpi
method neglected. If we also do that, then _BCM function will have no
chance to fix by any manufacturers because it's really nobody care.

Currently, on Linux we default use _BCM to control brightness, video
driver is a fallback. And we enable this fallback in platform driver.
It can keep still have people pay attention on standard acpi methods.


Thanks a lot!
Joey Lee


