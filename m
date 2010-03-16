Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab0CPHoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:44:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:39959 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435Ab0CPHof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:44:35 -0400
Message-ID: <4B9F36C7.4020304@kernel.org>
Date: Tue, 16 Mar 2010 16:44:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>, penberg@cs.helsinki.fi,
       adobriyan@gmail.com
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
References: <4B990496.4020002@kernel.org> <4B9F08AC.9030904@kernel.org> <20100316061718.GA22651@elte.hu> <4B9F2B0A.70507@kernel.org>
In-Reply-To: <4B9F2B0A.70507@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 07:44:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/16/2010 03:54 PM, Tejun Heo wrote:
> Maybe a better way is to grab for slab API usages in .c files which
> don't have slab.h inclusion.  If breaking the dependency is the way to
> go, I can definitely write up some scripts and do test builds on some
> archs.  There sure will be some fallouts but I think it won't be too
> bad.

Hmmm... here are some interesting numbers.  Not completely exact but
should give the general ballpark idea.

all .c files					: 13999
.c files which use any of slab interface	:  5603
.c files which include slab.h			:  2519
.c files which include slab.h but don't use it	:   577
.c files which use slab but don't include it	:  3661

.c files with k[mzc]alloc/k[z]free usage	:  5291
.c files with other slab interface usage	:   356

C files which use k[mzc]alloc/k[z]free covers ~38% of all c files.
One possibility is to separate out those into kmalloc.h and make it
available universally via kernel.h.

Thanks.

-- 
tejun
