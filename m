Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab2LJOVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:21:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2LJOVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:21:14 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=cU5zP3iA40MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wzXg5rMBBV8A:10 a=K9rc9MkwzZ3N4lOTNtoA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355149273.17101.176.camel@gandalf.local.home>
Subject: Re: [RFC PATCH] sched: rt: fix selecting runqueue for task to be
 pushed
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Dec 2012 09:21:13 -0500
In-Reply-To: <CAJd=RBCk0eWQqTk-BX8_=aBdYEQnbnf57dHZdcVbWbVY=33OhQ@mail.gmail.com>
References: <CAJd=RBCk0eWQqTk-BX8_=aBdYEQnbnf57dHZdcVbWbVY=33OhQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 20:19 +0800, Hillf Danton wrote:
> When we are trying to push task out, no point to select the last cpu that
> the given task executed on, which is fixed by selecting target cpu with
> cache affinity concerned, and with SD_WAKE_AFFINE ignored as we are not
> handling sleeper.

I have to ask. Why?

The check you are skipping is if the task is running on a CPU that is
already the lowest CPU priority (lowest_mask returns the CPUs running
tasks of the lowest priority in the system). Which means that either the
task that we are pushing is the same priority or lesser priority than
what is running on the other CPUs. Either case, this task wont push out
a task on the other CPUs because it's not higher priority than those
tasks.

You just added more work for the same result (no push).

-- Steve


