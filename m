Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0CVRa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:30:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab0CVRaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:30:55 -0400
Message-ID: <4BA7A917.5030101@redhat.com>
Date: Mon, 22 Mar 2010 19:29:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321200849.GA51323@dspnet.fr.eu.org> <4BA67D75.8060809@redhat.com> <20100321203704.GB30194@elte.hu> <4BA71012.7070004@redhat.com> <20100322113931.GE3483@elte.hu> <4BA76649.5080307@redhat.com> <20100322142657.GD14201@elte.hu>
In-Reply-To: <20100322142657.GD14201@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 04:26 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/22/2010 01:39 PM, Ingo Molnar wrote:
>>      
>>> Reality is, the server space never was and never will be self-sustaining
>>> in the long run (as Novell has found it out with Netware), it is the
>>> desktop that dictates future markets. This is why i find your views about
>>> this naive and shortsighted.
>>>        
>> Yet Linux is gaining ground in the server and embedded space while
>> struggling on the desktop. [...]
>>      
> Frankly, Linux is mainly growing in the server space due to:
>
>   1) the server space is technically much simpler than the desktop space. It
>      is far easier to code up a server performance feature than to make
>      struggle through stupid (server-motivated) package boundaries and get
>      something done on the desktop. It is far easier to code up a server app
>      as that space is well standardized and servers tend to be compartmented.
>      Integration between server apps is much less common than integration
>      between desktop apps, hence the harm that our modularization idiocies
>      cause less harm.
>
>   2) Linux's growth is still feeding on the remains of the destruction of Unix.
>    

Agreed (minus the 'package boundaries' stuff).  Also, Linux is cheaper 
than Windows.

> Linux is struggling on the desktop due to the desktop's inherent complexity,
> due to the lack of the Unix inertia and due to incompetence, insensitivity,
> intellectual arrogance and shortsightedness of server-centric thinking, like
> your arguments/position displayed in this very thread.
>    

It's struggling because it isn't competitive technically with other 
desktops, because there is no application base, because of a 
chicken-and-egg problem with some drivers, because lack of a stable ABI 
means you can't get a driver CD with your device so you need a 
yet-unreleased kernel, because the zillion binary incompatible 
distributions mean that application developers don't know what to code 
and test for, because of lack of documentation, to name a few.  At least 
it's improving all the time.

The incompetence, insensitivity, intellectual arrogance and 
shortsightedness of server-centric thinking of my arguments/position are 
a result of this, not the cause.

>> [...] Apple is gaining ground on the desktop but is invisible on the server
>> side (despite having a nice product - Xserve).
>>      
> But the thing is, Apple doesnt really care about the server space, yet. It is
> lucrative but it is a side-show: it will fall automatically to the 'winner' of
> the desktop (or gadget) of tomorrow.
>    

It won't automatically fall to Apple, there's tons of middleware and 
server apps that need porting (the "ecosystem"), plus they need to work 
hard on improving their kernel which is desktop oriented.  Looks like 
they're interesting in other things.

> Has the quick fall of Banyan Vines or Netware (both excellent all-around
> server products) taught you nothing?
>    

Not familiar with Banyan, but wasn't Netware a cooperative multitasking 
command line only thing?  It couldn't compete with preemptive modern 
system with a nice GUI.  Windows didn't need the desktop to win that fight.

> We need a lot more desktop focus in the kernel community. The best method to
> achieve this, that i know of currently, is to simply have kernel developers
> think outside the kernel box and to have them do bits of user-space coding as
> well - and in particular desktop coding. To eat our own dogfood in essence.
> Suffer through crap we cause to user-space. To face the _real_ difficulties of
> users. We seem to have forgotten our roots.
>    

Try it yourself and report the experience.  Note: perf is not desktop 
development, it's kernel tooling development.

>> [...]
>>
>> It's true Windows achieved server dominance through it's desktop power, but
>> I don't think that's what keeping them there now.
>>      
> What is keeping them there is precisely that.
>    

Not at all.  They have excellent development tools and lots of 
middleware and other third party products that make it easy to pick 
Windows.  For example, Exchange is more or less standard for groupware, 
and they made C# and the technology around it easy to develop for, 
learning from Java's mistakes.

>> In any case, I'm not going to write a kvm GUI.  It doesn't match my skills,
>> interest, or my employer's interest.  If you wish to see a kvm GUI you have
>> to write one yourself or convince someone to write it (perhaps convince Red
>> Hat to fund such an effort beyond virt-manager).
>>      
> As a maintainer you certainly dont have to write a single line of code, if you
> dont want to. You 'just' need to care about the big picture and encourage/help
> the flow and balance of the whole project.
>    

I haven't written that line of code, and no one else has either.  Don't 
tell me they're all scared of me.

-- 
error compiling committee.c: too many arguments to function

