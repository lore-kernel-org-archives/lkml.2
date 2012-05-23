Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab2EWJdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:33:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2EWJdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:33:13 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Nj6rVgaf4WgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=vfm2v0D5heuxT9GPvB0A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337765592.13348.143.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v2 3/3] trace-cmd: setting plugin to 'nop' clears data
 before it's recorded
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Asselstine <mark.asselstine@windriver.com>
Cc: linux-kernel@vger.kernel.org, asselsm@gmail.com
Date: Wed, 23 May 2012 05:33:12 -0400
In-Reply-To: <1333899525-6436-1-git-send-email-mark.asselstine@windriver.com>
References: <1333715093.23090.2.camel@pippen.local.home>
	 <1333899525-6436-1-git-send-email-mark.asselstine@windriver.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-08 at 11:38 -0400, Mark Asselstine wrote:
> commit e09a5db1a929ab668c273b87c4f0a32b81e1c21a
> [trace-cmd: Add trace-cmd record --date option]
> 
> moved the call to disable_all() in trace_record() from after record_data()
> to before it. Unfortunately disable_all() sets 'nop' in 'current_tracer'
> which has the side affect of clearing 'trace', thus all the latency tracer
> reports are empty/useless. Here we make disable_all() optionally call
> set_plugin() thus, where we need to, we can delay the disabling of the tracer
> until we have had a chance to capture 'trace'. We have added this delayed
> behavior to trace_record() to fix the latency reports, for all other calls to
> disable_all() we continue to have set_plugin() called.
> 

Just letting you know that I just pushed your changes to my repo. Sorry
for being late, I got side-tracked, and forgot about your changes.

-- Steve


