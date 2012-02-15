Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab2BOM5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 07:57:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38475 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab2BOM5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 07:57:11 -0500
Message-ID: <1329310627.2437.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] lib/cpumask.c: Optimize __any_online_cpu() calculation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, venki@google.com, rusty@rustcorp.com.au
Date: Wed, 15 Feb 2012 13:57:07 +0100
In-Reply-To: <20120215123208.15623.73499.stgit@srivatsabhat.in.ibm.com>
References: <20120215123208.15623.73499.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 15 février 2012 à 18:05 +0530, Srivatsa S. Bhat a écrit :
> __any_online_cpu() uses a for loop at the moment.
> Instead, use cpumask_* operations to speed it up.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> Actually, the patch posted at https://lkml.org/lkml/2012/2/15/101 removed
> the last user of any_online_cpu() (and hence __any_online_cpu()).
> However, since this is an exported symbol, I refrained from removing this
> function altogether.

Just remove the export/function and eventually leave the helper ?

#define any_online_cpu(mask) cpumask_any_and(mask, cpu_online_mask)


