Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab1CIU4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 15:56:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1CIU4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 15:56:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110309193330.12181.92080.stgit@paris.rdu.redhat.com>
References: <20110309193330.12181.92080.stgit@paris.rdu.redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        serge.hallyn@canonical.com, morgan@kernel.org
Subject: Re: [PATCH -v2] capabilites: allow the application of capability limits to usermode helpers
Date: Wed, 09 Mar 2011 20:47:21 +0000
Message-ID: <18525.1299703641@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> wrote:

> There is no way to limit the capabilities of usermodehelpers. This problem
> reared its head recently when someone complained that any user with
> cap_net_admin was able to load arbitrary kernel modules, even though the user
> didn't have cap_sys_module.  The reason is because the actual load is done by
> a usermode helper and those always have the full cap set.  This patch addes new
> sysctls which allow us to bound the permissions of usermode helpers.
> 
> /proc/sys/kernel/usermodehelper/bset
> /proc/sys/kernel/usermodehelper/inheritable
> 
> You must have CAP_SYS_MODULE to change these (changes are &= ONLY).
> When the kernel launches a usermodehelper it will do so with these as
> the bset and pI.
> 
> -v2:	make globals static
> 	create spinlock to protect globals
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> No-objection-from: Serge E. Hallyn <serge.hallyn@canonical.com>

Acked-by: David Howells <dhowells@redhat.com>
