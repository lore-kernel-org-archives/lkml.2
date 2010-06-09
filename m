Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab0FITFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 15:05:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424Ab0FITFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 15:05:37 -0400
Date: Wed, 9 Jun 2010 12:04:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] floppy: cleanup patches
In-Reply-To: <20100609115403.75ebb6cb@nehalam>
Message-ID: <alpine.LFD.2.00.1006091203190.4506@i5.linux-foundation.org>
References: <20100609183449.110905403@vyatta.com> <alpine.LFD.2.00.1006091144120.4506@i5.linux-foundation.org> <20100609115403.75ebb6cb@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, Stephen Hemminger wrote:
> 
> Current plan is to convert all the timers and old BH code to go through
> a single workqueue. This avoids all the races and cleans up the cancellation
> logic as well without having lots of other changes.

That will definitely help. We still end up with the things that call the 
request queue directly as a second (nonworkqueue) thread, but I think 
that's what the floppy_lock has _traditionally_ protected against, so it 
might all work out and largely fix the locking.

			Linus
