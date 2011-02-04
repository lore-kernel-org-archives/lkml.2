Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab1BDRcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:32:23 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59517 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1BDRcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:32:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CwZ+06FuRhw5LiBwsHHBOHXl5FnaZnADoI1e+pQNWjnyNCWzqKXYFOUwaMaV1WQfQI
         PimfUgMYRP90jXlTNKQnWUmRTZH91XXBJ4pYA0Ruv3DWCMoCwz6Ujox3Fz39MTW2rBcT
         LpAq+q/oXGvbkqp77UjKzlJDLd50lfQF8Zs5w=
Message-ID: <4D4C3821.5090403@gmail.com>
Date: Fri, 04 Feb 2011 20:32:17 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, George Spelvin <linux@horizon.com>,
        Meelis Roos <mroos@linux.ee>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test
References: <AANLkTin5gCnhVos3Lu_0GZSxFQmvsNEYTO=Jq7UdmYb1@mail.gmail.com> <20110204165944.GB21209@redhat.com>
In-Reply-To: <20110204165944.GB21209@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 07:59 PM, Don Zickus wrote:
> On Fri, Feb 04, 2011 at 03:17:28PM +0300, Cyrill Gorcunov wrote:
>> Please apply it, sorry for non-inlined patch (have a web access only at moment).
>>
>> Note that I've tested the patch on non-HT machine so if someone have HT'ed one
>> -- it would be great to test the patch there.
> 
> Hmm. For some reason, when I enable the kgdb testsuite, the box fails to
> boot with hardlockup issues.  It seems like the code is swallowing the
> NMIs? I basically applied this patch on top of 2.6.38-rc3 and ran it on my
> Xeon box (p4 w/HT).
> 
> Cheers,
> Don

  Interesting, seems old kgdb issue got back. The former unknown nmi problem
is due to commit 047a3772feaae8e43d81d790f3d3f80dae8ae676 which assumed that
counter stays zero when unflagged overflow happened, but it seems this is not
what happens on hw level. I noted that at moment of nmi the counter reached
some positive value so the new patch simply checks for negative bit being set.

  I must admit I forgot to test with kgdb testsuite at bootup time and I'll
be able to test this at monday in best case. I'll try to figure out what might
happen by code reading for a while (the only idea comes is that nmi from kgdb
get slipped with one issued by a perf).

-- 
    Cyrill
