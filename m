Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0ETNjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 09:39:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34736 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab0ETNjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 09:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SU35kKz+o8b4fDEbFBuK2jm1LSmY7+3s5tbRJ+EZjbE2B+fH7zygokd5ALWWG9YFGF
         oGxJHyGvVuLLeicI44o0qw4WIlkZuzLd846LbM5aRdtP8uly/RvHKShs0b6J+D5vjhic
         8Y0Ex/Qx8k9P+6pkdtrpx3OODn0GVIkh4oV1I=
MIME-Version: 1.0
In-Reply-To: <tip-cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d@git.kernel.org>
References: <1273032130.6383.28.camel@tropicana>
	 <tip-cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d@git.kernel.org>
Date: Thu, 20 May 2010 16:39:37 +0300
X-Google-Sender-Auth: tZ6w0pIWLZHGXzh2wu4JKmjw6Z4
Message-ID: <AANLkTikqkbScJOVxynoOzejKnaNIucrAczgtGIDqXLCO@mail.gmail.com>
Subject: Re: [tip:perf/core] perf: Use read() instead of lseek() in 
	trace_event_read.c:skip()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 3:54 PM, tip-bot for Tom Zanussi
<tzanussi@gmail.com> wrote:
> Commit-ID:  cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d
> Gitweb:     http://git.kernel.org/tip/cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d
> Author:     Tom Zanussi <tzanussi@gmail.com>
> AuthorDate: Tue, 4 May 2010 23:02:10 -0500
> Committer:  Frederic Weisbecker <fweisbec@gmail.com>
> CommitDate: Thu, 20 May 2010 08:37:17 +0200
>
> perf: Use read() instead of lseek() in trace_event_read.c:skip()
>
> This is a small fix for a problem affecting live-mode, introduced
> recently:
>
> root@tropicana:~# perf trace rwtop
> perf trace started with Perl
> script /root/libexec/perf-core/scripts/perl/rwtop.pl
>
>  Fatal: did not read header event
>
> commit d00a47cce569a3e660a8c9de5d57af28d6a9f0f7 added a skip()
> function to skip over e.g. header_page, but this doesn't work for
> live mode.  This patch re-implements skip() to use read() instead of
> lseek() to fix that.

Out of curiosity: why doesn't lseek() work and why can't we fix that?
