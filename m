Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab0FIW22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:28:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717Ab0FIW20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:28:26 -0400
Date: Wed, 9 Jun 2010 15:27:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Salman <sqazi@google.com>, akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tytso@google.com
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
In-Reply-To: <alpine.LFD.2.00.1006091517450.4506@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1006091525250.4506@i5.linux-foundation.org>
References: <20100609210014.7464.92234.stgit@bumblebee1.mtv.corp.google.com>  <alpine.LFD.2.00.1006091408430.4506@i5.linux-foundation.org> <1276119207.1745.154.camel@laptop> <alpine.LFD.2.00.1006091517450.4506@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, Linus Torvalds wrote:
> 
> Quite possibly. I'd worry about the overflow case a bit, but it's 
> certainly going to get the right value when base << MAX_INT.

Having given it a couple of seconds more thought, I don't think there is 
an overflow case either. All of a/b/base are guaranteed to be non-negative 
(or our pid code is in worse trouble anyway), so there is no overflow 
possible. So yes. Just comparing a-base < b-base should always be safe.

			Linus


