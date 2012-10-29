Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460Ab2J2KNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:13:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36169 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab2J2KN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:13:29 -0400
Date: Mon, 29 Oct 2012 11:13:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/33] perf, x86: Add PEBSv2 record support
Message-ID: <20121029101323.GR16230@one.firstfloor.org>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org> <1351283415-13170-2-git-send-email-andi@firstfloor.org> <874nld8ubf.fsf@sejong.aot.lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nld8ubf.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 07:08:04PM +0900, Namhyung Kim wrote:
> Hi Andi,
> 
> On Fri, 26 Oct 2012 13:29:43 -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > Add support for the v2 PEBS format. It has a superset of the v1 PEBS
> > fields, but has a longer record so we need to adjust the code paths.
> >
> > The main advantage is the new "EventingRip" support which directly
> > gives the instruction, not off-by-one instruction. So with precise == 2
> > we use that directly and don't try to use LBRs and walking basic blocks.
> > This lowers the overhead significantly.
> 
> That means it can support precise == 3?

No. It's still 2

I tried to introduced precise == 3 some time ago for PDIR, but it was
rejected. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
