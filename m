Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab2B1Vyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 16:54:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab2B1Vyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 16:54:51 -0500
Date: Tue, 28 Feb 2012 16:54:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120228215439.GJ9920@redhat.com>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
 <20120222165714.GC4128@redhat.com>
 <1329990094.24994.64.camel@twins>
 <20120223213847.GK19691@redhat.com>
 <20120223223457.GJ22536@google.com>
 <20120228211627.GH9920@redhat.com>
 <1330464100.11248.94.camel@twins>
 <20120228213526.GI9920@redhat.com>
 <1330465434.11248.98.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330465434.11248.98.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:43:54PM +0100, Peter Zijlstra wrote:
> On Tue, 2012-02-28 at 16:35 -0500, Vivek Goyal wrote:
> > For
> > cpu controller, it is priority at the group level no fixed minimum/maximum
> > % shares. And that's a limitation of treating task and group at same level.
> 
> Depends on what you mean by min/max %, you can do it on the group level
> by using bandwidth caps (for max) or inverted (max on everybody else,
> for min).

I was referring to using pure proportional controller. max bandwidth is
new and I am looking for a quick documentation file which describes
what are the knobs and how to use it. Did not find any in
Documentation/cgroups/. Is there any documentation available?

I am assuming that max are being specified for groups in some absolute
quantity. That is fine. It will not still be max %, as again for % you
need fixed number of entities at any level and that's not the case with
tasks.

Minimum for one group (max for everyone else) will also only work if 
task and groups are not at same level.

I think the only way to get fixed % share is not to put task and group
at same level during system configuration.

Thanks
Vivek
