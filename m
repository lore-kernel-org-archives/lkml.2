Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358Ab2D0Tnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:43:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2D0Tnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:43:39 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=szhx8aRwONgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=w2ANHE06Qvblrdc58fcA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335555817.28106.232.camel@gandalf.stny.rr.com>
Subject: Re: RFC: How to handle function tracing, frame pointers and
 -mfentry?
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 27 Apr 2012 15:43:37 -0400
In-Reply-To: <1335552399.28106.228.camel@gandalf.stny.rr.com>
References: <1335552399.28106.228.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 14:46 -0400, Steven Rostedt wrote:

> Currently, function tracing selects CONFIG_FRAME_POINTER for various
> archs (including x86), as the kernel will not compile without it, if
> function tracing is enabled. But if -mfentry is available with the
> compiler, it does not have this dependency. The kernel will compile fine
> with -pg -mfentry and without frame pointers.

Just to show the difference. I ran several iterations of hackbench, on
an Intel Quad Core2 2.6GHz.

Here's the fentry code with frame pointers (tracing disabled):

Time: 2.006
Time: 2.028
Time: 2.028
Time: 1.999
Time: 2.035
Time: 2.037
Time: 2.006
Time: 1.996
Time: 2.049
Time: 1.991
Time: 2.038
Time: 2.047
Time: 2.039
Time: 2.000
Time: 2.021
Time: 2.011
Time: 2.007
Time: 2.024
Time: 2.033
Time: 2.027
Time: 2.044


And the fentry code with frame pointers disabled:

Time: 1.870
Time: 1.861
Time: 1.865
Time: 1.884
Time: 1.867
Time: 1.867
Time: 1.875
Time: 1.883
Time: 1.863
Time: 1.877
Time: 1.865
Time: 1.885
Time: 1.842
Time: 1.863
Time: 1.899
Time: 1.877
Time: 1.837
Time: 1.900
Time: 1.897
Time: 1.877
Time: 1.853
Time: 1.856

That's about a 8% difference.

-- Steve


