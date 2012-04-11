Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509Ab2DKOWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:22:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760495Ab2DKOWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:22:01 -0400
Message-ID: <4F85936A.6060509@redhat.com>
Date: Wed, 11 Apr 2012 17:21:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com> <20120409175829.GB21894@amt.cnet> <4F8329D3.7000605@gmail.com> <20120409194614.GB23053@amt.cnet> <4F840DD2.3090101@redhat.com> <20120410204031.ffb5b976225ac9fe6dae474e@gmail.com> <4F842074.1050108@linux.vnet.ibm.com> <20120411211514.35db29c11460516e604059b6@gmail.com> <4F857B61.9080602@linux.vnet.ibm.com> <20120411231441.9d0984672dd252b806f99128@gmail.com>
In-Reply-To: <20120411231441.9d0984672dd252b806f99128@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 05:14 PM, Takuya Yoshikawa wrote:
> On Wed, 11 Apr 2012 20:38:57 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
>
> > Well, my point is that live migration is so very useful that it is worth
> > to be improved, the description of your also proves this point.
> > 
> > What is your really want to say but i missed?
>
> How to improve and what we should pay for that.
>
> Note that I am not objecting to O(1) itself.
>
> Do you remember that when we discussed O(1) issue last year, with Avi,
> the agreement was that we should take more time and look carefully
> with more measurements to confirm if it's really worthwhile.
>
> The point is whether we should do O(1) now, including near future.
>
> My opinion is that we should do what we can do now and wait for feedback
> from real users.
>
> Before making the current code stable, I do not want to see it replaced
> so dramatically.  Otherwise when can we use live migration with enough
> confidence?  There may be another subtle bugs we should fix now.
>
> In addition, XBRZLE and post-copy is now being developed in QEMU.
>
>
> What do you think about this Avi, Marcelo?

Currently the main performance bottleneck for migration is qemu, which
is single threaded and generally inefficient.  However I am sure that
once the qemu bottlenecks will be removed we'll encounter kvm problems,
particularly with wide (many vcpus) and large (lots of memory) guests. 
So it's a good idea to improve in this area.  I agree we'll need to
measure each change, perhaps with a test program until qemu catches up.

> I am testing the current live migration to see when and for what it can
> be used.  I really want to see it become stable and usable for real
> services.

Well, it's used in production now.

> > Okay, let us to compare the performance number after O(1) implemented.
>
> From my experience, I want to say that live migration is very difficult
> to say about performance.  That is the problem I am now struggling with.
>
> I developed dirty-log-perf unit-test for that but that was not enough.
>
> Needless to say, checking the correctness is harder.
>
>
> So I really do not want to see drastic change now without any real need
> or feedback from real users -- this is my point.
>

It's a good point, we should avoid change for its own sake.

-- 
error compiling committee.c: too many arguments to function

