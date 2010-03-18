Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab0CRKdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:33:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0CRKdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:33:15 -0400
Message-ID: <4BA20153.5060409@redhat.com>
Date: Thu, 18 Mar 2010 12:32:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318092232.GC2157@elte.hu>
In-Reply-To: <20100318092232.GC2157@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 11:22 AM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>>>   - move a clean (and minimal) version of the Qemu code base to tools/kvm/,
>>>     in the upstream kernel repo, and work on that from that point on.
>>>        
>> I'll ignore the repository location which should be immaterial to a serious
>> developer and concentrate on the 'clean and minimal' aspect, since it has
>> some merit.  [...]
>>      
> To the contrary, experience shows that repository location, and in particular
> a shared repository for closely related bits is very much material!
>
> It matters because when there are two separate projects, even a "serious
> developer" is finding it double and triple difficult to contribute even
> trivial changes.
>
> It becomes literally a nightmare if you have to touch 3 packages: kernel, a
> library and an app codebase. It takes _forever_ to get anything useful done.
>    

You can't be serious.  I find that the difficulty in contributing a 
patch has mostly to do with writing the patch, and less with figuring 
out which email address to send it to.

> Also, 'focus on a single thing' is a very basic aspect of humans, especially
> those who do computer programming. Working on two code bases in two
> repositories at once can be very challenging physically and psychically.
>    

Indeed, working simultaneously on two different projects is difficult.  
I usually work for a while on one, and then 'cd', physically and 
psychically, to the other.  Then switch back.  Sort of like the 
scheduler on a uniprocessor machine.

> So what i've seen is that OSS programmers tend to pick a side, pretty much
> randomly, and then rationalize it in hindsight why they prefer that side ;-)
>
> Most of them become either a kernel developer or a user-space package
> developer - and then they specialize on that field and shy away from changes
> that involve both. It's a basic human thing to avoid the hassle that comes
> with multi-package changes. (One really has to be outright stupid, fanatic or
> desperate to even attempt such changes these days - such are the difficulties
> for a comparatively low return.)
>    

We have a large number of such stupid, fanatic, desperate developers in 
the qemu and kvm communities.

> The solution is to tear down such artificial walls of contribution where
> possible. And tearing down the wall between KVM and qemu-kvm seems very much
> possible and the advantages would be numerous.
>
> Unless by "serious developer" you meant: "developer willing to [or forced to]
> waste time and effort on illogically structured technology".
>    

By "serious developer" I mean

  - someone who is interested in contributing, not in getting their name 
into the kernel commits list
  - someone who is willing to read the wiki page and find out where the 
repository and mailing list for a project is
  - someone who will spend enough time on the project so that the time 
to clone two repositories will not be a factor in their contributions
  - someone who will work on the uncool stuff like fixing bugs and 
providing interfaces to other tools

>> [...]
>>
>> Do you really think the echo'n'cat school of usability wants to write a GUI?
>> In linux-2.6.git?
>>      
> Then you'll be surprised to hear that it's happening as we speak and the
> commits are there in linux-2.6.git. Both a TUI and GUI is in the works.
>
> Furthermore, the numbers show that half of the usability fixes to tools/perf/
> came not from regular perf contributors but from random kernel developers and
> testers who when they build the latest kernel and try out perf at the same
> time (it's very easy because you already have it in the kernel repository - no
> separate download, no installation, etc. necessary).
>
> I had literally zero such contributions when (the precursor to) 'perf' was
> still a separate user-space project.
>
> You could have the same effect for Qemu: the latest bits in tools/kvm/ would
> be built by regular kernel testers and developers. The integration benefits
> dont just extend to developers, a unified project is vastly easier to test as
> well.
>
>    

Let's wait and see then.  If the tools/perf/ experience has really good 
results, we can reconsider this at a later date.

-- 
error compiling committee.c: too many arguments to function

