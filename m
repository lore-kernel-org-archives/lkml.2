Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab0CVTYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:24:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab0CVTYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:24:02 -0400
Message-ID: <4BA7C3A7.3040602@redhat.com>
Date: Mon, 22 Mar 2010 21:23:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Joerg Roedel <joro@8bytes.org>, Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <20100322111040.GL13108@8bytes.org> <20100322122228.GH3483@elte.hu> <20100322134633.GD1940@8bytes.org> <20100322163215.GC18796@elte.hu> <4BA7AC6B.3050103@redhat.com> <20100322191028.GB21919@elte.hu>
In-Reply-To: <20100322191028.GB21919@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 09:10 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/22/2010 06:32 PM, Ingo Molnar wrote:
>>      
>>> So, what do you think creates code communities and keeps them alive?
>>> Developers and code. And the wellbeing of developers are primarily
>>> influenced by the repository structure and by the development/maintenance
>>> process - i.e. by the 'fun' aspect. (i'm simplifying things there but
>>> that's the crux of it.)
>>>        
>> There is nothing fun about having one repository or two.  Who cares about
>> this anyway?
>>
>> tools/kvm/ probably will draw developers, simply because of the glory
>> associated with kernel work.  That's a bug, not a feature.  It means that
>> effort is not distributed according to how it's needed, but because of
>> irrelevant considerations.
>>      
> And yet your solution to that is to ... do all your work in the kernel space
> and declare the tooling as something that does not interest you? ;-)
>    

I have done plenty of userspace work in qemu.  I don't have a lack of 
interest in qemu, just in a desktop GUI.  I'm not a GUI person and my 
employer doesn't have a desktop-on-desktop virtualization product that I 
know of.

>> Something I've wanted for a long time is to port kvm_stat to use tracepoints
>> instead of the home-grown instrumentation.  But that is unrelated to this
>> new tracepoint.  Other than that we're satisfied with ftrace.
>>      
> Despite it being another in-kernel subsystem that by your earlier arguments
> should be done via a user-space package? ;-)
>    

I'm satisfied with it as a user.  Architecturally, I'd have preferred it 
to be a userspace tool.  It might have improved usability as well to 
have something with --help instead of a set of debugfs files.  But I'm a 
lot happier with ftrace existing as a kernel component than not at all.

>>> You should realize that naturally developers will gravitate towards the
>>> most 'fun' aspects of a project. It is the task of the maintainer to keep
>>> the balance between fun and utility, bugs and features, quality and
>>> code-rot.
>>>        
>> There are plenty of un-fun tasks (like fixing bugs and providing RAS
>> features) that we're doing.  We don't do this for fun but to satisfy our
>> users.
>>      
> So which one is it, KVM developers are volunteers that do fun stuff and cannot
> be told about project priorities, or KVM developers are pros who do unfun
> stuff because they can be told about priorities?
>    

 From my point of view as maintainer, all contributors are volunteers, I 
can't tell any of them what to do.  From the point of view of many of 
these volunteer's employers, they are wage slaves who do as they're told 
or else.

So: when someone sends me a patch I gratefully accept if it is good or 
point out the issues if not.  At the secret Red Hat headquarters and the 
kvm weekly conference call I participate in deciding priorities and task 
assignments.

> I posit that it's both: and that priorities can be communicated - if only you
> try as a maintainer. All i'm suggesting is to add 'usable, unified user-space'
> to the list of unfun priorities, because it's possible and because it matters.
>    

So: I require a volunteer to write some GUI code before I accept a 
patch.  Back at the Red Hat lair, we think of what features we drop from 
the product because the kvm maintainer has gone nuts.

The 'unified' part of your suggestion is not a requirement, but an 
implementation detail.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

