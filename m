Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1HQMfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 08:35:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:29116 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab1HQMfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 08:35:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,239,1312182000"; 
   d="scan'208";a="39394017"
Date: Wed, 17 Aug 2011 20:35:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: David Horner <ds2horner@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110817123506.GA15403@localhost>
References: <CAFdhcLRKvfqBnXCXLwq-Qe1eNAGC-8XJ3BtHpQKzaa3RhHyp6A@mail.gmail.com>
 <CAFdhcLTFv4Wk0kBb2NSL7oh+78BJ=6qPT4XfcOssOkwEERyj=w@mail.gmail.com>
 <20110817120356.GG9959@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110817120356.GG9959@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 08:03:56PM +0800, Jan Kara wrote:
> On Wed 17-08-11 02:40:19, David Horner wrote:
> >  I noticed a significant typo below (another of those thousand eyes,
> > thanks to Jan Kara's post that started ne looking) :
> > 
> >  > +static unsigned long bdi_position_ratio(struct backing_dev_info *bdi,
> >  > + unsigned long thresh,
> > ...
> >  > + * For JBOD case, bdi_thresh (not bdi_dirty!) could fluctuate up to its
> >  > + * own size, so move the slope over accordingly.
> >  > + */
> >  > + if (unlikely(bdi_thresh > thresh))
> >  > + bdi_thresh = thresh;
> >  > + /*
> >  > + * scale global setpoint to bdi's:  setpoint *= bdi_thresh / thresh
> >  > + */
> >  > + x = div_u64((u64)bdi_thresh << 16, thresh | 1);
> > 
> >                   ^
> >  I believe should be
> > 
> >     x = div_u64((u64)bdi_thresh << 16, thresh + 1);
>   I've noticed this as well but it's mostly a consistency issue. 'thresh'
> is going to be large in practice so there's not much difference between
> thresh + 1 and thresh | 1.

Right :) Anyway I'll change it to thresh + 1.

Thanks,
Fengguang
