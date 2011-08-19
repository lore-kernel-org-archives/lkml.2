Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1HSNqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:46:33 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:36910 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab1HSNq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:46:29 -0400
X-IronPort-AV: E=Sophos;i="4.68,251,1312156800"; 
   d="scan'208";a="7359899"
Subject: Re: [PATCH 68/75] hv: netvsc: convert to SKB paged frag API.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Dan Carpenter <error27@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110819133739.GA3715@shale.localdomain>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
	 <1313760467-8598-68-git-send-email-ian.campbell@citrix.com>
	 <20110819133739.GA3715@shale.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 19 Aug 2011 14:46:27 +0100
Message-ID: <1313761587.5010.365.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 14:37 +0100, Dan Carpenter wrote:
> On Fri, Aug 19, 2011 at 02:27:40PM +0100, Ian Campbell wrote:
> >  	/* usually there's just one frag */
> > -	skb_frag_set_page(skb, 0, gl->frags[0].page);
> > +	skb_frag_set_page(skb, 0, gl->frags[0].page.p);	/* XXX */
> 
> There are bunch of new /* XXX */ comments.  What are they for?

They are a reminder referring to the dilemma I mentioned in the intro
mail. Basically that ".p" is ugly because gl->frags[0].page isn't
actually a paged fragment, it's just that this driver uses skb_frag_t in
its internal datastructures.

Ian.

