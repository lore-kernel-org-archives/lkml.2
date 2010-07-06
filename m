Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0GFHLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:11:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59301 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab0GFHLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:11:43 -0400
Date: Tue, 6 Jul 2010 00:10:31 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 2/2] ocfs2: No need to zero pages past i_size. i_size v2
Message-ID: <20100706071031.GE13023@mail.oracle.com>
Mail-Followup-To: Tao Ma <tao.ma@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
References: <20100702224912.GC5800@mail.oracle.com>
 <20100703213219.GB21262@mail.oracle.com>
 <20100703213343.GC21262@mail.oracle.com>
 <4C30A4FD.4030900@oracle.com>
 <4C3137A2.8040409@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3137A2.8040409@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C32D710.01F2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 09:38:42AM +0800, Tao Ma wrote:
> btw, do we ever have a chance that start + wc->w_num_pages >
> end_index? I can't find it.

	Of course.  If you have a 1MB clustersize, w_num_pages will be
256.  But if you are only writing the first page of the cluster,
end_index is only 1.

Joel

-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
