Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab2LMTJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:09:41 -0500
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:39201 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2LMTJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:09:40 -0500
Date: Thu, 13 Dec 2012 14:07:42 -0500
From: "Gabriel L. Somlo" <somlo@cmu.edu>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Guenter Roeck <groeck-dsl@sbcglobal.net>, khali@linux-fr.org,
        linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, agraf@suse.de, rene@exactcode.com
Subject: Re: [PATCH v2] applesmc: add sysfs file to report OSK
Message-ID: <20121213190742.GQ2097@hedwig.ini.cmu.edu>
References: <20121210195414.GA642@polaris.bitmath.org>
 <20121210222313.GF2097@hedwig.ini.cmu.edu>
 <20121212230128.GE16373@lobsang.ini.cmu.edu>
 <20121213072011.GA515@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213072011.GA515@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, DATE_TZ_NEG_0500 0, ECARD_WORD 0, FROM_EDU_TLD 0, NO_URI_FOUND 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __INT_PROD_COMP 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __PHISH_SPEAR_STRUCTURE_1 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 08:20:11AM +0100, Henrik Rydberg wrote:
> > The only viable (from a legal CYA standpoint) thing I can think of is
> > to make it easy to acquire the OSK automatically, on demand, directly
> > from the hardware. Right now, the logical place for that is applesmc.ko.
> > It already controls access to the SMC, and already reports values for
> > various keys.
> 
> How about encrypting the string with a key only found on an Apple
> computer? There are strings available in both ACPI and EFI that could
> serve such a purpose.

I'd still be distributing the copyrighted string. I don't expect
encryption to placate the proverbial lawyers, nor the project/distro
maintainers who want to avoid them :)

Plus, now I'd also be taking on the responsibility of deciding when
it's (legally) OK to let QEMU boot OS X and when it isn't.

Besides, the most obvious Apple-only key that fits your description
is the OSK itself ! :)

> Regarding the patch, I agree with Guenter that putting more unrelated
> things into the hwmon subsystem makes no sense. Most of the
> information in applesmc should go into the hwmon, thermal, backlight
> and input subsystems, but some strings should go somewhere else (maybe
> /sys/firmware/smc/?). The reluctance you experience here is a
> technical one; someone will need to make an effort to create a good
> place for your string, and it does not help that the string is, in
> fact, a constant. :-)
> 
> So, don't give up hope, but please do not expect an immediate solution.

OK, so if we agree that for legal-CYA reasons we must pretend to
ignore the constant-ness of the key value, are we now talking about
simply where in the sysfs hierarchy to place the node that will
spit it out ?

Right now it's under /sys/devices/platform/applesmc.768/
(i.e., it's a device, it's platform specific, and it's name is
applesmc-something).

The only ties to "hwmon" are that:
	- there's a "/sys/class/hwmon/hwmonX" symlink to the above
	  directory (among others, such as the graphics card and two
	  instances of "coretemp", at least on my MacPro5,1);
	- *most* of the files in it are indeed reporting sensor
	  readings;
	- the applesmc.c device driver source file itself lives under
	  drivers/hwmon/ in the kernel source tree.

Is it common practice to split off a subset of the values reported
by such a chip and make them show up elsehere (i.e. besides the
/sys/devices/platform/<chipname> folder) ? Does the relative size
of the subsets involved count as input into that decision proces ? :)

I personally don't know enough to have an opinion on where the best
place for this might be. You suggested "/sys/firmware/smc/", and I'd
be perfectly happy with that one too. Do you know who would decide
whether that's an acceptable alternative to /sys/devices/platform/applesmc ?

Thanks again,
--Gabriel
