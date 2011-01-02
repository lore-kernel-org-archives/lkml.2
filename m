Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1ABQJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 11:09:30 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:53008 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1ABQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 11:09:29 -0500
Subject: Re: [PATCH v3] Restrict unprivileged access to kernel syslog
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
        kees.cook@canonical.com, akpm@linux-foundation.org,
        security@kernel.org
In-Reply-To: <20110102090541.GL32469@atrey.karlin.mff.cuni.cz>
References: <1289431735.3847.9.camel@dan>
	 <20110102090541.GL32469@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Jan 2011 11:08:55 -0500
Message-ID: <1293984535.9764.65.camel@Dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-02 at 10:05 +0100, Pavel Machek wrote:
> Hi!
> 
> > The kernel syslog contains debugging information that is often useful
> > during exploitation of other vulnerabilities, such as kernel heap
> > addresses.  Rather than futilely attempt to sanitize hundreds (or
> > thousands) of printk statements and simultaneously cripple useful
> > debugging functionality, it is far simpler to create an option that
> > prevents unprivileged users from reading the syslog.
> > 
> > This patch, loosely based on grsecurity's GRKERNSEC_DMESG, creates the
> > dmesg_restrict sysctl.  When set to "0", the default, no restrictions
> > are enforced.  When set to "1", only users with CAP_SYS_ADMIN can read
> > the kernel syslog via dmesg(8) or other mechanisms.
> 
> Ok, this is very very ugly.
> 
> You essentially create a bit to control what other bit does. Clean
> solution would be CAP_SYS_DMESG, and make sure that is given to
> processes by default...
> 
> ...and that would be actually very good thing -- on cellphones, you
> want some users without ability to connect to network, so you could
> introduce CAP_NETWORK etc...
> 
> 								Pavel

The CONFIG was added on suggestion that it would make it easier for
distributions to enable this behavior by default.  The patch was
modified to use CAP_SYSLOG, which seems in line with what you want.  

Thanks,
Dan

