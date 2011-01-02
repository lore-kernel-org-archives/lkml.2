Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1ABJFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:05:44 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:59040 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751257Ab1ABJFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:05:42 -0500
Date: Sun, 2 Jan 2011 10:05:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
        kees.cook@canonical.com, akpm@linux-foundation.org,
        security@kernel.org
Subject: Re: [PATCH v3] Restrict unprivileged access to kernel syslog
Message-ID: <20110102090541.GL32469@atrey.karlin.mff.cuni.cz>
References: <1289431735.3847.9.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289431735.3847.9.camel@dan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The kernel syslog contains debugging information that is often useful
> during exploitation of other vulnerabilities, such as kernel heap
> addresses.  Rather than futilely attempt to sanitize hundreds (or
> thousands) of printk statements and simultaneously cripple useful
> debugging functionality, it is far simpler to create an option that
> prevents unprivileged users from reading the syslog.
> 
> This patch, loosely based on grsecurity's GRKERNSEC_DMESG, creates the
> dmesg_restrict sysctl.  When set to "0", the default, no restrictions
> are enforced.  When set to "1", only users with CAP_SYS_ADMIN can read
> the kernel syslog via dmesg(8) or other mechanisms.

Ok, this is very very ugly.

You essentially create a bit to control what other bit does. Clean
solution would be CAP_SYS_DMESG, and make sure that is given to
processes by default...

...and that would be actually very good thing -- on cellphones, you
want some users without ability to connect to network, so you could
introduce CAP_NETWORK etc...

								Pavel
