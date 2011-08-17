Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab1HQMEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 08:04:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1HQMD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 08:03:57 -0400
Date: Wed, 17 Aug 2011 14:03:56 +0200
From: Jan Kara <jack@suse.cz>
To: David Horner <ds2horner@gmail.com>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, jack@suse.cz
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110817120356.GG9959@quack.suse.cz>
References: <CAFdhcLRKvfqBnXCXLwq-Qe1eNAGC-8XJ3BtHpQKzaa3RhHyp6A@mail.gmail.com>
 <CAFdhcLTFv4Wk0kBb2NSL7oh+78BJ=6qPT4XfcOssOkwEERyj=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFdhcLTFv4Wk0kBb2NSL7oh+78BJ=6qPT4XfcOssOkwEERyj=w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 17-08-11 02:40:19, David Horner wrote:
>  I noticed a significant typo below (another of those thousand eyes,
> thanks to Jan Kara's post that started ne looking) :
> 
>  > +static unsigned long bdi_position_ratio(struct backing_dev_info *bdi,
>  > + unsigned long thresh,
> ...
>  > + * For JBOD case, bdi_thresh (not bdi_dirty!) could fluctuate up to its
>  > + * own size, so move the slope over accordingly.
>  > + */
>  > + if (unlikely(bdi_thresh > thresh))
>  > + bdi_thresh = thresh;
>  > + /*
>  > + * scale global setpoint to bdi's:  setpoint *= bdi_thresh / thresh
>  > + */
>  > + x = div_u64((u64)bdi_thresh << 16, thresh | 1);
> 
>                   ^
>  I believe should be
> 
>     x = div_u64((u64)bdi_thresh << 16, thresh + 1);
  I've noticed this as well but it's mostly a consistency issue. 'thresh'
is going to be large in practice so there's not much difference between
thresh + 1 and thresh | 1.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
