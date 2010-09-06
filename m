Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0IFI7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:59:44 -0400
Received: from smtp-out.google.com ([74.125.121.35]:9570 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab0IFI7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:59:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=IGWczBBI10TiUcD7s9pSVSBzmqhF/yhTXMlxMOGOHUWPKv1M+N6IjqJ+mV4FcJJFK
	DO2bBHMtAsHPbFib440oQ==
Date: Mon, 6 Sep 2010 01:59:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 14/14] mm: oom_kill: use IS_ERR() instead of strict
 checking
In-Reply-To: <20100906094555.C8BB.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1009060155250.10552@chino.kir.corp.google.com>
References: <1283711592-7669-1-git-send-email-segooon@gmail.com> <20100906094555.C8BB.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010, KOSAKI Motohiro wrote:

> > From: Vasiliy Kulikov <segooon@gmail.com>
> > 
> > Use IS_ERR() instead of strict checking.
> 
> Umm...
> 
> I don't like this. IS_ERR() imply an argument is error code. but in
> this case, we don't use error code. -1 mean oom special purpose meaning
> value.
> 

You could make the same argument by saying the current use of PTR_ERR() 
implies an error code.  We've simply hijacked -1UL for simplicity in this 
case and because select_bad_process() can only return one other value 
besides a pointer to a process or NULL.

> So, if we take this direction, It would be better to use EAGAIN or something
> instead -1.
> 

I agree it would probably better to return ERR_PTR(-EAGAIN) instead of 
using -1UL.
