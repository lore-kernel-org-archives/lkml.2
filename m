Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab0FOShT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:37:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab0FOShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:37:17 -0400
Date: Tue, 15 Jun 2010 20:35:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Salman <sqazi@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org,
       tytso@google.com, torvalds@linux-foundation.org, walken@google.com
Subject: [PATCH 0/1] (Was: Fix a race in pid generation that causes pids to
	be reused immediately.)
Message-ID: <20100615183525.GA24577@redhat.com>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com> <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11, Salman wrote:
>
> A program that repeatedly forks and waits is susceptible to having the
> same pid repeated,

I agree this patch should fix this.

But the kernel still can use the same pid twice in a row, I am wondering
if there a simple solution to prevent this. Probably not, and this case
is unlikely.

While we are here, and given that many reviewers recently inspected
alloc_pidmap(), probably someone can explain the mysterious checks
in do/while loop ?

See the patch I am going to send, it is on top on Salman's fix but doesn't
really depend on it.

Oleg.

