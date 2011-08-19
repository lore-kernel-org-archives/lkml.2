Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1HSV5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:57:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53733 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1HSV5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:57:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Pihet-XID, Jean" <j-pihet@ti.com>
Subject: Re: linux-next: build failure after merge of the final tree (pm tree related)
Date: Fri, 19 Aug 2011 23:58:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20110819130328.ee5c4b7191db0ce2c8a02e39@canb.auug.org.au> <CAN5iSWpGKF4qu5yqeDk=nxvq0tVs6+mozAEJ+FLdh=Ryx-hsEA@mail.gmail.com>
In-Reply-To: <CAN5iSWpGKF4qu5yqeDk=nxvq0tVs6+mozAEJ+FLdh=Ryx-hsEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201108192358.51522.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 19, 2011, Pihet-XID, Jean wrote:
> Hi Stephen, Rafael,
> 
> On Fri, Aug 19, 2011 at 5:03 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi all,
> >
> > After merging the final tree, today's linux-next build (powerpc
> > allnoconfig) failed like this:
> >
> > In file included from include/linux/netdevice.h:34:0,
> >                 from include/linux/icmpv6.h:173,
> >                 from include/linux/ipv6.h:220,
> >                 from include/net/ipv6.h:16,
> >                 from include/linux/sunrpc/clnt.h:25,
> >                 from include/linux/nfs_fs.h:50,
> >                 from init/do_mounts.c:20:
> > include/linux/pm_qos.h: In function 'dev_pm_qos_add_request':
> > include/linux/pm_qos.h:123:6: warning: 'return' with no value, in function returning non-void
> > include/linux/pm_qos.h: In function 'dev_pm_qos_update_request':
> > include/linux/pm_qos.h:126:6: warning: 'return' with no value, in function returning non-void
> > include/linux/pm_qos.h: In function 'dev_pm_qos_remove_request':
> > include/linux/pm_qos.h:128:6: warning: 'return' with no value, in function returning non-void
> >
> > Caused by commit b6d5b88750dc ("PM QoS: Implement per-device PM QoS
> > constraints").
> I am really sorry about this. This build failure is indeed due to my
> patch which has stubs for the !PM case.
> Here is an updated patch (attached), the only change is in the stubs.
> 
> >
> > Please, please compile test with CONFIG options that your patch depends
> > on switched on and switched off - in this case CONFIG_PM.
> Well, it is not as easy as it seems. As the patch set describes, I am
> build testing for x86 and OMAP. At the moment due to config
> dependencies it is _impossible_ to disable PM in the OMAP config.
> 
> Also I cannot build test every platform out there.
> Do you have a procedure for build testing?
> 
> >
> > I have reverted that commit (and the followinf commit 57afcf09649c ("PM
> > QoS: Add global notification mechanism for device constraints")) for
> > today.
> Can we have the updated version merged in?

Merged and pushed back.

Thanks,
Rafael
