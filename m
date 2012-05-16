Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2EPP01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:26:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63142 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab2EPP0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:26:25 -0400
Date: Wed, 16 May 2012 12:26:19 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Revert 'perf evlist: Fix creation of cpu map'
Message-ID: <20120516152619.GD7864@infradead.org>
References: <1337161549-9870-1-git-send-email-namhyung.kim@lge.com>
 <1337161549-9870-2-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337161549-9870-2-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 16, 2012 at 06:45:48PM +0900, Namhyung Kim escreveu:
> The commit 55261f46702c ("perf evlist: Fix creation of cpu
> map") changed to create a per-task event when no cpu target
> is specified. However it caused a problem since perf-task do
> not allow event inheritance due to scalability issues so
> that the result will contain samples only from parent, not
> from its children.
> 
> So we should use perf-task-per-cpu events anyway to get the
> right result. Revert it.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Analysed-by: Ingo Molnar <mingo@kernel.org>
> Acked-and-tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

I'm applying it, but while trying to figure out if the logic was right I
tried:

perf top -C 0 -u acme

To check what is that this user is doing on that CPU, and its not
possible :-\

UID switch overriding CPU!

- Arnaldo
