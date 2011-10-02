Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1JBOFW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:05:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab1JBOFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:05:18 -0400
Message-ID: <4E886F77.9000909@redhat.com>
Date: Sun, 02 Oct 2011 16:04:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V6][PATCH 4/6] x86, nmi:  add in logic to handle multiple events
 and unknown NMIs
References: <1316805435-14832-1-git-send-email-dzickus@redhat.com> <1316805435-14832-5-git-send-email-dzickus@redhat.com> <20110928103140.GD6063@erda.amd.com> <20110928123720.GL5795@redhat.com> <4E8837D4.5040607@redhat.com> <20111002134802.GH7761@one.firstfloor.org>
In-Reply-To: <20111002134802.GH7761@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2011 03:48 PM, Andi Kleen wrote:
> >  Second, I wanted to use NMIs as a way of waking up a vcpu sleeping with
> >  interrupts disabled (in the context of Jeremy's paravirt spinlock
> >  patches).  Looks like we'll have to use paravirtualization for that.
>
> Just use a mode of perf that doesn't use NMIs.
> Interrupt off profiling is rarely needed if at all on modern kernels.

I tend to agree.   But that's not my call.

(note 'perf kvm' will need adjustment if we make that change - likely 
need to capture the interrupt during vmexit and dispatch it manually; 
not sure if it's workable for svm at all)

-- 
error compiling committee.c: too many arguments to function

