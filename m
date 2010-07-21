Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0GUNlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:41:10 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:37991 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab0GUNlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:41:07 -0400
Date: Wed, 21 Jul 2010 22:41:03 +0900
From: Simon Horman <horms@verge.net.au>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Malcolm Turnbull <malcolm@loadbalancer.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Julius Volz <julius.volz@gmail.com>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hannes Eder <heder@google.com>
Subject: Re: [patch v2.6 4/4] libxt_ipvs: user-space lib for netfilter
 matcher xt_ipvs
Message-ID: <20100721134102.GA21188@verge.net.au>
References: <20100711090342.035149543@vergenet.net>
 <20100711090500.421568837@vergenet.net>
 <20100721012146.GC22966@verge.net.au>
 <alpine.LSU.2.01.1007210834570.10568@obet.zrqbmnf.qr>
 <20100721132159.GN6418@verge.net.au>
 <alpine.LSU.2.01.1007211526490.25445@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1007211526490.25445@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 03:28:16PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2010-07-21 15:21, Simon Horman wrote:
> >> On Wednesday 2010-07-21 03:21, Simon Horman wrote:
> >> >> +
> >> >> +#define XT_IPVS_IPVS_PROPERTY	(1 << 0) /* all other options imply this one */
> >> >> +#define XT_IPVS_PROTO		(1 << 1)
> >> >> +#define XT_IPVS_VADDR		(1 << 2)
> >> >> +#define XT_IPVS_VPORT		(1 << 3)
> >> >> +#define XT_IPVS_DIR		(1 << 4)
> >> >> +#define XT_IPVS_METHOD		(1 << 5)
> >> >> +#define XT_IPVS_VPORTCTL	(1 << 6)
> >> >> +#define XT_IPVS_MASK		((1 << 7) - 1)
> >> >> +#define XT_IPVS_ONCE_MASK	(XT_IPVS_MASK & ~XT_IPVS_IPVS_PROPERTY)
> >> 
> >> Can't these just be an enum?
> >
> >More than one option can be used at once - they form a mini bitmap -
> >so no, I don't think we can use an enum.
> 
> An enum does not dictate that you cannot combine values of it with itself.
> 
> 	enum { A = 1 << 0, B = 1 << 0, };
> 	unsigned int flags = A | B;
> 
> is perfectly fine, which is what other modules do.

Understood. I'll make it so.

