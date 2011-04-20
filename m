Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab1DTBXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 21:23:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37258 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab1DTBXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:23:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
Cc: kosaki.motohiro@jp.fujitsu.com,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>
In-Reply-To: <alpine.DEB.2.00.1104191657030.26867@router.home>
References: <1303249716.11237.26.camel@mulgrave.site> <alpine.DEB.2.00.1104191657030.26867@router.home>
Message-Id: <20110420102314.4604.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 20 Apr 2011 10:23:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 19 Apr 2011, James Bottomley wrote:
> 
> > > Which part of me telling you that you will break lots of other things in
> > > the core kernel dont you get?
> >
> > I get that you tell me this ... however, the systems that, according to
> > you, should be failing to get to boot prompt do, in fact, manage it.
> 
> If you dont use certain subsystems then it may work. Also do you run with
> debuggin on.
> 
> The following patch is I think what would be needed to fix it.

I'm worry about this patch. A lot of mm code assume !NUMA systems 
only have node 0. Not only SLUB.

I'm not sure why this unfortunate mismatch occur. but I think DISCONTIG
hacks makes less sense. Can we consider parisc turn NUMA on instead?



