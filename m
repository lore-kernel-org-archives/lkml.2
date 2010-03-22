Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0CVUgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:36:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab0CVUgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:36:15 -0400
Message-ID: <4BA7D48F.8000806@redhat.com>
Date: Mon, 22 Mar 2010 22:35:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander Graf <agraf@suse.de>, "Daniel P. Berrange" <berrange@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>,
       LKML Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel General <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7AF2D.7060306@redhat.com> <4BA7C1D7.5070208@codemonkey.ws> <20100322193100.GB28709@redhat.com> <E548536E-4D62-4B17-BA09-9C12EB1A2717@suse.de> <20100322195403.GC3306@elte.hu> <2D740A89-F53F-4F72-B44C-B72942E883E9@suse.de> <20100322202144.GF3306@elte.hu>
In-Reply-To: <20100322202144.GF3306@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 10:21 PM, Ingo Molnar wrote:
> * Alexander Graf<agraf@suse.de>  wrote:
>
>    
>>> Furthermore, another negative effect is that many times features are
>>> implemented not in their technically best way, but in a way to keep them
>>> local to the project that originates them. This is done to keep deployment
>>> latencies and general contribution overhead down to a minimum. The moment
>>> you have to work with yet another project, the overhead adds up.
>>>        
>> I disagree there. Keeping things local and self-contained has been the UNIX
>> secret. It works really well as long as the boundaries are well defined.
>>      
> The 'UNIX secret' works for text driven pipelined commands where we are
> essentially programming via narrow ASCII input of mathematical logic.
>
> It doesnt work for a GUI that is a 2D/3D environment of millions of pixels,
> shaped by human visual perception of prettiness, familiarity and efficiency.
>    

Modularization is needed when a project exceeds the average developer's 
capacity.  For kvm,  it is logical to separate privileged cpu 
virtualization, from guest virtualization, from host management, from 
cluster management.

>> The problem we're facing is that we're simply lacking an active GUI /
>> desktop user development community. We have desktop users, but nobody feels
>> like tackling the issue of doing a great GUI project while talking to
>> qemu-devel about his needs.
>>      
> Have you made thoughts about why that might be so?
>
> I think it's because of what i outlined above - that you are trying to apply
> the "UNIX secret" to GUIs - and that is a mistake.
>
> A good GUI is almost at the _exact opposite spectrum_ of good command-line
> tool: tightly integrated, with 'layering violations' designed into it all over
> the place:
>
>    look i can paste the text from an editor straight into a firefox form. I
>    didnt go through any hiearchy of layers, i just took the shortest path
>    between the apps!
>    

Nope.  You copied text from one application into the clipboard (or 
selection, or PRIMARY, or whatever
) and pasted text from the clipboard to another application.  If firefox 
and your editor had to interact directly, all would be lost.

See - there was a global (for the session) third party, and it wasn't 
the kernel.

> In other words: in a GUI the output controls the design, for command-line
> tools the design controls the output.
>    

Not in GUIs that I've seen the internals of.

> It is no wonder Unix always had its problems with creating good GUIs that are
> efficient to humans. A good GUI works like the human brain, and the human
> brain does not mind 'layering violations' when that gets it a more efficient
> result.
>    

The problem is that only developers are involved, not people who 
understand human-computer interaction (in many cases, not human-human 
interaction either).  Another problem is that a good GUI takes a lot of 
work so you need a lot of committed resources.  A third problem is that 
it isn't a lot of fun, at least not the 20% of the work that take 800% 
of the time.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

