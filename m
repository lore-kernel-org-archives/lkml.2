Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab0KPGnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 01:43:40 -0500
Received: from smtp-out.google.com ([74.125.121.35]:34380 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246Ab0KPGnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 01:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ZwkZN0PgIAmoqCX7pFcFSV+Hx7vG3iNHVFaKI/Lp+/uTSxH3e84WOQnOCUSvR9nMDo
         5/LMd+CqW8dMJPAKLTRw==
Date: Mon, 15 Nov 2010 22:43:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Valdis.Kletnieks@vt.edu
cc: Jesper Juhl <jj@chaosbits.net>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: <34565.1289866395@localhost>
Message-ID: <alpine.DEB.2.00.1011152240410.9168@chino.kir.corp.google.com>
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com> <20101114181905.bc5b44f9.akpm@linux-foundation.org> <20101115113238.BF06.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com> <alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net>
 <34565.1289866395@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Valdis.Kletnieks@vt.edu wrote:

> Make that 2 common apps:
> 
> % uname -a
> Linux turing-police.cc.vt.edu 2.6.37-rc1-mmotm1109 #1 SMP PREEMPT Wed Nov 10 12:30:17 EST 2010 x86_64 x86_64 x86_64 GNU/Linux
> % dmesg | grep oom
> [   89.981594] sshd (4168): /proc/4168/oom_adj is deprecated, please use /proc/4168/oom_score_adj instead.
> % rpm -q openssh
> openssh-5.6p1-16.fc15.x86_64
> 
> 5.6p1 is the latest-n-greatest released version on www.openssh.org, so somebody
> probably needs to rattle their chain...
> 

Thanks, Darren Tucker fixed this a few hours after I reported it on the 
openssh bugzilla, the patch is at 
https://bugzilla.mindrot.org/show_bug.cgi?id=1838 -- it uses oom_score_adj 
if it exists and then falls back to oom_adj if running on an older kernel.
