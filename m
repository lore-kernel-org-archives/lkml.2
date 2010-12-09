Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab0LIV2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:28:43 -0500
Received: from www.tglx.de ([62.245.132.106]:38793 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab0LIV2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:28:41 -0500
Date: Thu, 9 Dec 2010 22:28:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, eric.dumazet@gmail.com, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org
Subject: Re: [PATCH 07/16] x86: Remove custom apic->cpu_to_logical_apicid()
 implementations
In-Reply-To: <1290871325-3055-8-git-send-email-tj@kernel.org>
Message-ID: <alpine.LFD.2.00.1012092217000.2653@localhost6.localdomain6>
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-8-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Nov 2010, Tejun Heo wrote:

> After the previous patch, apic->cpu_to_logical_apicid() is no longer
> used.  The callback will be repurposed.  Remove all the custom

That's a very bad idea. You remove the callbacks from the esoteric
platforms, but you keep the other implementation in the tree.

It's not longer used now, so remove all incarnations and get rid of
all those useless = NULL initializations at the same time. Then
implement a new callback with a different name.

It's slightly more work and code churn, but it makes the change
entirely clear. It'd be also nice to annotate in the function name
that this is 32bit only or even make it 32bit dependent if it's not
too much ifdeffery

Thanks,

	tglx

