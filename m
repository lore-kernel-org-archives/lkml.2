Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994Ab1BNFcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 00:32:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:27002 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1BNFcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 00:32:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hAG6umT9lXCPzm6mi0Iv/U3P8QFb0wUPng/Qnof6vBzCBYpt8Y2qs9DKINN6ZYACKz
         7aROZER/HbUNjnL4rrKw==
MIME-Version: 1.0
In-Reply-To: <20110124130529.903d9832.akpm@linux-foundation.org>
References: <20101224082226.GA13872@ghc17.ghc.andrew.cmu.edu>
 <20101226120919.GA28529@ghc17.ghc.andrew.cmu.edu> <20101226120951.GB28529@ghc17.ghc.andrew.cmu.edu>
 <20110124130529.903d9832.akpm@linux-foundation.org>
From: Paul Menage <menage@google.com>
Date: Sun, 13 Feb 2011 21:31:42 -0800
Message-ID: <AANLkTi=7uCaixNV6z9pRMW0TfN-_ZgiRPHNG1QSZ=tE2@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] cgroups: read-write lock CLONE_THREAD forking per threadgroup
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, ebiederm@xmission.com,
        lizf@cn.fujitsu.com, matthltc@us.ibm.com, oleg@redhat.com,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 1:05 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Risky. sched.h doesn't include rwsem.h.
>
> We could make it do so, but almost every compilation unit in the kernel
> includes sched.h.  It would be nicer to make the kernel build
> finer-grained, rather than blunter-grained.  Don't be afraid to add new
> header files if that is one way of doing this!
>

The only header files included by rwsem.h that aren't directly
included in sched.h already are linux/linkage.h and asm/atomic.h.
Since sighand_struct in sched.h has an atomic_t field, sched.h is
clearly including atomic.h somewhere indirectly. And there are mutex
fields in sched.h, which means it's indirectly including
linux/mutex.h, which includes linux/linkage.h. So I think that it's
hard to argue that this change would make the kernel build any more
heavyweight.

Paul
