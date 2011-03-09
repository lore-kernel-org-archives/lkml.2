Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1CIViU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:38:20 -0500
Received: from kroah.org ([198.145.64.141]:43638 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab1CIViT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:38:19 -0500
Date: Wed, 9 Mar 2011 13:38:13 -0800
From: Greg KH <greg@kroah.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, serge.hallyn@canonical.com,
        morgan@kernel.org
Subject: Re: [PATCH -v2] capabilites: allow the application of capability
 limits to usermode helpers
Message-ID: <20110309213813.GA28009@kroah.com>
References: <20110309193330.12181.92080.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309193330.12181.92080.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 02:33:31PM -0500, Eric Paris wrote:
> There is no way to limit the capabilities of usermodehelpers. This problem
> reared its head recently when someone complained that any user with
> cap_net_admin was able to load arbitrary kernel modules, even though the user
> didn't have cap_sys_module.  The reason is because the actual load is done by
> a usermode helper and those always have the full cap set.  This patch addes new
> sysctls which allow us to bound the permissions of usermode helpers.
> 
> /proc/sys/kernel/usermodehelper/bset
> /proc/sys/kernel/usermodehelper/inheritable

Shouldn't these be documented somewhere?  Documentation/ABI?

> You must have CAP_SYS_MODULE to change these (changes are &= ONLY).

Why that permission?  Just because 'modprobe' is usually run from this
callback?  Or some other reason?

> When the kernel launches a usermodehelper it will do so with these as
> the bset and pI.

Shouldn't the caller of these functions be the ones dictating the
capabilities it should be run with?

thanks,

greg k-h
