Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761223Ab2COLA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:00:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52465 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab2COLAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:00:55 -0400
Message-ID: <1331809239.18960.168.camel@twins>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Ingo Molnar <mingo@elte.hu>
Date: Thu, 15 Mar 2012 12:00:39 +0100
In-Reply-To: <20120315014511.GT27051@google.com>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
	 <20120314161906.e53359d3.akpm@linux-foundation.org>
	 <20120315014511.GT27051@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 18:45 -0700, Mandeep Singh Baines wrote:
> You could make MAX_RT_PRIO greater than MAX_USER_RT_PRIO but that
> might
> have some impact on real-time applications. A simple one-line patch:
> 
> - #define MAX_RT_PRIO           MAX_USER_RT_PRIO
> + #define MAX_RT_PRIO           (MAX_USER_RT_PRIO + 1)
> 
> would prevent user-space from causing a false lockup detection.

We're so not going to muck with the fifo priorities just for this stupid
soft watchdog,.. I already hate that I can't disable the piece of crap,
making it more involved is just really not going to happen.


