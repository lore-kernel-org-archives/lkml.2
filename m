Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab0KJQc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:32:56 -0500
Received: from smtp.outflux.net ([198.145.64.163]:55070 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab0KJQcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:32:55 -0500
Date: Wed, 10 Nov 2010 08:32:45 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH v2] Restrict unprivileged access to kernel syslog
Message-ID: <20101110163245.GM5876@outflux.net>
References: <1289348309.7380.31.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289348309.7380.31.camel@dan>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 07:18:29PM -0500, Dan Rosenberg wrote:
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
> 
> v2 adds CONFIG_SECURITY_RESTRICT_DMESG.  When enabled, the default
> sysctl value is set to "1".  When disabled, the default sysctl value is
> set to "0".
> 
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Kees Cook <kees.cook@canonical.com>
> CC: stable <stable@kernel.org>

Acked-by: Kees Cook <kees.cook@canonical.com>

As before, this looks fine and does the right thing with regard to /proc
access to the kernel log.

-- 
Kees Cook
Ubuntu Security Team
