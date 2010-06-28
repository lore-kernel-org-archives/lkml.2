Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0F1Bhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 21:37:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57074 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab0F1Bhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 21:37:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: zone_reclaim don't call disable_swap_token()
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTikm9fXmGoE1phY7vgQcMsS9_FVAvPHgtt1hnvTV@mail.gmail.com>
References: <20100625173002.8052.A69D9226@jp.fujitsu.com> <AANLkTikm9fXmGoE1phY7vgQcMsS9_FVAvPHgtt1hnvTV@mail.gmail.com>
Message-Id: <20100628103508.3870.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 28 Jun 2010 10:37:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jun 25, 2010 at 5:31 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Swap token don't works when zone reclaim is enabled since it was born.
> > Because __zone_reclaim() always call disable_swap_token()
> > unconditionally.
> >
> > This kill swap token feature completely. As far as I know, nobody want
> > to that. Remove it.
> >
> 
> In f7b7fd8f3ebbb, Rik added disable_swap_token.
> At that time, sc.priority in zone_reclaim is zero so it does make sense.
> But in a92f71263a, Christoph changed the priority to begin from
> ZONE_RECLAIM_PRIORITY with remained disable_swap_token. It doesn't
> make sense.
> 
> So doesn't we add disable_swap_token following as than removing?

f7b7fd8f3ebbb says disable_swap_token was introduced to prevent OOM.
but zone reclaim failure don't make OOM. instead, fallback to try_to_free_pages().

If the system have really heavy pressure, do_try_to_free_pages()
will call disable_swap_token().

So, What benefit is there?



