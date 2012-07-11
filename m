Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab2GKNjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:39:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56800 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab2GKNi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:38:58 -0400
Message-ID: <1342013914.3462.157.camel@twins>
Subject: Re: [PATCH 1/6] hrtimer: Provide clock_was_set_delayed()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org
Date: Wed, 11 Jul 2012 15:38:34 +0200
In-Reply-To: <4FFD7A31.8000909@redhat.com>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
	 <1341960205-56738-2-git-send-email-johnstul@us.ibm.com>
	 <4FFD6E5A.9060206@redhat.com> <alpine.LFD.2.02.1207111425260.32033@ionos>
	 <4FFD7A31.8000909@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 09:05 -0400, Prarit Bhargava wrote:
> 
> Both of those options seem like a lot of work for something that happens once
> every 3-4 years, and may not happen ever again[1].  Based on that statement, if
> we're going to modify code I would prefer that it be as lightweight as possible.
>  So, in terms of the kernel, option 2 is likely the best way to go rather than
> introducing new code that will be used once every 3-4 years. 

Full agreed, however if we implement clock_was_set() like I just
proposed we'd use that code for every time the clock was modified, which
is a lot more often.

That said, I'm not a particular fan of it..
