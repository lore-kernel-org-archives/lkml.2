Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab1GARHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 13:07:54 -0400
Received: from mail.perches.com ([173.55.12.10]:3424 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab1GARHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 13:07:52 -0400
Subject: [rfc] Remove member .name from struct netpoll
From: Joe Perches <joe@perches.com>
To: netdev <netdev@vger.kernel.org>
Cc: Cong Wang <amwang@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 10:07:51 -0700
Message-ID: <1309540071.7277.63.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct netpoll has member .name

struct netpoll {
	struct net_device *dev;
	char dev_name[IFNAMSIZ];
	const char *name;
[...]
};

that is set only by netconsole.c

static struct netconsole_target *alloc_param_target(char *target_config)
{
[...]
	nt->np.name = "netconsole";

and used only by net/core/netpoll.c to emit "netconsole: " on
logging messages.

e.g.

void netpoll_print_options(struct netpoll *np)
{
	printk(KERN_INFO "%s: local port %d\n",
			 np->name, np->local_port);

I think it'd be more common to use pr_fmt and pr_<level>
to emit these logging messages.

Are there out of tree users or plans to use "struct netpoll"
by other modules?

If not, I propose to remove name from the struct.

