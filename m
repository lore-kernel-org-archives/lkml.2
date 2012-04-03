Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2DCTVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 15:21:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45789 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894Ab2DCTVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 15:21:45 -0400
X-Sasl-enc: bPCqEN1O7WynmBEuvku1wE3Vv8s1fh+gNPzOa3Hmv9+A 1333480904
Message-ID: <1333480873.10230.35.camel@lenny>
Subject: Re: [PATCH] nextfd(2)
From: Colin Walters <walters@verbum.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Tue, 03 Apr 2012 15:21:13 -0400
In-Reply-To: <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com>
References: <20120401125741.GA7484@p183.telecom.by>
	 <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 16:17 -0700, KOSAKI Motohiro wrote:

> we can only call async-signal-safe functions after fork() when multi threads and
> opendir() call malloc() internally.
> 
> As far as I know, OpenJDK has a such fork-readdir-exec code and it can
> make deadlock
> when spawnning a new process. Unfortunately Java language perfeter to
> make a lot of threads rather than other language.
> 
> This patch can solve such multi threaded case.
> 
> offtopic, glibc malloc is a slightly clever. It reinitialize its
> internal lock when fork by
> using thread_atfork() hook. It mean glibc malloc can be used after
> fork() and the
> technique can avoid this issue. 

Yeah, a *lot* of code out there depends on this glibc malloc
implementation detail.  We uncovered our dependency on this in
GNOME a while back while investigating getenv/setenv/fork and threads:
https://bugzilla.gnome.org/show_bug.cgi?id=659326


