Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0ECUxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 16:53:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21657 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab0ECUxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 16:53:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=fJbPgAOXvUMEcAXdmlx/VR96LuHehCpI266zMa8rsfmmc27YEXVEhRqNJa2v2YlEh
	1OkqrmsqEKgsh8tHkwMgA==
MIME-Version: 1.0
In-Reply-To: <1272919356.1642.154.camel@laptop>
References: <20100503203813.GA17886@sharma-home.net>
	 <1272919356.1642.154.camel@laptop>
Date: Mon, 3 May 2010 13:53:19 -0700
Message-ID: <w2u850c51c31005031353x9be8ca7h90c244d64675ce3e@mail.gmail.com>
Subject: Re: [PATCH] perf: implement recording/reporting per-cpu samples
From: Arun Sharma <aruns@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 3, 2010 at 1:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, 2010-05-03 at 13:38 -0700, Arun Sharma wrote:
> > Enable PERF_SAMPLE_CPU by default. Implement --sort cpu.
>
> Why? The downside is that you unconditionally grow each sample and thus
> increase the overhead for something that doesn't make sense for the
> normal (task-inherit) case.

In a shared multi-core environment, users want to analyze why their
program was slow. In particular, if the code ran slower only on
certain CPUs due to interference from other programs or kernel
threads, they want to know that.

But that's just our use case. The patch is mostly about --sort cpu
option. If you want to drop the part that enables PERF_SAMPLE_CPU by
default, that's fine by me.

 -Arun
