Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0IIUmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 16:42:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab0IIUmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 16:42:32 -0400
Date: Thu, 9 Sep 2010 22:39:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Roland McGrath <roland@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] exec: don't turn PF_KTHREAD off when command not found
Message-ID: <20100909203920.GA3057@redhat.com>
References: <20100909180236.C94C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100909180236.C94C.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09, KOSAKI Motohiro wrote:
>
> I guess this is only theorical issue because now any kthread don't
> call do_execve() directly.

Yes, I think that kthread should always exit if exec fails.
Otherwise we can "trust" the thread, just suppose that exec fails
after exec_mmap() succeeds.

But,

> but anyway fixing would be better.

Agreed. It looks better if we clear PF_KTHREAD after the point-of-no-return,
and the patch saves one ->flags modification.

Oleg.

