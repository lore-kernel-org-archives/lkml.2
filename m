Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2JQRZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:25:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378Ab2JQRZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:25:30 -0400
Date: Wed, 17 Oct 2012 19:02:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/9] uprobes: check for single step support
Message-ID: <20121017170211.GA10864@redhat.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-2-git-send-email-rabin@rab.in> <20121017164059.GF11096@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017164059.GF11096@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Srikar Dronamraju wrote:
>
> * Rabin Vincent <rabin@rab.in> [2012-10-14 21:23:06]:
>
> >  void __weak arch_uprobe_enable_step(struct arch_uprobe *arch)
> >  {
> > -	user_enable_single_step(current);
> > +	if (arch_has_single_step())
> > +		user_enable_single_step(current);
> >  }
> >
> >  void __weak arch_uprobe_disable_step(struct arch_uprobe *arch)
>
> This change is fine. But I am wondering if should have a dummy
> arch_uprobe_enable_step / arch_uprobe_disable_step in uprobes ARM.

Or, better, we can kill it. We wertr going to do this anyway, we were
waiting for powerpc port.

Just I do not know how this change should be routed, it should update
both x86/powerpc.

Or do you think arch_uprobe_enable_step() still makes any sense?

Oleg.

