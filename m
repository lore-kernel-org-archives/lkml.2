Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0CXS1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:27:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618Ab0CXS1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:27:46 -0400
Date: Wed, 24 Mar 2010 15:27:05 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>, Anthony Liguori <anthony@codemonkey.ws>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       ziteng.huang@intel.com, Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
	project
Message-ID: <20100324182705.GF3625@ghostprotocols.net>
References: <20100324134642.GD14800@8bytes.org> <4BAA1A53.20207@redhat.com> <20100324150137.GE14800@8bytes.org> <4BAA2BF7.4060407@redhat.com> <20100324154605.GG14800@8bytes.org> <4BAA3496.2010901@redhat.com> <20100324155927.GI14800@8bytes.org> <4BAA393A.9000105@redhat.com> <20100324174703.GD3625@ghostprotocols.net> <4BAA57DA.5030707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA57DA.5030707@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 24, 2010 at 08:20:10PM +0200, Avi Kivity escreveu:
> On 03/24/2010 07:47 PM, Arnaldo Carvalho de Melo wrote:
>> Em Wed, Mar 24, 2010 at 06:09:30PM +0200, Avi Kivity escreveu:
>>    
>>> Doesn't perf already has a dependency on naming conventions for finding
>>> debug information?
>>>      
>> It looks at several places, from most symbol rich (/usr/lib/debug/, aka
>> -debuginfo packages, where we have full symtabs) to poorest (the
>> packaged binary, where we may just have a .dynsym).
>>
>> In an ideal world, it would just get the build-id (a SHA1 cookie that is
>> in an ELF session inserted in every binary (aka DSOs), kernel module,
>> kallsyms or vmlinux file) and use that to look first in a local cache
>> (implemented in perf for a long time already) or in some symbol server.
>>
>> For instance, for a random perf.data file I collected here in my machine
>> I have:
>>
>> [acme@doppio linux-2.6-tip]$ perf buildid-list | grep libpthread
>> 5c68f7afeb33309c78037e374b0deee84dd441f6 /lib64/libpthread-2.10.2.so
>> [acme@doppio linux-2.6-tip]$
>>
>> So I don't have to access /lib64/libpthread-2.10.2.so directly, nor some
>> convention to get a debuginfo in a local file like:
>>
>> /usr/lib/debug/lib64/libpthread-2.10.2.so.debug
>>
>> Instead the tools look at:
>>
>> [acme@doppio linux-2.6-tip]$ l ~/.debug/.build-id/5c/68f7afeb33309c78037e374b0deee84dd441f6
>> lrwxrwxrwx 1 acme acme 73 2010-01-06 18:53 /home/acme/.debug/.build-id/5c/68f7afeb33309c78037e374b0deee84dd441f6 ->  ../../lib64/libpthread-2.10.2.so/5c68f7afeb33309c78037e374b0deee84dd441f6*
>>
>> To find the file for that specific build-id, not the one installed in my
>> machine (or on the different machine, of a different architecture) that
>> may be completely unrelated, a new one, or one for a different arch.

> Thanks.  I believe qemu could easily act as a symbol server for this use  
> case.

Agreed, but it doesn't even have to :-)

We just need to get the build-id in the PERF_RECORD_MMAP event somehow
and then get this symbol from elsewhere, say the same DVD/RHN
channel/Debian Repository/embedded developer toolkit image not
stripped/whatever.

Or it may already be in the local cache from last week's perf report
session :-)

- Arnaldo
