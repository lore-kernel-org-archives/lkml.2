Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab0GFSvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 14:51:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25849 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab0GFSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 14:51:33 -0400
Date: Tue, 6 Jul 2010 11:48:16 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 1/2] ocfs2: Zero the tail cluster when extending past
 i_size v2
Message-ID: <20100706184816.GC17961@mail.oracle.com>
Mail-Followup-To: Tao Ma <tao.ma@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
References: <20100628173529.GA10573@mail.oracle.com>
 <20100629002421.GY6590@dastard>
 <20100629005403.GC24343@mail.oracle.com>
 <20100629015615.GZ6590@dastard>
 <20100629020420.GE24343@mail.oracle.com>
 <20100629022757.GA6590@dastard>
 <20100629071817.GA4150@mail.oracle.com>
 <20100702224912.GC5800@mail.oracle.com>
 <20100703213219.GB21262@mail.oracle.com>
 <4C3156D0.5090001@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3156D0.5090001@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C337AE6.0139:SCFMA4539814,ss=1,pt=DBB_65835,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 11:51:44AM +0800, Tao Ma wrote:
> On 07/04/2010 05:32 AM, Joel Becker wrote:
> >+	/*
> >+	 * If tail_blkno is in the cluster past i_size, we don't need
> >+	 * to touch the cluster containing i_size at all.
> >+	 */
> >+	tail_cpos = i_size_read(inode)>>  osb->s_clustersize_bits;
> >+	if (ocfs2_blocks_to_clusters(inode->i_sb, tail_blkno)>  tail_cpos)
> >+		tail_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
> >+						     tail_blkno);
> Can we always set tail_cpos in one line?
> 	tail_cpos = ocfs2_blocks_to_clusters(inode->i_sb, tail_blkno)?
> tail_cpos is either the same cluster as i_size or the next cluster
> and both works for tail_blkno I guess?

	I'm taking this as well.

Joel


-- 

"Here's something to think about:  How come you never see a headline
 like ``Psychic Wins Lottery''?"
	- Jay Leno

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
