Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900Ab1KCQIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:08:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933739Ab1KCQI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:08:29 -0400
X-Authority-Analysis: v=1.1 cv=QqHiGEe6yGvmA2Hj/+B5Qdh2oWFRI3gWtdRZxD5t9t4= c=1 sm=0 a=d1TCUqu53CkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=t_RlXeAodc28f-E5Jy0A:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320336507.27370.18.camel@gandalf.stny.rr.com>
Subject: Re: function_graph selftest fails with !DYNAMIC
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 03 Nov 2011 12:08:27 -0400
In-Reply-To: <20111102150255.GA6973@debian>
References: <20111102150255.GA6973@debian>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 20:32 +0530, Rabin Vincent wrote:
> The function_graph selftest fails when CONFIG_DYNAMIC_FTRACE is not set
> (tested on x86-64) on current kernels:
> 
> [    0.300124] Testing tracer function: PASSED
> [    0.446092] Testing tracer function_graph: .. no entries found ..FAILED!
> 
> Bisecting goes back to this commit:
> 
> 2b499381bc50ede01b3d8eab164ca2fad00655f0 is the first bad commit
> commit 2b499381bc50ede01b3d8eab164ca2fad00655f0

Interesting, I get the same bug at HEAD, but when I checked out this
commit, it works.

Maybe I'll kick off a bisect and see where it lands up.

Thanks,

-- Steve

> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue May 3 22:49:52 2011 -0400
> 
>     ftrace: Have global_ops store the functions that are to be traced
>     
>     This is a step towards each ops structure defining its own set
>     of functions to trace. As the current code with pid's and such
>     are specific to the global_ops, it is restructured to be used
>     with the global ops.
>     
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


