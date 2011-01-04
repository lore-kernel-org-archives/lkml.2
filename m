Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1ADQ7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:59:43 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:21274 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520Ab1ADQ7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:59:41 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Jan Beulich <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <1294160028.3831.563.camel@zakaz.uk.xensource.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
	 <1293738517-7287-3-git-send-email-konrad.wilk@oracle.com>
	 <1294160028.3831.563.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 16:59:19 +0000
Message-ID: <1294160359.3831.579.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 2/8] xen/mmu: Add the notion of identity (1-1) mapping.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=ElWBgQNHElIA:10 a=IkcTkHD0fZMA:10 a=9LK883MKfsj71dkQuIQA:9 a=CaDgvDK8YC45D16O3xoA:7 a=RhISWYyJmt0_V-3-_z7vjSDvwRYA:4 a=QEXdDO2ut3YA:10 a=19jjMibb8a9Jz_zD:21 a=L1hc0XvolwldEPdj:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 16:53 +0000, Ian Campbell wrote:
> 
> If I do "__set_phys_to_machine(X, X)" where X happens to currently
> correspond to p2m_mid_missing won't that cause all pfn entries in the
> range covered by p2m_top[topidx] (i.e. quite a few, like 512^2 pages
> or
> something) to switch from missing to identity? Similarly for
> p2m_top[topidx][mididx]?
> 
> Perhaps ranges of identity bits are often well aligned with the
> boundaries in the p2m 3-level tree but wouldn't that just be
> coincidence? 

I wonder if it would make sense to have a debugfs file which exports the
p2m, for the purposes of eye-balling it for this sort of issue?
comparing to the e820 etc...

Maybe the whole thing in raw form would be overkill but spitting out a
list of ranges of identity, invalid, normal pages, plus annotation
regarding whether those come from a p2m_mid_identity style page or a
leaf node, might be occasionally useful.

Ian.
-- 
Ian Campbell
Current Noise: Place of Skulls - The Watchers

Call toll free number before digging.

