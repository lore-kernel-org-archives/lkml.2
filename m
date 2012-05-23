Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786Ab2EWN0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:26:04 -0400
Received: from mail1.windriver.com ([147.11.146.13]:42540 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2EWN0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:26:01 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <asselsm@gmail.com>
Subject: Re: [PATCH v2 3/3] trace-cmd: setting plugin to 'nop' clears data before it's recorded
Date: Wed, 23 May 2012 09:26:32 -0400
Message-ID: <1838810.uYEtUK88eM@yow-masselst-d1>
Organization: Wind River Internation Inc.
User-Agent: KMail/4.8.2 (Linux/3.2.0-24-generic; KDE/4.8.2; x86_64; ; )
In-Reply-To: <1337765592.13348.143.camel@gandalf.stny.rr.com>
References: <1333715093.23090.2.camel@pippen.local.home> <1333899525-6436-1-git-send-email-mark.asselstine@windriver.com> <1337765592.13348.143.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [128.224.146.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 23, 2012 05:33:12 Steven Rostedt wrote:
> On Sun, 2012-04-08 at 11:38 -0400, Mark Asselstine wrote:
> > commit e09a5db1a929ab668c273b87c4f0a32b81e1c21a
> > [trace-cmd: Add trace-cmd record --date option]
> > 
> > moved the call to disable_all() in trace_record() from after record_data()
> > to before it. Unfortunately disable_all() sets 'nop' in 'current_tracer'
> > which has the side affect of clearing 'trace', thus all the latency tracer
> > reports are empty/useless. Here we make disable_all() optionally call
> > set_plugin() thus, where we need to, we can delay the disabling of the
> > tracer until we have had a chance to capture 'trace'. We have added this
> > delayed behavior to trace_record() to fix the latency reports, for all
> > other calls to disable_all() we continue to have set_plugin() called.
> 
> Just letting you know that I just pushed your changes to my repo. Sorry
> for being late, I got side-tracked, and forgot about your changes.
> 
> -- Steve

No problem, happy to help.

Mark
