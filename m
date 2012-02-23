Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab2BWIKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 03:10:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60619 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab2BWIKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 03:10:34 -0500
Message-ID: <4F45F1F0.2010102@cn.fujitsu.com>
Date: Thu, 23 Feb 2012 15:59:44 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
References: <20120221211938.GE12236@google.com> <20120222163858.GB4128@redhat.com>
In-Reply-To: <20120222163858.GB4128@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-23 15:55:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-23 15:55:52,
	Serialize complete at 2012-02-23 15:55:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Trying to make all the controllers uniform in terms of their treatment
> of cgroup hiearchy sounds like a good thing to do.

Agreed.

Apart from nesting cgroups, there're other inconsistencies.

- Some controllers disallow more than one cgroup layer. That's the new
net_prio controller, and I don't know why it's made so, but I guess
it's fine to eliminate this restriction.

- Some controllers move resource charges when a task is moved to
a different cgroup, but some don't?

- Some controllers disallow task attaching under some circumstances.
So if we have a single hierarchy with all subsystems, the chance
that attaching a task to a cgroup fails may be bigger.

> Once that is done,
> one can probably see if it is worth to put all the controllers in a
> single hierarchy.
> 
