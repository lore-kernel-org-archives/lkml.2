Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0CRVCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:02:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209Ab0CRVCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:02:36 -0400
Message-ID: <4BA294D4.2060700@redhat.com>
Date: Thu, 18 Mar 2010 11:02:12 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <4BA1FC80.2000401@redhat.com> <20100318105013.GB24464@elte.hu>
In-Reply-To: <20100318105013.GB24464@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2010 12:50 AM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>>> The moment any change (be it as trivial as fixing a GUI detail or as
>>> complex as a new feature) involves two or more packages, development speed
>>> slows down to a crawl - while the complexity of the change might be very
>>> low!
>>>        
>> Why is that?
>>      
> It's very simple: because the contribution latencies and overhead compound,
> almost inevitably.
>
> If you ever tried to implement a combo GCC+glibc+kernel feature you'll know
> ...
>
> Even with the best-run projects in existence it takes forever and is very
> painful - and here i talk about first hand experience over many years.
>    

Ingo, what you miss is that this is not a bad thing.  Fact of the matter 
is, it's not just painful, it downright sucks.

This is actually a Good Thing (tm).  It means you have to get your 
feature and its interfaces well defined and able to version forwards and 
backwards independently from each other.  And that introduces some 
complexity and time and testing, but in the end it's what you want.  You 
don't introduce a requirement to have the feature, but take advantage of 
it if it is there.

It may take everyone else a couple years to upgrade the compilers, 
tools, libraries and kernel, and by that time any bugs introduced by 
interacting with this feature will have been ironed out and their 
patterns well known.

If you haven't well defined and carefully thought out the feature ahead 
of time, you end up creating a giant mess, possibly the need for nasty 
backwards compatibility (case in point: COMPAT_VDSO).  But in the end, 
you would have made those same mistakes on your internal tree anyway, 
and then you (or likely, some other hapless project maintainer for the 
project you forked) would have to go add the features, fixes and 
workarounds back to the original project(s).  However, since you 
developed in an insulated sheltered environment, those fixes and 
workarounds would not be robust and independently versionable from each 
other.

The result is you've kept your codebase version-neutral, forked in 
outside code, enhanced it, and left the hard work of backporting those 
changes and keeping them version-safe to the original package 
maintainers you forked from.  What you've created is no longer a single 
project, it is called a distro, and you're being short-sighted and 
anti-social to think you can garner more support than all of those 
individual packages you forked.  This is why most developers work 
upstream and let the goodness propagate down from the top like molten 
sugar of each granular package on a flan where it is collected from the 
rich custard channel sitting on a distribution plate below before the 
big hungry mouth of the consumer devours it and incorporates it into 
their infrastructure.

Or at least, something like that, until the last sentence.  In short, if 
project A has Y active developers, you better have Z >> Y active 
developers to throw at project A when you fork it into project B.

Zach
