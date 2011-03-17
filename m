Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1CQSai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:30:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46724 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab1CQSae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:30:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DVV1b5gtHsmc4uAqPz1QirSrZwArS6gkGSsxfejYnZ0B4zDoo9KQMk4wklPg2cfuB1
         9LqF5U2CawKrRJrEaU7gLJ/dM1/p9pKV8YEWo4CnOBUzQ0zBmG6OyCxsHhbmRa/PyNyO
         bjEs6jLYfxFkVM+8CtmlRQ50v/PkCr5s8lj8E=
Subject: Re: Poll about irqsafe_cpu_add and others
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1103171245430.16620@router.home>
References: <1300371834.6315.93.camel@edumazet-laptop>
	 <20110317.081420.71114992.davem@davemloft.net>
	 <alpine.DEB.2.00.1103171016270.12540@router.home>
	 <1300380801.6315.306.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1103171245430.16620@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 19:29:29 +0100
Message-ID: <1300386569.6315.404.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 mars 2011 à 12:46 -0500, Christoph Lameter a écrit :
> On Thu, 17 Mar 2011, Eric Dumazet wrote:
> 
> > When we know we run from BH context, we can use __this_cpu_inc(), but if
> > we dont know or run from user/process context, we would need irqsafe_inc
> > variant.
> 
> If the BH context is the only one where we care about performance then its
> ok I would think.

Hmm... yes.

By the way, I noticed :

DECLARE_PER_CPU(u64, xt_u64);
__this_cpu_add(xt_u64, 2) translates to following x86_32 code :

	mov	$xt_u64,%eax
	add	%fs:0x0,%eax
	addl	$0x2,(%eax)
	adcl	$0x0,0x4(%eax)


I wonder why we dont use :

	addl	$0x2,%fs:xt_u64
	addcl	$0x0,%fs:xt_u64+4



