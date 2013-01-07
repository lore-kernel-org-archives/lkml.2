Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3AGIrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 03:47:04 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:43682 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3AGIrD convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 7 Jan 2013 03:47:03 -0500
Message-Id: <50EA8B810200007800092668@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 07 Jan 2013 08:46:57 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <dongxiao.xu@intel.com>
Cc: <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [Xen-devel] [PATCH] xen/swiotlb: Exchange to contiguous
 memory for map_sg hook
References: <1354799322-6000-1-git-send-email-dongxiao.xu@intel.com>
 <20121207140852.GC3140@phenom.dumpdata.com>
 <40776A41FC278F40B59438AD47D147A90FEBE741@SHSMSX102.ccr.corp.intel.com>
 <20121211170653.GG9347@localhost.localdomain>
 <40776A41FC278F40B59438AD47D147A90FEBFB64@SHSMSX102.ccr.corp.intel.com>
 <50C85E9F02000078000AFD65@nat28.tlf.novell.com>
 <20121219200904.GG15037@phenom.dumpdata.com>
 <40776A41FC278F40B59438AD47D147A90FECC3EC@SHSMSX102.ccr.corp.intel.com>
 <50D2E0C102000078000B1B1C@nat28.tlf.novell.com>
 <40776A41FC278F40B59438AD47D147A90FED9A52@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <40776A41FC278F40B59438AD47D147A90FED9A52@SHSMSX102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Xu, Dongxiao" <dongxiao.xu@intel.com> 01/07/13 8:17 AM >>>
> From: Jan Beulich [mailto:JBeulich@suse.com]
> >>> On 20.12.12 at 02:23, "Xu, Dongxiao" <dongxiao.xu@intel.com> wrote:
>> > Take the libata case as an example, the static DMA buffer locates
>> > (dev->link->ap->sector_buf , here we use Data Structure B in the graph) in
>> > the following structure:
>> >
>> > -------------------------------------Page boundary
>> > <Data Structure A>
>> > <Data Structure B>
>> > -------------------------------------Page boundary
>> > <Data Structure B (cross page)>
>> > <Data Structure C>
>> > -------------------------------------Page boundary
>> >
>> > Where Structure B is our DMA target.
>> >
>> > For Data Structure B, we didn't care about the simultaneous access, either
>> > lock or sync function will take care of it.
>> > What we are not sure is "read/write of A and C from other processor". As we
>> > will have memory copy for the pages, and at the same time, other CPU may
>> > access A/C.
>> 
>> The question is whether what libata does here is valid in the first
>> place - fill an SG list entry with something that crosses a page
>> boundary and is not a compound page.
>
>To make sure I understand you correctly, so do you mean the correct fix should be
> applied to libata driver, and make sure it DMA from/to correct place (for example,
> some memory allocated by DMA API), but not such certain field in a static structure?

Yes.

Jan

