Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1C1Rty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:49:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:38106 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1C1Rtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:49:53 -0400
Date: Mon, 28 Mar 2011 19:49:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@MIT.EDU>
cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 3/6] x86-64: Put vsyscall_gtod_data at a fixed virtual
 address
In-Reply-To: <4fef5b568241665e1d2bca64f73a437bafb574c4.1301324270.git.luto@mit.edu>
Message-ID: <alpine.LFD.2.00.1103281947320.2774@localhost6.localdomain6>
References: <cover.1301324270.git.luto@mit.edu> <4fef5b568241665e1d2bca64f73a437bafb574c4.1301324270.git.luto@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011, Andy Lutomirski wrote:
>  
> +	 /* This address must be kept in sync with arch/x86/vdso/vextern.h */

This is the worst idea ever. Breakage is lurking by making something:
Must be kept in sync ...

> +	.vsyscall_gtod_data ADDR(.vsyscall_0) + 3072 + 256:

And this magic constant is what ? Something which will blow up sooner
than later.

NAK.

Thanks,

	tglx
