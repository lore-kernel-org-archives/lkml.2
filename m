Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab2BVSBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 13:01:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64932 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab2BVSBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 13:01:16 -0500
Date: Wed, 22 Feb 2012 10:01:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120222180112.GB32694@google.com>
References: <20120221211938.GE12236@google.com>
 <1329917459.24994.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329917459.24994.14.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Peter.

On Wed, Feb 22, 2012 at 02:30:59PM +0100, Peter Zijlstra wrote:
> FWIW I'm all for ripping the orthogonal hierarchy crap out, I hate it
> just about as much as you do judging from your write-up.

I just don't get why it's there.  Maybe, there can be some remote use
cases where orthogonal hierarchies can be useful but structuring whole
cgroup around that seems really extreme.

> I'm not sure on your process hierarchy pie though, I rather like being
> able to assign tasks to cgroups of my making without having to mirror
> that in the process hierarchy.

The only question is whether we want to allow cgroup hierarchy to be
completely orthogonal from process tree structure, which I don't think
is a good idea.  It shouldn't affect trivial use cases.  If not
explicitly configured, all tasks would live in a single root cgroup -
much like every process would belong to the same session if nobody
does setsid() since boot (or container).

I don't know how the implementation would turn out and it may as well
stay separate as it is now but I still think the topology should match
pstree.

Thanks.

-- 
tejun
