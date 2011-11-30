Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab1K3N3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:29:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:47574 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581Ab1K3N3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:29:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,596,1315206000"; 
   d="scan'208";a="80637996"
Date: Wed, 30 Nov 2011 21:29:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Ankit Jain <radical@gmail.com>, Rik van Riel <riel@redhat.com>,
        Nikanth Karthikesan <knikanth@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/8] readahead: make default readahead size a kernel
 parameter
Message-ID: <20111130132928.GA31589@localhost>
References: <20111121091819.394895091@intel.com>
 <20111121093846.251104145@intel.com>
 <20111121100137.GC5084@infradead.org>
 <20111121113540.GB8895@localhost>
 <20111124222822.GG29519@quack.suse.cz>
 <20111125003633.GP2386@dastard>
 <20111128023922.GA2141@localhost>
 <4ED629CB.401@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ED629CB.401@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 09:04:11PM +0800, Christian Ehrhardt wrote:
> 
> 
> On 11/28/2011 03:39 AM, Wu Fengguang wrote:
> > On Fri, Nov 25, 2011 at 08:36:33AM +0800, Dave Chinner wrote:
> >> On Thu, Nov 24, 2011 at 11:28:22PM +0100, Jan Kara wrote:
> >>> On Mon 21-11-11 19:35:40, Wu Fengguang wrote:
> >>>> On Mon, Nov 21, 2011 at 06:01:37PM +0800, Christoph Hellwig wrote:
> >>>>> On Mon, Nov 21, 2011 at 05:18:21PM +0800, Wu Fengguang wrote:
> >>>>>> From: Nikanth Karthikesan<knikanth@suse.de>
> >>>>>>
> [...]
> 
> >>
> >> And one that has already been in use for exactly this purpose for
> >> years. Indeed, it's far more flexible because you can give different
> >> types of devices different default readahead settings quite easily,
> >> and it you can set different defaults for just about any tunable
> >> parameter (e.g. readahead, ctq depth, max IO sizes, etc) in the same
> >> way.
> >
> > I'm interested in this usage, too. Would you share some of your rules?
> >
> 
> FYI - This is an example of a rules Suse delivers in SLES @ s390 for a 
> while now. With little modifications it could be used for all Dave 
> mentioned above.

It's a really good example, thank you!

> cat /etc/udev/rules.d/60-readahead.rules
> # 
>  
>  
> 
> # Rules to set an increased default max readahead size for s390 disk 
> devices 
>  
> 
> # This file should be installed in /etc/udev/rules.d 
>  
>  
> 
> # 
>  
> SUBSYSTEM!="block", GOTO="ra_end" 
> 
> ACTION!="add", GOTO="ra_end" 
> 
> # on device add set initial readahead to 512 (instead of in kernel 128) 
> 
> KERNEL=="sd*[!0-9]", ATTR{queue/read_ahead_kb}="512" 
> 
> KERNEL=="dasd*[!0-9]", ATTR{queue/read_ahead_kb}="512" 

So SLES (@s390 and maybe more) is already shipping with 512kb
readahead size? Good to know this!

Thanks,
Fengguang

>  
> 
> 
> LABEL="ra_end"
> 
> -- 
> 
> Grüsse / regards, Christian Ehrhardt
> IBM Linux Technology Center, System z Linux Performance
