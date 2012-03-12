Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab2CLOVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:21:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28663 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab2CLOVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:21:13 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=t3ItOyjDxu0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZrfqmyCWHQPRGerRvaEA:9 a=kV4kfblsFJHMM_VbS9EA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331562071.25686.635.camel@gandalf.stny.rr.com>
Subject: Re: recent x86-64 nested NMI adjustments
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Date: Mon, 12 Mar 2012 10:21:11 -0400
In-Reply-To: <4F5E08C30200007800077ACC@nat28.tlf.novell.com>
References: <4F5DF5C30200007800077A5B@nat28.tlf.novell.com>
	 <1331558201.25686.629.camel@gandalf.stny.rr.com>
	 <4F5E08C30200007800077ACC@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 13:31 +0000, Jan Beulich wrote:

> Ah, right - the way the new check got placed I (wrongly) implied
> it to guard the immediately succeeding check of the "special
> variable", whereas it really guards (only) test_in_nmi.

The reason I placed it there was because I thought that would be the
more common case. As nested NMIs are the .00001% case, and the variable
check only can prove that we were in a nested NMI, but does not prove we
are not, in which case it would still need to do the other checks.

I figured that a good % of NMIs will interrupt userspace, and let that
be the fast path. When an NMI interrupts userspace, this check will make
it skip the rest of the checks. Seemed to be the logical placement.

But I see where the confusion came from. The placement was for
optimization of the fast path, not for where it *had* to be.


> 
> Thanks for the explanation, and sorry for the noise then.

No prob,

-- Steve


