Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab2DYLVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:21:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4058 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2DYLVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:21:30 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=JDJYmsdrB9oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=D19gQVrFAAAA:8 a=VWNU7kziUu7agan38w0A:9 a=XvKj7Reh6U1hXl1KudkA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335352889.28106.157.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/4] ftrace: Remove unused code ftrace related code
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 25 Apr 2012 07:21:29 -0400
In-Reply-To: <1335342219-2782-2-git-send-email-jolsa@redhat.com>
References: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
	 <1335342219-2782-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 10:23 +0200, Jiri Olsa wrote:
> Removing unused functions:
>   ftrace_rec_iter_record
>   ftrace_rec_iter_next
>   ftrace_rec_iter_start
>   ftrace_location

No, no, no!!

These are used in the core infrastructure of removing stop machine from
ftrace.

Correct, no one currently uses them, but that's because they were needed
for the arch dependent code. I have patches for both PPC and x86 to
remove stop machine, and I want the PPC changes to go through the PPC
tree.

I pushed the changes for the core infrastructure so that we don't have
dependencies between different archs.

Please read: commit c88fd8634ea68e74c7d19fd2621b4078fd22864c

If you remove these you would break:

 https://lkml.org/lkml/2012/4/23/620

Big NACK!

-- Steve



