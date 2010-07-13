Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab0GMM3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 08:29:33 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:54035 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab0GMM3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 08:29:31 -0400
Date: Tue, 13 Jul 2010 21:29:25 +0900
From: Simon Horman <horms@verge.net.au>
To: Ismael Luque Valencia <isma.luque@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, Michal Marek <mmarek@suse.cz>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        Julian Anastasov <ja@ssi.bg>, Wensong Zhang <wensong@linux-vs.org>,
        linux-kernel@vger.kernel.org
Subject: Re: IPVS scheduler algorithms (was: [PATCH] ipvs: Kconfig cleanup)
Message-ID: <20100713122925.GA8903@verge.net.au>
References: <1278102728-20217-1-git-send-email-mmarek@suse.cz>
 <20100704070516.GA9437@verge.net.au>
 <20100704071347.GB9437@verge.net.au>
 <4C319B18.10409@trash.net>
 <AANLkTim3FfgxTzQ36YYYA8QG605oNW3skHZlSLKAZcjl@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim3FfgxTzQ36YYYA8QG605oNW3skHZlSLKAZcjl@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 07:15:21PM -0500, Ismael Luque Valencia wrote:
> Hi my name is Ismael, I am doing a paper about lvs algorithms but I dont
> undernstand two of them Locality-Based Least-Connection and Locality-Based
> Least-Connection with Replication
> Someone, who can explain me that algorithms please
> If it is in Spanish will better because my English is not good

Hi,

Firstly, please don't reply to emails unless you are actually
replying to the topic at hand. Instead just compose a fresh
message to the people/lists that you want to address.
This helps keep threads in mail-readers that support them sane.

In any case this question would be better sent to the lvs-users list.

But to your question.

These schedulers are described briefly in the ipvsadm(8) man page
and in pseudo code in the source files (ip_vs_lblc.c and ip_vs_lblcr.c)
in the Linux kernel tree. And there is some discussion in the howto
http://www.austintek.com/LVS/LVS-HOWTO/HOWTO/LVS-HOWTO.ipvsadm.html#DH

The way that I think of these schedulers is as enhanced versions of wlc
designed for use with transparent proxies. That is situations where
there will be a lot of destination addresses.

lblc works by keeping a cache that associates destination addresses with
a real server. This allows accesses, potentially from different end-users,
to be sent to the same real-server. As this is designed to be used
with proxies, this means the request will be sent to a proxy that may
have already retrieved the result.

lblcr is similar, but instead of one real-server per destination, it
allows for multiple real-servers per destination.

