Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2AKSbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 13:31:23 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51524 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab2AKSbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 13:31:19 -0500
Date: Wed, 11 Jan 2012 22:31:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyle Moffett <kyle@moffetthome.net>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [RFC] on general object IDs again
Message-ID: <20120111183115.GA28196@moon>
References: <20120111161939.GI8752@moon>
 <CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com>
 <20120111175952.GI466@moon>
 <CAHGf_=oMk2YDnmsomgCc45Ei5yaSdNzRwapm7Fqm9mN7LY0FNw@mail.gmail.com>
 <4F0DD365.6070200@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0DD365.6070200@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 10:22:29PM +0400, Pavel Emelyanov wrote:
> On 01/11/2012 10:19 PM, KOSAKI Motohiro wrote:
> >> Hi Kosaki,
> >>
> >> the idea on user-space is something like
> >>
> >>  - collect all pids to dump
> >>  - collect IDs for every pid
> >>  - sort the IDs obtained
> >>  - find the same IDs (which will be kind of find intersections in a sets of IDs) and
> >>   set up CLONE_ flags on restore procedure as appropriate (for example if
> >>   GEN_OBJ_ID_VM IDs for two or more tasks are the same we need to use CLONE_VM
> >>   at restore time, and so on).
> > 
> > Then, you only need to compare. not any other calculation. i.e. only
> > need id uniqueness.
> > And any resource are referenced from tasks. so, can you reuse pid for
> > this? example,
> > two taska share one mm.
> > 
> > task-a(pid: 100)
> >               |-----------------mm
> > task-b(pid: 200)
> > 
> > 
> > gen_obj_id(task-b, GEN_OBJ_ID_VM) return 100. (youngest pid of referenced tasks)
> 
> We can, but determining the youngest pid for an mm struct is O(N) algo.
> Having N tasks with N mm_structs getting the sharing picture becomes O(N^2).
> 

Yeah, exactly. If not the speed problem we would simply stick
with Andrew's proposal as two-id-are-the-same(pid1, pid2)
syscall. But when we get a number of pids to dump we need the
resource affinity picture over them all.

	Cyrill
