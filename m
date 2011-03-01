Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab1CAI3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:29:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59379 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab1CAI3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:29:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oihSyUQOrijoNA3C047QYXM5nIlNB8prSIEFTYPXu/AF//Z8sDln78O/Uom5WjwSj5
         0e5zdeHVrdaf0Yxaz6caLFDRK3rpnlXvQLg7vpSeB1PuY8eI7N/C5aBACFcG2tgE5Vw2
         kMCyAOoykVBfSg+t2e56nQG/Bzjg6Wop8JRUw=
Date: Tue, 1 Mar 2011 09:29:15 +0100
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: questions about init_memory_mapping_high()
Message-ID: <20110301082915.GC26074@htj.dyndns.org>
References: <20110223171945.GI26065@htj.dyndns.org>
 <4D6BE614.3010007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6BE614.3010007@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

(sorry about the earlier empty reply, fat finger on my phone)

On Mon, Feb 28, 2011 at 10:14:44AM -0800, H. Peter Anvin wrote:
> > 1. The only rationale given in the commit description is that a
> >    RED-PEN is killed, which was the following.
> > 
> > 	/*
> > 	 * RED-PEN putting page tables only on node 0 could
> > 	 * cause a hotspot and fill up ZONE_DMA. The page tables
> > 	 * need roughly 0.5KB per GB.
> > 	 */
> > 
> >    This already wasn't true with top-down memblock allocation.
> > 
> >    The 0.5KB per GiB comment is for 32bit w/ 3 level mapping.  On
> >    64bit, it's ~4KiB per GiB when using 2MiB mappings and, well, very
> >    small per GiB if 1GiB mapping is used.  Even with 2MiB mapping,
> >    1TiB mapping would only be 4MiB.  Under ZONE_DMA, this could be
> >    problematic but with top-down this can't be a problem in any
> >    realistic way in foreseeable future.
> > 
> 
> It's true on 64 bits too when PAE is not available (e.g. with Xen.)

Hmm... I don't follow.  Can you elaborate?  If PAE is not available
for whatever reason, the physical memory is limited to 4GiB but I
don't follow what that has to do with the above.

Thanks.

-- 
tejun
