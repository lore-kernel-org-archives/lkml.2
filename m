Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab2JBSKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:10:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab2JBSK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:10:28 -0400
Date: Tue, 2 Oct 2012 14:10:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, linux-s390@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>, Jiri Kosina <jkosina@suse.cz>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Alasdair Kergon <agk@redhat.com>, tj@kernel.org,
        Steven Whitehouse <swhiteho@redhat.com>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>
Subject: Re: [dm-devel] [PATCH v3 06/26] block: Add bio_end_sector()
Message-ID: <20121002181001.GB3283@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-7-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348526106-17074-7-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 03:34:46PM -0700, Kent Overstreet wrote:

[..]
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 4e32be1..d985e90 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -67,6 +67,7 @@
>  #define bio_offset(bio)		bio_iovec((bio))->bv_offset
>  #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
>  #define bio_sectors(bio)	((bio)->bi_size >> 9)
> +#define bio_end_sector(bio)	((bio)->bi_sector + bio_sectors(bio))

May be it is just me. But bio_end_sector() kind of sounds that it will
calculate to the last sector of bio. So I thought of it more as
bio_last_sector() and not the sector which is next to the last sector.

Will it make sense to introduce bio_last_sector() and use +1 everywhere.
Or may be we need a better name. Can't think of one though.

Thanks
Vivek
