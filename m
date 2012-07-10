Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab2GJOUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:20:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab2GJOUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:20:11 -0400
Date: Tue, 10 Jul 2012 10:20:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        kzak@redhat.com, maxim.patlasov@gmail.com
Subject: Re: [patch 0/2] [V4] block: Support online resize of disk partitions
Message-ID: <20120710142001.GF14884@redhat.com>
References: <20120709213418.799759100@redhat.com>
 <4FFB5DC3.30803@ubuntu.com>
 <20120710135759.GE14884@redhat.com>
 <4FFC387F.3070308@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFC387F.3070308@ubuntu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 10:13:19AM -0400, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 7/10/2012 9:57 AM, Vivek Goyal wrote:
> > +static inline sector_t part_nr_sects_read(struct hd_struct *part) 
> > +{ +#if BITS_PER_LONG==32 && defined(CONFIG_LBDAF) &&
> > defined(CONFIG_SMP) +	sector_t nr_sects; +	unsigned seq; +	do { +
> > seq = read_seqcount_begin(&part->nr_sects_seq); +		nr_sects =
> > part->nr_sects; +	} while (read_seqcount_retry(&part->nr_sects_seq,
> > seq)); +	return nr_sects; +#elif BITS_PER_LONG==32 &&
> > defined(CONFIG_PREEMPT)
> 
> Shouldn't this be BITS_PER_LONG==32 && defined(CONFIG_LBDAF) &&
> defined(CONFIG_PREEMPT)?  No sense disabling preemption when the
> sector size is also 32 bits.

Yes. Good catch. We don't want to disable/enable preemption for 32bit UP 
kernels with sector size 32bit. I will modify the patch and repost soon.

BTW, what happened to all the new lines in the code above. Looks like you
mailer chewed these up.

Thanks
Vivek
