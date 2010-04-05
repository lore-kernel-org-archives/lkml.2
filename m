Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab0DEOwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 10:52:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab0DEOwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 10:52:33 -0400
X-Authority-Analysis: v=1.1 cv=pKw63bS+wPQ6BxbjPFuXko/1Hb8f7lpGL8zfzHecwYY= c=1 sm=0 a=8HfDGDrX6DwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=hzF7_oyhP3RjhWxQNvQA:9 a=cowhnAxB46qFksx48W7W3lR1iJMA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: kill wrong message when cat tracing/trace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BB9A929.2000303@cn.fujitsu.com>
References: <4BB9A929.2000303@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 05 Apr 2010 10:52:30 -0400
Message-ID: <1270479150.19685.14793.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-05 at 17:11 +0800, Lai Jiangshan wrote:
> Because of a local variable is not initialized, I got these
> when I did 'cat tracing/trace'. (not trace_pipe):
> 
> CPU:0 [LOST 18446744071579453134 EVENTS]
>               ps-3099  [000]   560.770221: lock_acquire: ffff880030865010 &(&dentry->d_lock)->rlock
> CPU:0 [LOST 18446744071579453134 EVENTS]
>               ps-3099  [000]   560.770221: lock_release: ffff880030865010 &(&dentry->d_lock)->rlock
> CPU:0 [LOST 18446612133255294080 EVENTS]
>               ps-3099  [000]   560.770221: lock_acquire: ffff880030865010 &(&dentry->d_lock)->rlock
> CPU:0 [LOST 18446744071579453134 EVENTS]
>               ps-3099  [000]   560.770222: lock_release: ffff880030865010 &(&dentry->d_lock)->rlock
> CPU:0 [LOST 18446744071579453134 EVENTS]
>               ps-3099  [000]   560.770222: lock_release: ffffffff816cfb98 dcache_lock
> 
> See peek_next_entry(), it does not set *lost_events when we 'cat tracing/trace'
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied, Thanks Lai!

-- Steve


