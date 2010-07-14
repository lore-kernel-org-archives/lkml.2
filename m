Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab0GNGxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 02:53:41 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57493 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab0GNGxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 02:53:40 -0400
Date: Tue, 13 Jul 2010 23:53:37 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Yama: verify inode is symlink to avoid bind mounts
Message-ID: <20100714065337.GY6104@outflux.net>
References: <20100713223021.GK6104@outflux.net>
 <20100714023048.GB17686@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714023048.GB17686@hallyn.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 09:30:48PM -0500, Serge E. Hallyn wrote:
> Quoting Kees Cook (kees.cook@canonical.com):
> > The inode_follow_link LSM hook is called in bind mount situations as
> > well as for symlink situations, so we must explicitly check for the
> > inode being a symlink to not reject bind mounts in 1777 directories,
> 
> Are you sure about that??
> 
> If that's true, you might also expand the comment in
> include/linux/security.h.
> 
> > which seems to be a common NFSv4 configuration.

Well, the issue is how the NFSv4 client deals with it. It seems to treat
the mounts from the NFSv4 root as a symlink when the server is using bind
mounts.  It's kind of weird:
https://launchpad.net/bugs/604407

-- 
Kees Cook
Ubuntu Security Team
