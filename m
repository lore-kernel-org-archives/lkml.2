Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab1C1Rmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:42:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55657 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab1C1Rmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:42:51 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=XYJHFtupD_QA:10 a=-AZnrn_YvKEA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=3E0ccD1kAm_z4OvWgVUA:9 a=l83yh_PPMTJZ-RIQV8QA:7 a=l1OEByQpYqq7Kgb0zgZriW6KWD8A:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 28 Mar 2011 13:42:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: John Lepikhin <johnlepikhin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: Very aggressive memory reclaim
Message-ID: <20110328174250.GE8529@home.goodmis.org>
References: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Add Cc's of those that may help you ]

-- Steve

On Mon, Mar 28, 2011 at 08:39:29PM +0400, John Lepikhin wrote:
> Hello,
> 
> I use high-loaded machine with 10M+ inodes inside XFS, 50+ GB of
> memory, intensive HDD traffic and 20..50 forks per second. Vanilla
> kernel 2.6.37.4. The problem is that kernel frees memory very
> aggressively.
> 
> For example:
> 
> 25% of memory is used by processes
> 50% for page caches
> 7% for slabs, etc.
> 18% free.
> 
> That's bad but works. After few hours:
> 
> 25% of memory is used by processes
> 62% for page caches
> 7% for slabs, etc.
> 5% free.
> 
> Most of files are cached, works perfectly. This is the moment when
> kernel decides to free some memory. After memory reclaim:
> 
> 25% of memory is used by processes
> 25% for page caches(!)
> 7% for slabs, etc.
> 43% free(!)
> 
> Page cache is dropped, server becomes too slow. This is the beginning
> of new cycle.
> 
> I didn't found any huge mallocs at that moment. Looks like because of
> large number of small mallocs (forks) kernel have pessimistic forecast
> about future memory usage and frees too much memory. Is there any
> options of tuning this? Any other variants?
> 
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
