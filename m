Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1EUKMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 06:12:31 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38761 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1EUKM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 06:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=obP30HZLVh57yW+ce6cM5sHicsO+gO2AHZQnEW/rWLZxAuScgHcr0/YVXVzNmsLFwJ
         wHOSa247NSwhv5daIy9A/buzrkENTGLPEmaLra8G9rI1zHfrEKP4xTI0bkryZ2Zx8cyt
         AXpzIdPFeMD/foqC6A5j0wbH9oaswI6CjOFSc=
MIME-Version: 1.0
In-Reply-To: <201105210053.51314.toralf.foerster@gmx.de>
References: <201105191526.31904.toralf.foerster@gmx.de>
	<1305907458.1465.23.camel@gandalf.stny.rr.com>
	<1305907896.1465.27.camel@gandalf.stny.rr.com>
	<201105210053.51314.toralf.foerster@gmx.de>
Date: Sat, 21 May 2011 12:12:27 +0200
Message-ID: <BANLkTinvtfpPr3GxKA49MN4y1q66HETorQ@mail.gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Darren Hart <dvhart@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/21 Toralf Förster <toralf.foerster@gmx.de>:
> Bisecting gave :
>
>
> git bisect badd123375425d7df4b6081a631fc1203fceafa59b2 is the first bad commit
> commit d123375425d7df4b6081a631fc1203fceafa59b2
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Jan 26 21:32:01 2011 +0100
>
>    rwsem: Remove redundant asmregparm annotation
>
>    Peter Zijlstra pointed out, that the only user of asmregparm (x86) is
>    compiling the kernel already with -mregparm=3. So the annotation of
>    the rwsem functions is redundant. Remove it.

Ok, this bisect makes much more sense.

Thomas, Peter, please revert d123375425d7df4b6081a631fc1203fceafa59b2.
We cannot compile UML with -mregparm=3 it would cause a lot of trouble.
It would break 32bit UML on 64bit and also on older 32bit systems like RHEL5.

-- 
Thanks,
//richard
