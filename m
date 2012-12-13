Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2LMHRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 02:17:22 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:57430 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2LMHRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 02:17:21 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1FAHR/yVBV5qjOPGdsb2JhbABFDoVBhSOzfRcDAQEBATg0gh4BAQQBOhwjBQsIA0YUJQoaLodwCr41FJAZYQOWCIV7jQM/
X-IronPort-AV: E=Sophos;i="4.84,272,1355094000"; 
   d="scan'208";a="247503011"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 13 Dec 2012 08:20:11 +0100
To: "Gabriel L. Somlo" <somlo@cmu.edu>
Cc: Guenter Roeck <groeck-dsl@sbcglobal.net>, khali@linux-fr.org,
        linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, agraf@suse.de, rene@exactcode.com
Subject: Re: [PATCH v2] applesmc: add sysfs file to report OSK
Message-ID: <20121213072011.GA515@polaris.bitmath.org>
References: <20121210195414.GA642@polaris.bitmath.org>
 <20121210222313.GF2097@hedwig.ini.cmu.edu>
 <20121212230128.GE16373@lobsang.ini.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212230128.GE16373@lobsang.ini.cmu.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabriel,

> I could try to hardcode the OSK inside QEMU, or I could try to include
> it as a default config file entry, but I'm quite certain the QEMU project
> would be uncomfortable "distributing" a string on which Apple claims
> copyright. Even if that happened, distros might then balk at shipping
> QEMU as part of their package repositories, for the exact same reason.

I understand this is frustrating, and I believe you have made a good
case for the rationale. However, the technical issues remain. Also,
there might still be other, simpler, solutions.

> The only viable (from a legal CYA standpoint) thing I can think of is
> to make it easy to acquire the OSK automatically, on demand, directly
> from the hardware. Right now, the logical place for that is applesmc.ko.
> It already controls access to the SMC, and already reports values for
> various keys.

How about encrypting the string with a key only found on an Apple
computer? There are strings available in both ACPI and EFI that could
serve such a purpose.

Regarding the patch, I agree with Guenter that putting more unrelated
things into the hwmon subsystem makes no sense. Most of the
information in applesmc should go into the hwmon, thermal, backlight
and input subsystems, but some strings should go somewhere else (maybe
/sys/firmware/smc/?). The reluctance you experience here is a
technical one; someone will need to make an effort to create a good
place for your string, and it does not help that the string is, in
fact, a constant. :-)

So, don't give up hope, but please do not expect an immediate solution.

Thanks.
Henrik
