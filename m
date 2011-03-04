Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167Ab1CDUcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:32:08 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51653 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760065Ab1CDUcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:32:05 -0500
Date: Fri, 4 Mar 2011 21:32:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] power: disable hibernation if module loading is
 disabled
Message-ID: <20110304203201.GA22079@elf.ucw.cz>
References: <1299255084-4390-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299255084-4390-1-git-send-email-segoon@openwall.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2011-03-04 19:11:24, Vasiliy Kulikov wrote:
> If /proc/sys/kernel/modules_disabled is set to 1, then nobody (even full
> root) may not read/write arbitrary kernel memory.  In spite of it,
> hibernation allows anyone with an access to either /dev/snapshot or
> /sys/power/ make the full snapshot of the system.  This snapshot may be
> freely changed and uploaded back.

module loading has nothing to do with hibernation, and hibernation
already checks for CAP_ADMIN or something similary strong. I don't see
why this new check is needed.

In fact, you are probably breaking someone's setup right now.

> +	if (modules_disabled)
> +		return -EPERM;
> +
>  	error = platform_begin(platform_mode);

Hmm. How is this supposed to work with CONFIG_MODULES off?

NAK.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
