Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab2JZOGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:06:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:9215 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933095Ab2JZOGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:06:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="scan'208";a="240559301"
Date: Fri, 26 Oct 2012 22:06:07 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] kfifo: round up the fifo size power of 2
Message-ID: <20121026140607.GB1324@yliu-dev.sh.intel.com>
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1351243827.8719.5.camel@wall-e>
 <20121026123321.GG2778@yliu-dev.sh.intel.com>
 <1351258786.10060.5.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351258786.10060.5.camel@wall-e>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 03:39:46PM +0200, Stefani Seibold wrote:
> Am Freitag, den 26.10.2012, 20:33 +0800 schrieb Yuanhan Liu:
> > On Fri, Oct 26, 2012 at 11:30:27AM +0200, Stefani Seibold wrote:
> > > Am Freitag, den 26.10.2012, 15:56 +0800 schrieb Yuanhan Liu:
> > > > Say, if we want to allocate a filo with size of 6 bytes, it would be safer
> > > > to allocate 8 bytes instead of 4 bytes.
> > > > ----
> > > > I know it works with rounddown_pow_of_two as well, since size is maintained
> > > > in the kfifo internal part. But, I'm quite curious why Stefani chose
> > > > rounddown_pow_of_two. To reduce memory?
> > > > 
> > > 
> > > Yes, exactly, if a user do the wrong thing, than the user will get also
> > > a wrong result, and did not waste memory.
> > 
> > But, isn't it better to 'correct' it? ;-)
> 
> Both is wrong. This depends on the view. For me it is better to get less
> and don't wast space. For example: requesting 1025 will yield in your
> case to a fifo which 2048 elements, which requires double of the memory
> as expected.
> 
> > 
> > > 
> > > But anyway, if the majority like this patch it is okay for me.
> > 
> > Sorry, do you mean you are OK with this patch?
> > 
> 
> I depends not on me, ask for a democratic decisions.

Since you are the original athour, your comments matter :D

Thanks,
Yuanhan Liu

