Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0KKXV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:21:57 -0500
Received: from smtp-out.google.com ([74.125.121.35]:19274 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab0KKXV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:21:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=rU2wfcXWRhGKYlDykBLtZWernc189RAkcm3jIxxHRXFWs89vIUzZVEQD2r/6ca5yxh
         NeZI/E3VaPjMKEOUmv+w==
Date: Thu, 11 Nov 2010 15:21:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bodo Eggert <7eggert@gmx.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org
Subject: Re: [PATCH] oom: create a resource limit for oom_adj
In-Reply-To: <E1PGgMk-0001AW-OD@be1.7eggert.dyndns.org>
Message-ID: <alpine.DEB.2.00.1011111519330.3775@chino.kir.corp.google.com>
References: <fNx73-1cI-1@gated-at.bofh.it> <fNzVf-5UY-3@gated-at.bofh.it> <fNKdY-6FU-11@gated-at.bofh.it> <fNMps-1S1-21@gated-at.bofh.it> <E1PGgMk-0001AW-OD@be1.7eggert.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010, Bodo Eggert wrote:

> The original oom_adj design would e.g. adjust all background tabs to seem
> twice as bad as the current tab, so a ever-growing current tab would
> only be able to get one or two tabs killed in the worst case:
> 
> System is near OOM while the current tab starts using a normal amount of
> mem and grows beyond limits. After it easily killed the first bg tab by
> allocating one byte, it needs to grow to twice the normal tab memsize to
> start the OOM killer again. By then, it's score will be equal to normal
> background tabs (half size, double score), and killing the second tab will
> be luck. Killing the third tab should be impossible.
> 
> (If you adjust the bg tabs to be four times as killable, you'll get what
>  you asked for.)
> 
> 
> I don't know the current oom_score_adj, it should be able to do something
> similar? Or should there be a oom_score_mul?
> 

oom_score_adj is done on a linear scale instead of exponential so instead 
of increasing oom_adj by 1 for each hop to the current tab, you would need 
to double it.
