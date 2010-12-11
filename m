Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0LKAMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:12:07 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37086 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257Ab0LKAMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 19:12:06 -0500
Date: Fri, 10 Dec 2010 16:11:51 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, jmorris@namei.org, eugeneteo@kernel.org,
        mingo@elte.hu, davem@davemloft.net
Subject: Re: [PATCH v2] kptr_restrict for hiding kernel pointers from
 unprivileged users
Message-ID: <20101211001151.GS4464@outflux.net>
References: <1292025924.2965.20.camel@Dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292025924.2965.20.camel@Dan>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 07:05:24PM -0500, Dan Rosenberg wrote:
> The below patch adds the %pK format specifier, the
> CONFIG_SECURITY_KPTR_RESTRICT configuration option, and the
> kptr_restrict sysctl.
> 
> The %pK format specifier is designed to hide exposed kernel pointers
> from unprivileged users, specifically via /proc interfaces.  Its
> behavior depends on the kptr_restrict sysctl, whose default value
> depends on CONFIG_SECURITY_KPTR_RESTRICT.  If kptr_restrict is set to 0,
> no deviation from the standard %p behavior occurs.  If kptr_restrict is
> set to 1, if the current user (intended to be a reader via seq_printf(),
> etc.) does not have CAP_SYSLOG (which is currently in the LSM tree),
> kernel pointers using %pK are printed as 0's.  This was chosen over the
> default "(null)", which cannot be parsed by userland %p, which expects
> "(nil)".
> 
> v2 improves checking for inappropriate context, on suggestion by Peter
> Zijlstra.  Thanks to Thomas Graf for suggesting use of a centralized
> format specifier.
> 
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

This will come in very handy! Thanks for working on this approach. :)

Acked-by: Kees Cook <kees.cook@canonical.com>

-Kees

-- 
Kees Cook
Ubuntu Security Team
