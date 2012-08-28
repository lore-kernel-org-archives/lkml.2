Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab2H1Egf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 00:36:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56015 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2H1Ege (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 00:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120827200510.GB14812@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
	<1346090307-3020-7-git-send-email-laijs@cn.fujitsu.com>
	<20120827200510.GB14812@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Tue, 28 Aug 2012 12:36:33 +0800
Message-ID: <CACvQF51fcEr2jMwpA1ec6QeDksEHz-+qDwYnABzDhLO0wX8omg@mail.gmail.com>
Subject: Re: [PATCH 6/7] workqueue: init 0 for idle_rebind.cnt
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 4:05 AM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Aug 28, 2012 at 01:58:26AM +0800, Lai Jiangshan wrote:
>> Access idle_rebind.cnt is always protected by gcwq->lock,
>> don't need to init it as 1.
>
> But then the completion could be triggered prematurely, no?

No, the idle_worker_rebind() can't be called until rebind_workers()
finish counting and release the gcwq->lock.

>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
