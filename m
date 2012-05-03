Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2ECBzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 21:55:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8040 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab2ECBzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 21:55:20 -0400
X-Authority-Analysis: v=2.0 cv=T/EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=YECtLpki0LgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=1XWaLZrsAAAA:8 a=gpJcohBzxz6gcBSezk8A:9 a=_z5puC9tsxdNz0z75EcA:7 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336010118.14207.75.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v6 1/3] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Date: Wed, 02 May 2012 21:55:18 -0400
In-Reply-To: <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
References: <1328212844-11889-2-git-send-email-vnagarnaik@google.com>
	 <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 14:18 -0700, Vaibhav Nagarnaik wrote:
> This patch adds the capability to remove pages from a ring buffer
> without destroying any existing data in it.
> 
> This is done by removing the pages after the tail page. This makes sure
> that first all the empty pages in the ring buffer are removed. If the
> head page is one in the list of pages to be removed, then the page after
> the removed ones is made the head page. This removes the oldest data
> from the ring buffer and keeps the latest data around to be read.
> 
> To do this in a non-racey manner, tracing is stopped for a very short
> time while the pages to be removed are identified and unlinked from the
> ring buffer. The pages are freed after the tracing is restarted to
> minimize the time needed to stop tracing.
> 
> The context in which the pages from the per-cpu ring buffer are removed
> runs on the respective CPU. This minimizes the events not traced to only
> NMI trace contexts.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>

Hmm, something in this patch breaks buffers_size_kb and friends.

-- Steve


