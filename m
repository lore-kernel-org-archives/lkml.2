Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab0KIFep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:34:45 -0500
Received: from smtp.outflux.net ([198.145.64.163]:58078 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab0KIFeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:34:44 -0500
Date: Mon, 8 Nov 2010 21:34:40 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] Restrict unprivileged access to kernel syslog
Message-ID: <20101109053440.GV5876@outflux.net>
References: <1289273338.6287.128.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289273338.6287.128.camel@dan>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 10:28:58PM -0500, Dan Rosenberg wrote:
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
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

Acked-by: Kees Cook <kees.cook@canonical.com>

This looks good to me -- it leaves the /proc file access alone for
priv-dropping ksyslogd implementations.

-Kees

-- 
Kees Cook
Ubuntu Security Team
