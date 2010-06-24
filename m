Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0FXClr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 22:41:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40380 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab0FXClq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 22:41:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mike McCormack <mikem@ring3k.org>
Subject: Re: [PATCH] proc: Add complete process group list
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       oleg@redhat.com, serue@us.ibm.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4C221F0E.8070502@ring3k.org>
References: <20100622153757.dcb6bda9.akpm@linux-foundation.org> <4C221F0E.8070502@ring3k.org>
Message-Id: <20100624110836.B5B2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 24 Jun 2010 11:41:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * modify kernel to list all groups in /proc/<pid>/status 
>     - very long lines become possible in status file
>     - no way to know whether you're using an old kernel with 32 group limit
>        or new kernel and pid only has 32 groups

Is this necessary? Why?
Who need 32 groups limitation?


> * modify kernel to add /proc/<pid>/groups
>     - more kernel-userland interface

My personal opinion (aka my personal prefer) is,
 - If fixing /proc/<pid>/status is zero downside, it should do.
 - If fixing /proc/</pid>status is some downside (e.g. performance down),
   /proc/<pid>groups is better

because, 99% user don't use >32groups.


And, personally I dislike following three ;)

> * implement LOCAL_CREDS for unix domain sockets in Linux
>     - work
> 
> * limit number of groups to 32
>     - limit is imposed by /proc code
> 
> * create multiple unix domian sockets per privilege with group r/w only
>     - seems like trouble



