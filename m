Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3ACBgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 20:36:18 -0500
Received: from mail.us.es ([193.147.175.20]:44083 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab3ACBgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 20:36:12 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus3 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.6/16310. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-99.2/7.5):. 
 Processed in 10.751856 secs); 03 Jan 2013 01:36:10 -0000
X-Envelope-From: pneira@us.es
Date: Thu, 3 Jan 2013 02:35:59 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 2 (netfilter)
Message-ID: <20130103013559.GA2323@1984>
References: <20130102151216.b81cd4d4bf54fc8d1f5d9b27@canb.auug.org.au>
 <50E47EEF.8090005@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E47EEF.8090005@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 02, 2013 at 10:39:43AM -0800, Randy Dunlap wrote:
> On 01/01/13 20:12, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20121224:
> > 
> 
> when NF_CONNTRACK is not enabled (build was on i386):
> 
>   CC [M]  net/netfilter/xt_CT.o
> In file included from net/netfilter/xt_CT.c:16:0:
> include/net/netfilter/nf_conntrack.h:77:22: error: field 'ct_general' has incomplete type
> include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
> include/net/netfilter/nf_conntrack.h:157:30: error: 'const struct sk_buff' has no member named 'nfct'
> include/net/netfilter/nf_conntrack.h: In function 'nf_ct_put':
> include/net/netfilter/nf_conntrack.h:164:2: error: implicit declaration of function 'nf_conntrack_put' [-Werror=implicit-function-declaration]
> net/netfilter/xt_CT.c: In function 'xt_ct_target_v0':
> net/netfilter/xt_CT.c:30:9: error: 'struct sk_buff' has no member named 'nfct'
> net/netfilter/xt_CT.c:34:5: error: 'struct sk_buff' has no member named 'nfct'
> net/netfilter/xt_CT.c: In function 'xt_ct_target_v1':
> net/netfilter/xt_CT.c:47:9: error: 'struct sk_buff' has no member named 'nfct'
> net/netfilter/xt_CT.c:51:5: error: 'struct sk_buff' has no member named 'nfct'
> net/netfilter/xt_CT.c: In function 'xt_ct_tg_check_v0':
> net/netfilter/xt_CT.c:155:15: error: 'struct net' has no member named 'ct'
> net/netfilter/xt_CT.c: In function 'xt_ct_tg_check_v1':
> net/netfilter/xt_CT.c:299:15: error: 'struct net' has no member named 'ct'
> net/netfilter/xt_CT.c: In function 'notrack_tg':
> net/netfilter/xt_CT.c:392:9: error: 'struct sk_buff' has no member named 'nfct'
> net/netfilter/xt_CT.c:395:5: error: 'struct sk_buff' has no member named 'nfct'
> net/netfilter/xt_CT.c:397:2: error: implicit declaration of function 'nf_conntrack_get' [-Werror=implicit-function-declaration]
> net/netfilter/xt_CT.c:397:22: error: 'struct sk_buff' has no member named 'nfct'
> cc1: some warnings being treated as errors
> make[3]: *** [net/netfilter/xt_CT.o] Error 1

Sorry, I cannot reproduce the selection that your config file
contains:

CONFIG_NF_CONNTRACK=n
NETFILTER_XT_TARGET_CT=m

after make oldconfig is run. NETFILTER_XT_TARGET_CT already depends on
NF_CONNTRACK in our Kconfig, so I don't see what can be bad yet.
