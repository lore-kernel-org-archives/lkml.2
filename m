Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab2BOGDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 01:03:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57903 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2BOGDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 01:03:10 -0500
Message-ID: <1329285786.2555.38.camel@edumazet-laptop>
Subject: Re: [PATCH v1] percpu: use raw_local_irq_* in _this_cpu op
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Date: Wed, 15 Feb 2012 07:03:06 +0100
In-Reply-To: <CACVXFVN7ye6QkJLWSTecy24FeHY6SRB6cDLAXyrPF7kBKgvq5g@mail.gmail.com>
References: <1329280586-6878-1-git-send-email-tom.leiming@gmail.com>
	 <1329281947.2555.26.camel@edumazet-laptop>
	 <CACVXFVN7ye6QkJLWSTecy24FeHY6SRB6cDLAXyrPF7kBKgvq5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 15 février 2012 à 13:08 +0800, Ming Lei a écrit :

> Just several warnings, no errors. Also the 5 warnings are introduced
> by previous commit, sounds nothing to do with motivation of this patch.
> You may prepare a standalone patch to fix all the code style in this file, :-)
> 

Oh well, I dont use checkpatch but spoke about trailing \

Cant you see them on your screen ?

We had :

#define _this_cpu_generic_to_op(pcp, val, op)				\
do {									\
	unsigned long flags;						\
	local_irq_save(flags);						\
	*__this_cpu_ptr(&(pcp)) op val;					\
	local_irq_restore(flags);					\
} while (0)


You want :

#define _this_cpu_generic_to_op(pcp, val, op)				\
do {									\
	unsigned long flags;						\
	raw_local_irq_save(flags);						\
	*__this_cpu_ptr(&(pcp)) op val;					\
	raw_local_irq_restore(flags);					\
} while (0)


I suggest :

#define _this_cpu_generic_to_op(pcp, val, op)				\
do {									\
	unsigned long flags;						\
	raw_local_irq_save(flags);					\
	*__this_cpu_ptr(&(pcp)) op val;					\
	raw_local_irq_restore(flags);					\
} while (0)


Is it clear now ?



