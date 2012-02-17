Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab2BQRIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:08:48 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37183 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831Ab2BQRIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:08:46 -0500
X-Sasl-enc: 5PVurBlaBjjDeIvTBPOu4+BG2kBDET1ISEZsA9QUNcno 1329498525
Date: Fri, 17 Feb 2012 09:04:07 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20120217170407.GA25775@kroah.com>
References: <20120217151030.59ce998d4b844faa0023750b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217151030.59ce998d4b844faa0023750b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 03:10:30PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/built-in.o: In function `r2hb_hb_group_drop_item':
> heartbeat.c:(.text+0x12cd7a): undefined reference to `config_item_put'
> drivers/built-in.o: In function `r2hb_hb_group_make_item':
> heartbeat.c:(.text+0x12cdc7): undefined reference to `config_item_put'
> drivers/built-in.o: In function `r2hb_alloc_hb_set':
> (.text+0x12cf2f): undefined reference to `config_group_init_type_name'
> drivers/built-in.o: In function `r2nm_cluster_group_drop_item':
> nodemanager.c:(.text+0x12d34f): undefined reference to `config_item_put'
> nodemanager.c:(.text+0x12d378): undefined reference to `config_item_put'
> drivers/built-in.o: In function `r2nm_node_put':
> (.text+0x12d3a0): undefined reference to `config_item_put'
> drivers/built-in.o: In function `r2nm_node_group_drop_item':
> nodemanager.c:(.text+0x12dc4d): undefined reference to `config_item_put'
> drivers/built-in.o: In function `r2nm_node_get':
> (.text+0x12e407): undefined reference to `config_item_get'
> drivers/built-in.o: In function `r2nm_get_node_by_ip':
> (.text+0x12e482): undefined reference to `config_item_get'
> drivers/built-in.o: In function `r2nm_get_node_by_num':
> (.text+0x12e514): undefined reference to `config_item_get'
> drivers/built-in.o: In function `r2nm_node_group_make_item':
> nodemanager.c:(.text+0x12e664): undefined reference to `config_item_init_type_name'
> drivers/built-in.o: In function `r2nm_cluster_group_make_group':
> nodemanager.c:(.text+0x12e762): undefined reference to `config_group_init_type_name'
> nodemanager.c:(.text+0x12e77f): undefined reference to `config_group_init_type_name'
> drivers/built-in.o: In function `r2nm_depend_item':
> (.text+0x12e878): undefined reference to `configfs_depend_item'
> drivers/built-in.o: In function `r2nm_undepend_item':
> (.text+0x12e8a0): undefined reference to `configfs_undepend_item'
> drivers/built-in.o: In function `r2nm_depend_this_node':
> (.text+0x12e907): undefined reference to `config_item_put'
> drivers/built-in.o: In function `r2nm_undepend_this_node':
> (.text+0x12e973): undefined reference to `config_item_put'
> drivers/built-in.o: In function `init_r2nm':
> nodemanager.c:(.init.text+0xefdb): undefined reference to `config_group_init'
> nodemanager.c:(.init.text+0xf00f): undefined reference to `configfs_register_subsystem'
> drivers/built-in.o: In function `exit_r2nm':
> nodemanager.c:(.exit.text+0x99b): undefined reference to `configfs_unregister_subsystem'
> 
> This after I moved the tmem tree to before the staging tree to fix
> yesterday's build failure.
> 
> I have cherry-picked Greg's patch to disable building of the ramster code
> for today (since it wasn't in his tree when I fetched it this morning).

Thank you for doing that, sorry I didn't get any of these build errors
on my own.  That's what I get for applying patches while on the road and
away from my big build systems to verify this :(

greg k-h
