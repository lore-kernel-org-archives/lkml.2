Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935768Ab1ETTXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 15:23:09 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:41870 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935718Ab1ETTXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 15:23:07 -0400
X-ASG-Debug-ID: 1305919385-03d6a50f30c4570001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DD6BF94.7000902@fusionio.com>
Date: Fri, 20 May 2011 21:23:00 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>,
        open list:
	MEMORY MANAGEMENT <linux-mm@kvack.org>, ;
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH 1/8] mm: Kill set but not used var in  bdi_debug_stats_show()
References: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
X-ASG-Orig-Subj: Re: [PATCH 1/8] mm: Kill set but not used var in  bdi_debug_stats_show()
In-Reply-To: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1305919385
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64312
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-20 21:12, Gustavo F. Padovan wrote:
> Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
> ---
>  mm/backing-dev.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index befc875..f032e6e 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -63,10 +63,10 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
>  	unsigned long background_thresh;
>  	unsigned long dirty_thresh;
>  	unsigned long bdi_thresh;
> -	unsigned long nr_dirty, nr_io, nr_more_io, nr_wb;
> +	unsigned long nr_dirty, nr_io, nr_more_io;
>  	struct inode *inode;
>  
> -	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
> +	nr_dirty = nr_io = nr_more_io = 0;
>  	spin_lock(&inode_wb_list_lock);
>  	list_for_each_entry(inode, &wb->b_dirty, i_wb_list)
>  		nr_dirty++;

Good catch, nr_wb should have been killed with the removal of the worker
list. I'll queue this up.

-- 
Jens Axboe

