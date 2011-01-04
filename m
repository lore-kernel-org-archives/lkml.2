Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1ADRVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:21:24 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:29502 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1ADRVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:21:22 -0500
X-IronPort-AV: E=Sophos;i="4.60,273,1291611600"; 
   d="scan'208";a="129534606"
Subject: Re: [Xen-devel] Re: [PATCH 2/8] xen/mmu: Add the notion of
 identity (1-1) mapping.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jn Beulich <JBeulich@novell.com>,
        "Konrad Rzeszutek Wilk" <konrad@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <1294160359.3831.579.camel@zakaz.uk.xensource.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
	 <1293738517-7287-3-git-send-email-konrad.wilk@oracle.com>
	 <1294160028.3831.563.camel@zakaz.uk.xensource.com>
	 <1294160359.3831.579.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 4 Jan 2011 17:20:23 +0000
Message-ID: <1294161623.3831.643.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 16:59 +0000, Ian Campbell wrote:
> On Tue, 2011-01-04 at 16:53 +0000, Ian Campbell wrote:
> > 
> > If I do "__set_phys_to_machine(X, X)" where X happens to currently
> > correspond to p2m_mid_missing won't that cause all pfn entries in the
> > range covered by p2m_top[topidx] (i.e. quite a few, like 512^2 pages
> > or
> > something) to switch from missing to identity? Similarly for
> > p2m_top[topidx][mididx]?
> > 
> > Perhaps ranges of identity bits are often well aligned with the
> > boundaries in the p2m 3-level tree but wouldn't that just be
> > coincidence? 
> 
> I wonder if it would make sense to have a debugfs file which exports the
> p2m, for the purposes of eye-balling it for this sort of issue?
> comparing to the e820 etc...
> 
> Maybe the whole thing in raw form would be overkill but spitting out a
> list of ranges of identity, invalid, normal pages, plus annotation
> regarding whether those come from a p2m_mid_identity style page or a
> leaf node, might be occasionally useful.

I should have read patch 5/8 first...

