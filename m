Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0KJP3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:29:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756246Ab0KJP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:29:40 -0500
Date: Wed, 10 Nov 2010 07:26:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, kees.cook@canonical.com
Subject: Re: [PATCH v2] Restrict unprivileged access to kernel syslog
Message-Id: <20101110072638.b0e5473d.akpm@linux-foundation.org>
In-Reply-To: <20101110082516.GB3341@elte.hu>
References: <1289348309.7380.31.camel@dan>
	<20101110082516.GB3341@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 09:25:16 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Dan Rosenberg <drosenberg@vsecurity.com> wrote:
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
> > 
> > v2 adds CONFIG_SECURITY_RESTRICT_DMESG.  When enabled, the default
> > sysctl value is set to "1".  When disabled, the default sysctl value is
> > set to "0".
> > 
> > Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> > CC: Linus Torvalds <torvalds@linux-foundation.org>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Kees Cook <kees.cook@canonical.com>
> > CC: stable <stable@kernel.org>
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> Linus, Andrew, any objections against pushing this trivial control flag upstream out 
> of band, after a bit of testing? It's not like it can break anything, and the flag 
> is very useful to distros.
> 

OK by me, apart from ...

a) I'd question the need for the config option.  Are distros really
   so lame that they can't trust themselves to poke a number into
   procfs at boot time?

b) we have "dmesg_restrict" and "CONFIG_RESTRICT_DMESG".  Less
   dyslexia, please.
