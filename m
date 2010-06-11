Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab0FKHve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:51:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35004 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab0FKHvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:51:32 -0400
Date: Fri, 11 Jun 2010 00:50:20 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Tao Ma <tao.ma@oracle.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH v4] ocfs2: Let ocfs2_setattr use new truncate sequence.
Message-ID: <20100611075020.GC23946@mail.oracle.com>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
	Tao Ma <tao.ma@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
References: <1276226869-11123-1-git-send-email-tao.ma@oracle.com>
 <20100611065635.GA19692@lst.de>
 <4C11E2BD.2020207@oracle.com>
 <20100611071945.GA20496@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100611071945.GA20496@lst.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090202.4C11EAF9.0196:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 09:19:45AM +0200, Christoph Hellwig wrote:
> On Fri, Jun 11, 2010 at 03:16:13PM +0800, Tao Ma wrote:
> > oh, that would be much work for ocfs2 to do from my perspective. So I 
> > would really want to leave it as-is and I have add it to my to-do list.
> 
> Oh right, you start a new transaction there.  Sorry, ignore my request
> and keep it as it is for now.  I don't think doing truncatate in separate
> transactions actually is correct, though but that's no change with this
> patch.

Christoph,
	You're missing the part where actual truncate (reduce i_size)
sets i_size in ocfs2_truncate_file().  So this later code doesn't get
triggered for the truncate case.  It exists for the extend case, where
we extend the allocation in multiple clean transactions, then finally
set i_size in a final transaction.

Joel

-- 

"When choosing between two evils, I always like to try the one
 I've never tried before."
        - Mae West

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
