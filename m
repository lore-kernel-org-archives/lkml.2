Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab2EILwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 07:52:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:35285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab2EILwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 07:52:19 -0400
Message-ID: <1336564330.2527.23.camel@twins>
Subject: Re: [PATCH] sched_groups are expected to be circular linked list,
 make it so right after allocation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com
Date: Wed, 09 May 2012 13:52:10 +0200
In-Reply-To: <4FAA588B.5010404@redhat.com>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
	 <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 13:44 +0200, Igor Mammedov wrote:
> This patch fixes only build_sched_groups path, but there is another fail path
> that results in below OOPS.
> build_overlap_sched_groups() may exit without setting groups and later it will crash
> init_sched_groups_power as well.

if that allocation fails? Or is there another fail path?

>  But I just don't know how to fix it, so I've just
> posted partial fix that reduces crash frequency. 


> And I have to admit that
> cpu_active_mask and siblings map are busted but we either should not exit from builder
> funcs with NULL group or BUG there if it is impossible to come-up with sane group
> for insane domain span. 

I'm perfectly OK with taking the machine down, provided we can output
useful messages as to what is broken first..
