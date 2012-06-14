Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2FNOHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:07:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:57299 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab2FNOHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:07:53 -0400
Date: Thu, 14 Jun 2012 16:07:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: tony.luck@intel.com, borislav.petkov@amd.com, x86@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmp patch to fix hotplug issue in CMCI storm
In-Reply-To: <1339681786-8418-1-git-send-email-gong.chen@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1206141554290.3086@ionos>
References: <alpine.LFD.2.02.1206080940360.3086@ionos> <1339681786-8418-1-git-send-email-gong.chen@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Chen Gong wrote:
> this patch is based on tip tree and previous 5 patches.

You really don't need all this complexity to handle that. The main
thing is that you clear the storm state and adjust the storm counter
when the cpu goes offline (in case the state is ACTIVE).

When it comes online again then you can simply let it restart cmci. If
the storm on this cpu (or node) still exists then it will notice and
everything falls in place.

Keep it simple, really!

Thanks,

	tglx
