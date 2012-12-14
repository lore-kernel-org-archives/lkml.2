Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab2LNWUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:20:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22788 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab2LNWUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:20:00 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=h99SOY78h90A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=CGgBco54DJ0A:10 a=VwQbUJbxAAAA:8 a=HFXECD1-VPInmgyM84QA:9 a=PUjeQqilurYA:10 a=U62fhAwekXMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355523597.17101.407.camel@gandalf.local.home>
Subject: Re: [PATCH RT 0/2] [ANNOUNCE] 3.4.22-rt34-rc1 stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Mike Galbraith <bitbucket@online.de>
Date: Fri, 14 Dec 2012 17:19:57 -0500
In-Reply-To: <20121212004557.110050982@goodmis.org>
References: <20121212004557.110050982@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 19:45 -0500, Steven Rostedt wrote:
> Dear RT Folks,
> 
> This is the RT stable review cycle of patch 3.4.22-rt34-rc1.
> 
> Please scream at me if I messed something up. Please test the patches too.
> 
> The -rc release will be uploaded to kernel.org and will be deleted when
> the final release is out. This is just a review release (or release candidate).
> 
> The pre-releases will not be pushed to the git repository, only the
> final release is.
> 
> If all goes well, this patch will be converted to the next main release
> on 12/14/2012, let's hope it's not an unexpected journey!
> 

Sure enough I was taken on an unexpected journey today. Unfortunately it
wasn't in the theaters.

I guess there's a small bug with one of the patches, with a fix sent to
me by Mike. This needs to be in Thomas's latest before it goes into
stable.

        oldprio = p->prio;
-       if (oldprio == param->sched_priority)
+       if (oldprio == (MAX_RT_PRIO - 1) - param->sched_priority)
                goto out;


-- Steve


