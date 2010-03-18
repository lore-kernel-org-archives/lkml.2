Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0CRSUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:20:33 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:35562 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab0CRSUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:20:31 -0400
Message-ID: <4BA26EEA.5090906@codemonkey.ws>
Date: Thu, 18 Mar 2010 13:20:26 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu> <4BA20EB8.60707@redhat.com> <20100318114821.GB13168@elte.hu> <4BA23E61.4080003@codemonkey.ws> <20100318161310.GA447@elte.hu>
In-Reply-To: <20100318161310.GA447@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 11:13 AM, Ingo Molnar wrote:
> Good that you mention it, i think it's an excellent example.
> The suckage of kernel async IO is for similar reasons: there's an ugly package
> separation problem between the kernel and between glibc - and between the apps
> that would make use of it.
>
> ( With the separated libaio it was made worse: there were 3 libraries to
>    work with, and even less applications that could make use of it ... )
>
> So IMO klibc is an arguably good idea - eventually hpa will get around posting
> it for upstream merging again. Then we could offer both new libraries much
> faster, and could offer things like comprehensive AIO used pervasively within
> existing APIs.
>    

And why wouldn't the kernel developers produce posix-aio within klibc.

posix-aio is also a really terrible interface (although not as bad as 
linux-aio).

The reason boils down to the fact that these interfaces are designed 
without interacting with the consumers.  Part of the reason for that is 
the attitude of the community.

You approached this discussion with, "QEMU/KVM sucks, you should move 
into the kernel because we're awesome and we'd fix everything in a heart 
beat".  That attitude does not result in any useful collaboration.

Had you started trying to understand what the problems that we face are 
and whether there's anything that can be done in the kernel to improve 
it, it would have been an entirely different discussion.

The sad thing is, QEMU is probably one of the most demanding free 
software applications out there today with respect to performance.  We 
consume interfaces IO interfaces and things like large pages in a deeper 
way than just about any application out there.

We've been trying for a long time to improve Linux interfaces for years 
but we've not had many people in the kernel community be receptive.

We've failed to improve the userspace networking interfaces.  Compare 
Rusty's posting of vringfd to vhost-net.  They are the same interface 
except we tried to do something more generally useful with vringfd and 
it was shot down because it was "yet another kernel/userspace data 
transfer interface".  Unfortunately, we're learning that if we claim 
something is virtualization specific, we avoid a lot of the kernel 
bureaucracy.  My concern is that over time, we'll have more things like 
vhost and that's bad for everyone.

Regards,

Anthony Liguori

