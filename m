Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2DRNsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:48:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12078 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2DRNsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:48:23 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=7aeNQT76kZUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=yxuVgUk4js8XhPcrgykA:9 a=o0ffq1Oe7eg0qnq70jgA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334756901.28106.38.camel@gandalf.stny.rr.com>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/mutex.c:271
From: Steven Rostedt <rostedt@goodmis.org>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Apr 2012 09:48:21 -0400
In-Reply-To: <1334756757.1269.28.camel@fujitsu-laptop>
References: <1334561244.3339.7.camel@aep-desktop>
	 <20120418025626.GB23877@home.goodmis.org>
	 <20120418040636.GD2449@linux.vnet.ibm.com>
	 <1334724679.2019.20.camel@aep-desktop>
	 <1334750926.28106.36.camel@gandalf.stny.rr.com>
	 <1334756757.1269.28.camel@fujitsu-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 19:45 +0600, Alexander E. Patrakov wrote:

> > Do you see the RT throttling message too? That's a bug with an RT task
> > going haywire. If that is happening, an RT task may be preventing an RCU
> > grace period to finish, and causing the RCU stalls.
> 
> I am currently at home, writing this from a laptop with 3.3.1, and there

Have you seen the memory leaks on your laptop?

> are no such messages in dmesg (yet?). Also I don't know any RT tasks
> that may run on my computer, except pulseaudio, which has a built-in

There are kernel threads that run at RT priorities too.

> safeguard against this. As for the work computer, should I check
> tomorrow, and with which kernel version?
> 

I'm only interested in the kernel version that happens to leak. If other
versions don't leak then we don't need to worry about them ;-)

Perhaps the problem has already been fixed in later kernels.

-- Steve


