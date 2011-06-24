Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab1FXA7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:59:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43047 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab1FXA7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:59:12 -0400
Date: Fri, 24 Jun 2011 02:59:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stefan Assmann <sassmann@kpanic.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, rick@vanrein.org, rdunlap@xenotime.net
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-ID: <20110624005907.GP3263@one.firstfloor.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110623133950.GB28333@srcf.ucam.org> <4E0348E0.7050808@kpanic.de> <20110623141222.GA30003@srcf.ucam.org> <4E035DD1.1030603@kpanic.de> <4E036A2D.1060402@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E036A2D.1060402@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 09:30:37AM -0700, H. Peter Anvin wrote:
> On 06/23/2011 08:37 AM, Stefan Assmann wrote:
> > 
> > According to Rick's reply in this thread a damaged row in a DIMM can
> > easily cause a few thousand entries in the e820 table because it doesn't
> > handle patterns. So the question I'm asking is, is it acceptable to
> > have an e820 table with thousands maybe ten-thousands of entries?
> > I really have no idea of the implications, maybe somebody else can
> > comment on that.
> > 
> 
> Given that that is what actually ends up happening in the kernel at some
> point anyway, 

hwpoison can poison most pages without any lists.  Read Stefan's original patch.

The only thing that needs list really is conflict handling with
early allocations.

-Andi
