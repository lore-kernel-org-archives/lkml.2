Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1GDCHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 22:07:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab1GDCHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 22:07:11 -0400
Message-ID: <4E112044.8050904@redhat.com>
Date: Mon, 04 Jul 2011 10:07:00 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [rfc] Remove member .name from struct netpoll
References: <1309540071.7277.63.camel@Joe-Laptop>
In-Reply-To: <1309540071.7277.63.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年07月02日 01:07, Joe Perches 写道:
> struct netpoll has member .name
>
> struct netpoll {
> 	struct net_device *dev;
> 	char dev_name[IFNAMSIZ];
> 	const char *name;
> [...]
> };
>
> that is set only by netconsole.c
>
> static struct netconsole_target *alloc_param_target(char *target_config)
> {
> [...]
> 	nt->np.name = "netconsole";
>
> and used only by net/core/netpoll.c to emit "netconsole: " on
> logging messages.
>

Probably this is due to that in history netdump was another user of it.

>
> Are there out of tree users or plans to use "struct netpoll"
> by other modules?
>

AFAIK, netoops will use it too, see
https://lkml.org/lkml/2010/11/2/299

Cc'ing Matt in case I miss something...

Thanks.
