Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab2ECHYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:24:48 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65422 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641Ab2ECHYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:24:47 -0400
Date: Thu, 3 May 2012 10:24:42 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Minchan Kim <minchan@kernel.org>
cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
Subject: Re: vmevent: question?
In-Reply-To: <4F9E4F0A.8030900@kernel.org>
Message-ID: <alpine.LFD.2.02.1205031019410.3686@tux.localdomain>
References: <4F9E39F1.5030600@kernel.org> <CAOJsxLE3A3b5HSrRm0NVCBmzv7AAs-RWEiZC1BL=se309+=WTA@mail.gmail.com> <4F9E44AD.8020701@kernel.org> <CAOJsxLGd_-ZSxpY2sL8XqyiYxpnmYDJJ+Hfx-zi1Ty=-1igcLA@mail.gmail.com> <4F9E4F0A.8030900@kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012, Minchan Kim wrote:
> > What kind of consistency guarantees do you mean? The data sent to
> > userspace is always a snapshot of the state and therefore can be stale
> > by the time it reaches userspace.
> 
> Consistency between component of snapshot.
> let's assume following as
> 
> 1. User expect some events's value would be minus when event he expect happen.
>    A : -3, B : -4, C : -5, D : -6
> 2. Logically, it's not possible to mix plus and minus values for the events.
>    A : -3, B : -4, C : -5, D : -6 ( O )
>    A : -3, B : -4, C : 1, D : 2   ( X )
>    
> But in current implementation, some of those could be minus and some of those could be plus.
> Which event could user believe?
> At least, we need a _captured_ value when event triggered so that user can ignore other values.

Sorry, I still don't quite understand the problem.

The current implementation provides the same kind of snapshot consistency 
as reading from /proc/vmstat does (modulo the fact that we read them 
twice) for the values we support.

			Pekka
