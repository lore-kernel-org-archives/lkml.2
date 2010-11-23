Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0KWO5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:57:41 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32930 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab0KWO5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:57:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=EeygD3rkllSkOb4YEtet5/wka0FEGcD2UFsb+pJFCHG6gNJRIOO+mEjulsZIGPtqPk
         TfFjuuAFnonNiEKPk5Ls4dDxjzXLaD/AgLXGFeDdF+je1nUX/fRh4QHL8LSs82Sq1Z2t
         qHDzrAt5XDKvCFCUSJv89WZGpCSXJvolR54UA=
From: Ben Gamari <bgamari@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [RFC 1/2] deactive invalidated pages
In-Reply-To: <20101122143817.E242.A69D9226@jp.fujitsu.com>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com> <20101122143817.E242.A69D9226@jp.fujitsu.com>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Tue, 23 Nov 2010 09:57:35 -0500
Message-ID: <87hbf89jfk.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 16:16:55 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > By Other approach, app developer uses POSIX_FADV_DONTNEED.
> > But it has a problem. If kernel meets page is writing
> > during invalidate_mapping_pages, it can't work.
> > It is very hard for application programmer to use it.
> > Because they always have to sync data before calling
> > fadivse(..POSIX_FADV_DONTNEED) to make sure the pages could
> > be discardable. At last, they can't use deferred write of kernel
> > so that they could see performance loss.
> > (http://insights.oetiker.ch/linux/fadvise.html)
> 
> If rsync use the above url patch, we don't need your patch. 
> fdatasync() + POSIX_FADV_DONTNEED should work fine.
> 
This is quite true, but the patch itself is fairly invasive and
unnecessarily so which makes it unsuitable for merging in the eyes of
the rsync maintainers (not that I can blame them). This is by no fault
of its author; using fadvise is just far harder than it should be.

- Ben
