Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161051Ab1FADdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 23:33:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65511 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173Ab1FADdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 23:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jmlXAvoZ/XsC9OlrYHqXpbTtjvH7VFgaF+jPAFsnYDpXGLFM8mrndqyGLBOQbsVjE0
         GMHmCfiZ33coGkKBh32SPjggBmOpYnFuSQLsWM1E+8w0onAwZ/ucvhcir6fSm1zb2JMz
         hPsSPiKX/IffRmka2l7rej+emC4AGdGe9yu4c=
Date: Wed, 1 Jun 2011 12:32:58 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: caiqian@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, rientjes@google.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Subject: Re: [PATCH v2 0/5] Fix oom killer doesn't work at all if system
 have > gigabytes memory  (aka CAI founded issue)
Message-ID: <20110601033258.GA12653@barrios-laptop>
References: <348391538.318712.1306828778575.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <4DE4A2A0.6090704@jp.fujitsu.com>
 <4DE4BC64.3040807@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE4BC64.3040807@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI,

On Tue, May 31, 2011 at 07:01:08PM +0900, KOSAKI Motohiro wrote:
> (2011/05/31 17:11), KOSAKI Motohiro wrote:
> >>> Then, I believe your distro applying distro specific patch to ssh.
> >>> Which distro are you using now?
> >> It is a Fedora-like distro.
> 
> So, Does this makes sense?
> 
> 
> 
> From e47fedaa546499fa3d4196753194db0609cfa2e5 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Tue, 31 May 2011 18:28:30 +0900
> Subject: [PATCH] oom: use euid instead of CAP_SYS_ADMIN for protection root process
> 
> Recently, many userland daemon prefer to use libcap-ng and drop
> all privilege just after startup. Because of (1) Almost privilege
> are necessary only when special file open, and aren't necessary
> read and write. (2) In general, privilege dropping brings better
> protection from exploit when bugs are found in the daemon.
> 
> But, it makes suboptimal oom-killer behavior. CAI Qian reported
> oom killer killed some important daemon at first on his fedora
> like distro. Because they've lost CAP_SYS_ADMIN.
> 
> Of course, we recommend to drop privileges as far as possible
> instead of keeping them. Thus, oom killer don't have to check
> any capability. It implicitly suggest wrong programming style.
> 
> This patch change root process check way from CAP_SYS_ADMIN to
> just euid==0.

I like this but I have some comments.
Firstly, it's not dependent with your series so I think this could
be merged firstly.
Before that, I would like to make clear my concern.
As I look below comment, 3% bonus is dependent with __vm_enough_memory's logic?
If it isn't, we can remove the comment. It would be another patch.
If is is, could we change __vm_enough_memory for euid instead of cap?

        * Root processes get 3% bonus, just like the __vm_enough_memory()
	* implementation used by LSMs.

-- 
Kind regards
Minchan Kim
