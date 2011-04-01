Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab1DANtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:49:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59128 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab1DANtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:49:24 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=lhBBPvcAZnUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=dfkWLsp_ea4wK32n42kA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH] Trace: use unsigned long long in trace print frames
From: Steven Rostedt <rostedt@goodmis.org>
To: liubo <liubo2009@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
In-Reply-To: <4D9573DB.4010009@cn.fujitsu.com>
References: <4D9573DB.4010009@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Apr 2011 09:49:22 -0400
Message-ID: <1301665762.2160.22.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 14:42 +0800, liubo wrote:
> While adding tracepoint for btrfs, I got a problem:
> 
> btrfs uses some macros with "ULL" type, but tracepoint's macros,
> __print_[flags,symbols](), only have "unsigned long", so on 32bit box
> there will be 64->32 truncate WARNINGs when compiling.
> 
> Here I'm inclined to make the replacement to clear those WARNINGs.

Hmm, I don't like this. unsigned long is a natural word for
architectures, I don't want to have 32 bit suffer because one user is
doing something with ULL.

A better solution is to add a trace_print_flags_u64 or something, that
can be used for cases that u64 is needed. For archs were sizeof(long) ==
sizeof(u64) we can have the two macros/structs be the same.

-- Steve


