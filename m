Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab1IUPt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:49:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab1IUPtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:49:55 -0400
Message-ID: <4E7A0784.1040602@redhat.com>
Date: Wed, 21 Sep 2011 18:49:24 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: percpu crash on NetBurst
References: <4E3EB013.5000001@redhat.com> <20110808095517.GH23937@htj.dyndns.org> <4E79F477.2050102@redhat.com>
In-Reply-To: <4E79F477.2050102@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2011 05:28 PM, Avi Kivity wrote:
>
> Coming back to this, the trigger if cpuid family=6 and model>=13 
> (model 12 works).  Looks like the code disables rep_good is some MSR 
> doesn't have the expected value.  While we should configure the MSR 
> correctly, it looks like the fallback code for !rep_good is broken.  
> Will look further.
>

Ok, without rep_good, memcpy() sometimes copies backwards.  A stale copy 
of memmove_64.c I had around got picked up instead of memmove_64.S; that 
memmove() used memcpy() in the copy-forward case.

So, nothing to see, sorry about the noise.

-- 
error compiling committee.c: too many arguments to function

