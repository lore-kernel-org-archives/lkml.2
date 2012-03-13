Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2CMQAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:00:03 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51938 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2CMQAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:00:00 -0400
Date: Tue, 13 Mar 2012 08:59:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120313155955.GB7349@google.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
 <20120312222817.GI23255@google.com>
 <20120313140345.GC29169@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313140345.GC29169@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Tue, Mar 13, 2012 at 10:03:45AM -0400, Vivek Goyal wrote:
> > With root being treated specially, probably as just being a equal
> > group as other groups, I'm not fully determined about that yet.
> 
> So what wrong with flattening the whole hierarchy and all groups being active
> in the path? It is not worse then second option?
> 
>              root
>        /   |  |  |  \
>       G1  G2  G3 G31 G32

It is worse because while there isn't much need for orthogonal
hierarchies, people often need to apply different limits at different
levels of the hierarchy for different controllers.  ie. it often
happens that the distinction between G31 and G32 matters for one
controller but not for others.  The problem with flattening like you
suggested above is that it isn't a hierarchy at all - membership isn't
recursive.

Imposing limits at single level is an additional restriction and may
cause some config complexity but it'll be at least explicit and can
co-exist with full hierarchy in meaningful way.

Thanks.

-- 
tejun
