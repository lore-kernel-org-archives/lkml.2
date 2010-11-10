Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0KJMVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 07:21:24 -0500
Received: from www.tglx.de ([62.245.132.106]:47005 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab0KJMVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 07:21:22 -0500
Date: Wed, 10 Nov 2010 13:20:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH V2] futex: fix compiler warnings in exit_robust_list
In-Reply-To: <1288897200-13008-1-git-send-email-dvhart@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1011101313280.2900@localhost6.localdomain6>
References: <20101104104912.GA27033@pengutronix.de> <1288897200-13008-1-git-send-email-dvhart@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010, Darren Hart wrote:

> The following commit introduced a compiler warning:
> 
> Commit 1dcc41bb037533839753df983d31778b30b67d93
> futex: Change 3rd arg of fetch_robust_entry() to unsigned int*

This makes not really sense. That commit changed "int *pi" to
"unsigned int *pi" which did not introduce the warning by any
means. It's gcc being stupid, in fact it should have warned before
that change already.

And your patch is incomplete as it forgot to fix the same problem in
futex_compat.c

/me fixes
