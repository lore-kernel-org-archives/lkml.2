Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab0FJAUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 20:20:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756177Ab0FJAUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 20:20:51 -0400
Date: Wed, 9 Jun 2010 17:20:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Salman Qazi <sqazi@google.com>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tytso@google.com
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be 
 reused immediately.
In-Reply-To: <AANLkTim56xHJM-6ZgFvEO2YetDLCnjaCoOtxYGTqtE0c@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006091719100.4506@i5.linux-foundation.org>
References: <20100609210014.7464.92234.stgit@bumblebee1.mtv.corp.google.com> <alpine.LFD.2.00.1006091408430.4506@i5.linux-foundation.org> <1276119207.1745.154.camel@laptop> <alpine.LFD.2.00.1006091517450.4506@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006091525250.4506@i5.linux-foundation.org> <AANLkTim56xHJM-6ZgFvEO2YetDLCnjaCoOtxYGTqtE0c@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, Salman Qazi wrote:
> 
> I don't think this gives the right answer in the a < base < b  case.
> Here a - base < 0 and
> b - base > 0.  But we really want b to be before a, since a has rolled
> over further than b.

Right you are.

> I think the right solution is comparing (a - base + max_pid) % max_pid 
> with (b - base + max_pid) % max_pid.  Am I correct or deluded? .

That would work, but it would be horrible. Just use the three compares 
version: doing a integer 'mod' operator is _way_ more expensive.

			Linus
