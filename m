Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343Ab0GTQdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 12:33:08 -0400
Received: from mandjes.xs4all.nl ([82.95.177.154]:43925 "EHLO
	mandjes.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab0GTQdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 12:33:06 -0400
Subject: Re: [git pull v2] documentation: fix almost duplicate filenames  (io/IO-mapping.txt)
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kees Bakker <kees.bakker@xs4all.nl>
In-Reply-To: <4C45C33C.9090907@oracle.com>
Date: Tue, 20 Jul 2010 18:33:03 +0200
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <298FDE5E-9721-42C1-AEED-124278D60B4C@xs4all.nl>
References: <20100719181240.fc3066cd.randy.dunlap@oracle.com> <AANLkTilwV9PPdpM5JZ65M_TYr_XfVDBHCLXLJVYkTEav@mail.gmail.com> <4C45C33C.9090907@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Jul, 2010, at 17:39 , Randy Dunlap wrote:

> Please pull from
> 	git://git.kernel.org/pub/scm/linux/kernel/git/rdunlap/linux-docs/ #linuxdocs
> 
> for one changeset:
> 
> commit f0e4984f0df34e344809c35387d895b57eab5dcc
> Author: Randy Dunlap <randy.dunlap@oracle.com>
> Date:   Mon Jul 19 22:20:27 2010 +0000
> 
>    Subject: documentation: fix almost duplicate filenames (IO/io-mapping.txt)
>    From: Randy Dunlap <randy.dunlap@oracle.com>
> 
>    Having both IO-mapping.txt and io-mapping.txt in Documentation/
>    was confusing and/or bothersome to some people, so rename
>    IO-mapping.txt to bus-virt-phys-mapping.txt.  Also update
>    Documentation/00-INDEX for both of these files.
[...]

Thanks Randy, for making this change. However, there are 13 other pairs of
files that have a similar name conflict (all in the netfilter area). And it
seems to me that these files cannot simply be renamed, because these files
are also part of libc, or perhaps some other public library. Damn. Too late
to complain now.

The files I'm talking about are:
net/ipv4/netfilter/ipt_ECN.c            net/ipv4/netfilter/ipt_ecn.c
net/netfilter/xt_tcpmss.c               net/netfilter/xt_TCPMSS.c
net/netfilter/xt_DSCP.c                 net/netfilter/xt_dscp.c
net/netfilter/xt_rateest.c              net/netfilter/xt_RATEEST.c
net/netfilter/xt_HL.c                   net/netfilter/xt_hl.c
include/linux/netfilter_ipv6/ip6t_hl.h  include/linux/netfilter_ipv6/ip6t_HL.h
include/linux/netfilter/xt_tcpmss.h     include/linux/netfilter/xt_TCPMSS.h
include/linux/netfilter/xt_rateest.h    include/linux/netfilter/xt_RATEEST.h
include/linux/netfilter/xt_MARK.h       include/linux/netfilter/xt_mark.h
include/linux/netfilter/xt_CONNMARK.h   include/linux/netfilter/xt_connmark.h
include/linux/netfilter/xt_DSCP.h       include/linux/netfilter/xt_dscp.h
include/linux/netfilter_ipv4/ipt_ECN.h  include/linux/netfilter_ipv4/ipt_ecn.h
include/linux/netfilter_ipv4/ipt_ttl.h  include/linux/netfilter_ipv4/ipt_TTL.h

What this means is that you cannot do a git-clone of the kernel tree on a Mac
(which has case insensitive filesystem). It's not a huge deal, but to me it
seemed like an unnecessary limitation. (That was when I thought it was just
io-mapping.txt)

	Kees

