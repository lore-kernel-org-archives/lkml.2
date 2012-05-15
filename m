Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966538Ab2EOTSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:18:25 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:46899 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966435Ab2EOTSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:18:24 -0400
Message-ID: <4FB2ABD0.4000104@linux.vnet.ibm.com>
Date: Wed, 16 May 2012 00:47:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 4/5] cpusets: Add provisions for distinguishing CPU
 Hotplug in suspend/resume path
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231638.3566.30867.stgit@srivatsabhat> <alpine.DEB.2.00.1205141732570.25235@chino.kir.corp.google.com> <4FB24C36.7000702@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151133450.24304@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205151133450.24304@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051509-6102-0000-0000-0000017DC04C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 12:04 AM, David Rientjes wrote:

> On Tue, 15 May 2012, Srivatsa S. Bhat wrote:
> 
>>>> Cpusets needs to distinguish between a regular CPU Hotplug operation and a
>>>> CPU Hotplug operation carried out as part of the suspend/resume sequence.
>>>> So add provisions to facilitate that, so that the two operations can be
>>>> handled differently.
>>>>
>>>
>>> There's no functional change with this patch and it's unclear from this 
>>> changelog why we need to distinguish between the two, so perhaps fold this 
>>> into patch 5 or explain how this will be helpful in this changelog?  
>>> Otherwise it doesn't seem justifiable to add 30 more lines of code.
>>
>>
>> Well, as 0/5 explains, this whole patchset is a suspend/resume-only fix.
>> So we need special-case handling for suspend/resume in cpusets. So the
>> additional code is justified, IMHO. It prepares the ground for patch 5.
>>
> 
> Your change, once merged, will not carry patch 0/5 here, so it would be 
> helpful to understand why we need to distinguish between the two as a 
> stand-alone patch in your changelog.
> 


Sorry, I didn't quite get your point. Do you just want me to update this
changelog or do you still want me to squash this patch with patch 5?

If its the former, ok, I can try (though, I really don't know what else
to add.. it already says that we need to have special case handling of
cpusets for suspend/resume.. and also says that this patch adds the
necessary provisions.. which implies I am going to use these provisions
next (in patch 5)..) Or, are you asking me to explain *why* we need to
have special case handling for suspend/resume? If that is the case, I
could probably move some bits from the changelog of patch 5 to this patch.

However, if its the latter (ie., you want me to still squash it with
patch 5), I am not quite convinced about it.. I still think doing that
will clutter patch 5 unnecessarily.

Regards,
Srivatsa S. Bhat

