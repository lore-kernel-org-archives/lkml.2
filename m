Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1BAAv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:51:59 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:40411 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab1BAAv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:51:58 -0500
Date: Mon, 31 Jan 2011 16:50:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Simon Horman <horms@verge.net.au>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Hans Schillstrom <hans@schillstrom.com>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [GIT PULL nf-next-2.6] IPVS build fixes and clean-ups
Message-Id: <20110131165009.66999952.randy.dunlap@oracle.com>
In-Reply-To: <1296519255-10602-1-git-send-email-horms@verge.net.au>
References: <1296519255-10602-1-git-send-email-horms@verge.net.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Feb 2011 11:14:11 +1100 Simon Horman wrote:

> Hi,
> 
> This short patch series addresses two linux-next build problems
> raised by Randy Dunlap:
> 
> * net/netfilter/ipvs/ip_vs_core.c:1891: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'
> * ERROR: "unregister_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko]
>   ERROR: "register_net_sysctl_table" [net/netfilter/ipvs/ip_vs.ko] undefined!
> 
> The remainder of the changset is cleanups that I noticed along the way.

These 4 patches build successfully for me.
However, I do see these warnings (sorry I missed them earlier):

WARNING: net/netfilter/ipvs/ip_vs.o(.init.text+0x161): Section mismatch in reference from the function init_module() to the function .exit.text:ip_vs_sync_cleanup()
WARNING: net/netfilter/ipvs/ip_vs.o(.init.text+0x161): Section mismatch in reference from the function init_module() to the function .exit.text:ip_vs_sync_cleanup()


Thanks for the patch series.

> The changes are available at
> git://git.kernel.org/pub/scm/linux/kernel/git/horms/lvs-test-2.6.git master
> 
> They are currently compile-tested only.
> 
>  include/net/ip_vs.h              |    2 --
>  net/netfilter/ipvs/ip_vs_core.c  |    2 +-
>  net/netfilter/ipvs/ip_vs_ctl.c   |   17 +++++++++--------
>  net/netfilter/ipvs/ip_vs_lblc.c  |   20 ++++++++++----------
>  net/netfilter/ipvs/ip_vs_lblcr.c |   20 ++++++++++----------
>  5 files changed, 30 insertions(+), 31 deletions(-)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
