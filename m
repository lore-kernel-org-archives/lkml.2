Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab2CLWjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:39:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62289 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2CLWjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:39:49 -0400
Date: Mon, 12 Mar 2012 15:39:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120312223944.GJ23255@google.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
 <20120312222817.GI23255@google.com>
 <1331591568.18960.61.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331591568.18960.61.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 12, 2012 at 11:32:48PM +0100, Peter Zijlstra wrote:
> I'm assuming that G31/G32's tasks end up in G3 in the first case, but
> where do the tasks in G3 go to in the second case?

Collapsed into the root group.  The controller simply doesn't have
anything configured at that layer.

> Also, why allow non-hierarchical controllers to begin with? I would very
> much argue for mandating that all controllers work the same wrt
> hierarchy and if that means ditching hierarchy support we should do that
> and modify cgroupfs to not allow creation of directories deeper than 1.
> 
> But allowing controllers that implement hierarchy proper and controllers
> that do not and then force them in the same mount point, that just
> doesn't make any friggin sense what so ever.

Hmmm... that could be a good final goal but I think supporting mapping
to flat structure will simplify the transition much easier, or
possible.  That way, core transition can be mostly decoupled from
controller updates.  If we can get to the point where nesting is fully
supported by every controller first, that would be awesome too.

Thanks.

-- 
tejun
