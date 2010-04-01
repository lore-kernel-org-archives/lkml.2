Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab0DAIvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 04:51:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab0DAIvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:51:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Thu, 1 Apr 2010 10:50:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
References: <201003242240.54907.arnd@arndb.de> <adazl1ogn0o.fsf@roland-alpha.cisco.com>
In-Reply-To: <adazl1ogn0o.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011050.42871.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+r2W4sVlkcflFkE8odRFiucgEsgwtX0HpOdYs
 Pbr7Re5vgh96FdLdeU0b35lwkDwWsjGegbxIyFwEZfuNgiHm4J
 81Wnn+KTfXHHweylxW2dQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010, Roland Dreier wrote:
> Looking at your tree, I see you have commit 753dd249 ("perf_event: use
> nonseekable_open") that does:
> 
>  > --- a/kernel/perf_event.c
>  > +++ b/kernel/perf_event.c
>  > @@ -2515,6 +2515,8 @@ static int perf_fasync(int fd, struct file *filp, int on)
>  >  }
>  >  
>  >  static const struct file_operations perf_fops = {
>  > +       .open                   = nonseekable_open,
>  > +       .llseek                 = no_llseek,
>  >         .release                = perf_release,
>  >         .read                   = perf_read,
>  >         .poll                   = perf_poll,
> 
> But if I understand this correctly, the assignment to .open is at best
> useless -- these file_operations are only used via anon_inode_getfd()
> and so there is no possible path that can call the .open method.  Or am
> I missing something?

You're right. I did not consider this.

	Arnd
