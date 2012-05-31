Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab2EaUt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:49:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57425 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab2EaUtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:49:24 -0400
Date: Thu, 31 May 2012 13:49:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: a.p.zijlstra@chello.nl
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] x86/numa: Allow specifying node_distance() 
 for numa=fake
In-Reply-To: <tip-e1136ef7kdffj7yf9tjhydln@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1205311346490.2764@chino.kir.corp.google.com>
References: <tip-e1136ef7kdffj7yf9tjhydln@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, tip-bot for Peter Zijlstra wrote:

> Commit-ID:  94c0dd3278dd3eae52eabf0fb77d472d0dd3e373
> Gitweb:     http://git.kernel.org/tip/94c0dd3278dd3eae52eabf0fb77d472d0dd3e373
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Wed, 18 Apr 2012 19:04:17 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 9 May 2012 13:28:59 +0200
> 
> x86/numa: Allow specifying node_distance() for numa=fake
> 
> Allows emulating more interesting NUMA configurations like a quad
> socket AMD Magny-Cour:
> 
>  "numa=fake=8:10,16,16,22,16,22,16,22,
>               16,10,22,16,22,16,22,16,
>               16,22,10,16,16,22,16,22,
>               22,16,16,10,22,16,22,16,
>               16,22,16,22,10,16,16,22,
>               22,16,22,16,16,10,22,16,
>               16,22,16,22,16,22,10,16,
>               22,16,22,16,22,16,16,10"
> 
> Which has a non-fully-connected topology.
> 

I like this support and I'm pretty sure you used it to reproduce my 
problems with sched/numa locally, but I think it would be better to 
seperate it out as a different parameter such as slit=fake so that we can 
still use it to fake the SLIT of our NUMA machines without requiring 
numa=fake which provides no guarantees to break the nodes along physical 
boundaries.

So without seperating it out into slit=fake, we can't change this 
information without changing the SLIT itself and that makes debugging 
harder.
