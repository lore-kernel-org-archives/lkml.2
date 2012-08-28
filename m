Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2H1HEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 03:04:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63533 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2H1HEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 03:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <CACvQF51fcEr2jMwpA1ec6QeDksEHz-+qDwYnABzDhLO0wX8omg@mail.gmail.com>
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com>
	<1346090307-3020-7-git-send-email-laijs@cn.fujitsu.com>
	<20120827200510.GB14812@dhcp-172-17-108-109.mtv.corp.google.com>
	<CACvQF51fcEr2jMwpA1ec6QeDksEHz-+qDwYnABzDhLO0wX8omg@mail.gmail.com>
Date: Tue, 28 Aug 2012 00:04:07 -0700
X-Google-Sender-Auth: gf_BA9U-9bTQMKtv2aei0gxt8N8
Message-ID: <CAOS58YPLYfhSQAGqbZ0i60v0XKqJ15jF9eaEJzk2t+NT5mT=PQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] workqueue: init 0 for idle_rebind.cnt
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 27, 2012 at 9:36 PM, Lai Jiangshan <eag0628@gmail.com> wrote:
>> But then the completion could be triggered prematurely, no?
>
> No, the idle_worker_rebind() can't be called until rebind_workers()
> finish counting and release the gcwq->lock.

I see but I still wanna keep it counting from 1.  That's an
established pattern and is more robust.  I really don't see what we're
gaining by doing it differently.

Thanks.

-- 
tejun
