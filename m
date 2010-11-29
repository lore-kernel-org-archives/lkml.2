Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab0K2Ji7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:38:59 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36455 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0K2Ji5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:38:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DbSpc6DfWsKmd3Rh5jxYAhLTQnjLIUM7ABMpJHrv+3BCOJs2R4scVMOIjA/IAR0ZlC
         SpBWr3KKNxuUf4ljVasbJ3bzINqvHYNnsBAogkOadJ9Kxtzj4OHkbrSozef4XUFeQ7YS
         oW6gJEVX5dIyAbwRvY5i1W8rVjPW9jeYrO6jc=
Subject: Re: [PATCH] kthread: NUMA aware kthread_create_on_cpu()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20101129090510.GA15763@basil.fritz.box>
References: <1290972833.29196.90.camel@edumazet-laptop>
	 <20101128224024.GA12300@basil.fritz.box>
	 <1290984712.29196.100.camel@edumazet-laptop>
	 <20101128230146.GB12300@basil.fritz.box>
	 <1290987424.29196.128.camel@edumazet-laptop>
	 <20101129090510.GA15763@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 10:38:52 +0100
Message-ID: <1291023532.3435.29.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 novembre 2010 à 10:05 +0100, Andi Kleen a écrit :
> On Mon, Nov 29, 2010 at 12:37:04AM +0100, Eric Dumazet wrote:

> > Hmm, I meant stack (the thing that might be trashed a lot in ksoftirqd),
> > so it is included in struct thread_info
> 
> task_struct is quite hot too. Also your original mail said
> task struct i believe.
> 
> > And got correct stacks. Are you sure we must use PREFERRED ?
> 
> Yes.

I'll respin a patch not using mempolicy but direct node, for both
thread_info and task_struct allocations.





