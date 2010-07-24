Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab0GXJ7L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 05:59:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:50777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab0GXJ7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 05:59:09 -0400
Message-ID: <4C4AB952.9030705@kernel.org>
Date: Sat, 24 Jul 2010 11:58:42 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, ben.collins@ubuntu.com,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, hmh@debian.org
Subject: support for drives larger than 2TiB
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 24 Jul 2010 09:58:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been playing with a SATA 2.5T drive and things don't look too
bad.  All four controllers I've tested worked fine and the driver and
kernel worked just fine.  Even BIOSes don't seem too bad.  At least
the two boards I tested (both about three years old) didn't have much
problem recognizing upto 2TiB and could access and boot fine although
I'm fairly sure there will be BIOSes which would behave erratically.

I also tested installing w/ openSUSE 11.3 and it worked fine.  It
automatically chose GPT and alignment and everything just worked (tm).
I think the situation shouldn't be too different for any distro which
uses up-to-date parted.

The only problem is that everything which is necessary for booting
needs to be located below 2TiB limit.  Please note that this is much
stricter restriction than the 128GiB limit we had due to LBA28.  That
limit was caused by BIOSes using LBA28 and vendors could and did
update and be done with it in many cases.  However, 2TiB limit is
inherent in the BIOS programming interface and currently the only way
to overcome it is using a completely different BIOS interface (EFI,
that is).  Vendors are not likely to introduce EFI for already
released products although they're much more likely to release updates
so that BIOSes can access upto 2TiB if they don't work already.  We'll
be stuck with 2TiB limit on much more configurations for longer period
of time.

So, distro installers need to try to locate everything needed for
bootstrapping below 2TiB limit (ie. a dedicated boot partition below
the limit).  Drives > 2TiB aren't on the market yet but aren't too far
away.  Let's make sure things will be ready by the next distro release
cycle.

Thanks.

-- 
tejun
