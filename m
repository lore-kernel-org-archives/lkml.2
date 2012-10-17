Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2JQHb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:31:26 -0400
Received: from mail.unix-scripts.info ([46.21.114.223]:46263 "EHLO
	mail.unix-scripts.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab2JQHbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:31:25 -0400
Date: Wed, 17 Oct 2012 09:31:21 +0200
From: Laurent CARON <lcaron@unix-scripts.info>
To: Dan Williams <djbw@fb.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Subject: Re: Strange crash on Dell R720xd
Message-ID: <20121017092903.ahgeefai@trusted.unix-scripts.info>
Mail-Followup-To: Dan Williams <djbw@fb.com>,
	Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
References: <20121015213522.kaiyahro@trusted.unix-scripts.info>
 <20121016090353.GB7428@liondog.tnic>
 <20121016112301.lavahnga@trusted.unix-scripts.info>
 <20121016124825.GA8509@x1.osrc.amd.com>
 <20121016145039.eizeigon@trusted.unix-scripts.info>
 <CAA9_cmf9XsQ7YPLfsvvjPjLxQGVde1yHqTanOjJxdjPcLRUK8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmf9XsQ7YPLfsvvjPjLxQGVde1yHqTanOjJxdjPcLRUK8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 10:58:49AM -0700, Dan Williams wrote:
> I think this may be a bug in __raid_run_ops that is only possible when
> raid offload and CONFIG_MULTICORE_RAID456 are enabled.  I'm thinking
> the descriptor is completed and recycled to another requester in the
> space between these two events:
> 
>                 ops_run_compute();
> 
>                 /* terminate the chain if reconstruct is not set to be run */
>                 if (tx && !test_bit(STRIPE_OP_RECONSTRUCT, &ops_request))
>                         async_tx_ack(tx);
> 
> ...don't use the experimental CONFIG_MULTICORE_RAID456 even if you
> leave IOAT DMA disabled.  A rework of the raid operation dma chaining
> is in progress, but may not be ready for a while.

Hi,

I usually don't use CONFIG_MULTICORE_RAID456 as it proved to be sluggish
and/or unstable in my experience, so I should be pretty safe letting I/O
AT DMA disabled for now on those bosex.

Thanks

