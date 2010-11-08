Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091Ab0KHFOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 00:14:10 -0500
Received: from smtp.outflux.net ([198.145.64.163]:60655 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab0KHFOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 00:14:09 -0500
Date: Sun, 7 Nov 2010 21:14:02 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH RFC] Restrictions on module loading
Message-ID: <20101108051402.GA5876@outflux.net>
References: <1289179439.3090.205.camel@Dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289179439.3090.205.camel@Dan>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 08:23:59PM -0500, Dan Rosenberg wrote:
> A significant portion of kernel vulnerabilities do not affect core code,
> but rather individual modules.  Unfortunately, there is no global kernel
> setting to restrict unprivileged users from triggering the automatic
> loading of kernel modules, for example by creating a socket using a
> packet family that is compiled as a module and not already loaded.  On
> most distributions, this creates a significant attack surface, and
> requires maintenance of blacklists and other inelegant solutions to a
> general problem.
> 
> The below patch replaces the existing "modules_disable" sysctl with a
> finer-grained "modules_restrict" sysctl.  By default, this is set at 0,
> which results in no deviation from normal module loading behavior.  When
> set to 1, unprivileged users cannot trigger the automatic loading of
> modules.  This behavior is based on grsecurity's GRKERNSEC_MODHARDEN
> setting.  The current check is against current_uid(), since several
> distributions explicitly remove CAP_SYS_MODULE from root processes, some
> of which incidentally cause (and rely on) the automatic loading of
> modules.  I expect this to be a point of discussion.
> 
> When set to 2, modules may not be loaded or unloaded by anyone, and the
> sysctl may not be changed from that point forward.  This is designed to
> provide protection against kernel module rootkits.
> 
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

Acked-by: Kees Cook <kees.cook@canonical.com>

This looks great to me. There will be a small amount of pain for people
that are already using modules_disabled=1, but I think the audience is so
small that it won't be a problem to switch to modules_restrict=2.

-Kees

-- 
Kees Cook
Ubuntu Security Team
