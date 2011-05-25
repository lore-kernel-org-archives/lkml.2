Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab1EYISn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:18:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:36462 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab1EYISl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:18:41 -0400
Date: Wed, 25 May 2011 10:18:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Milton Miller <miltonm@bga.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] irq: radix_tree_insert can fail
In-Reply-To: <radix-insert-can-fail@mdm.bga.com>
Message-ID: <alpine.LFD.2.02.1105251017460.3078@ionos>
References: <generic-irq-changes@mdm.bga.com> <radix-insert-can-fail@mdm.bga.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Milton Miller wrote:

> Check the insert, and if it fails cleanup and free all partial work.
> 
> Sparse irq was not checking the return code from radix_tree_insert,
> but it may need to allocate memory and can fail.  If it failed,
> it still claimed success to the caller but the affected irq(s) are
> unavailable and the reference to the affected descriptors is leaked.
> 
> Signed-off-by: Milton Miller <miltonm@bga.com>
> ---
> I started by tring to change free_desc to take the descriptor pointer
> and pushing that down, but that soon ran into conflicts between the
> array and sparse implementations, and/or the old dynamic irq cleanup
> function that is still used by some architectures.  This version is
> targeted, and also protects against scribbles to irq_data.irq.

The simpler solution is to move irq_insert_desc() into alloc_desc()
and deal with the error case there.

Thanks,

	tglx
