Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1CIUA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 15:00:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab1CIUAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 15:00:54 -0500
Subject: Re: [PATCH -v2] capabilites: allow the application of capability
 limits to usermode helpers
From: Eric Paris <eparis@redhat.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, serge.hallyn@canonical.com,
        morgan@kernel.org
Date: Wed, 09 Mar 2011 15:00:25 -0500
In-Reply-To: <20110309194501.GA9362@albatros>
References: <20110309193330.12181.92080.stgit@paris.rdu.redhat.com>
	 <20110309194501.GA9362@albatros>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1299700826.3411.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 22:45 +0300, Vasiliy Kulikov wrote:
> Eric,
> 
> On Wed, Mar 09, 2011 at 14:33 -0500, Eric Paris wrote:
> > someone complained that any user with
> > cap_net_admin was able to load arbitrary kernel modules, even though the user
> > didn't have cap_sys_module.  The reason is because the actual load is done by
> > a usermode helper and those always have the full cap set.
> 
> AFAIU, your patch sets system-wide caps for _all_ usermode helpers,
> right?  Then it does nothing with cap_net_admin's problem as it should
> restrict caps of specific helpers spawned from specific networking code,
> but not touching anything related to another helpers.

I'm actually solving 2 problems at once and it just so happens the the
CAP_NET_ADMIN brew-ha-ha came up more recently.  The original problem,
and reason I wrote this patch, is because it's impossible on a modern
Linux system to permanently and irrevocably drop capabilities system
wide.  You can get very close by dropping capabilities from the bset
before init is launched which means everything launched by userspace
can't have the dropped capabilities.  But, khelper is still going to
have the full set and thus usermodehelpers launched by the kernel will
have the full set.  This patch allows one to control usermode helpers.
How one chooses to use that, is up to them.

-Eric

