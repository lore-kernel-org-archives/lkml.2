Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab0KKUza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:55:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64621 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab0KKUz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:55:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCHv6 1/7] notify userspace about time changes
Date: Thu, 11 Nov 2010 21:55:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>, mtk.manpages@gmail.com
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org> <1289503802-22444-2-git-send-email-virtuoso@slind.org>
In-Reply-To: <1289503802-22444-2-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011112155.17423.arnd@arndb.de>
X-Provags-ID: V02:K0:9oW/62FT8Op0GLj2R4A8Jt/CbLjMurfK/ksd2z6RuqO
 j+rqpUfI2gTn01wP8BZYq8BUQO8MhsCgfRUPMzXddLQmgXPxyt
 CYIW8EzuYZmPK4Rfq2hv2yrQrg8f+Fp2C+PyjLjCD+ePK0FFY9
 1qPnIHcmGH49YRJSx9DoMAtUY0ofVEiAEJnlDjrp9/yprykwcg
 7N1cyNSRq/e2IHX2jq5fA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 November 2010 20:29:56 Alexander Shishkin wrote:
> Certain userspace applications (like "clock" desktop applets or cron) might
> want to be notified when some other application changes the system time.
> There are several known to me reasons for this:
>  - avoiding periodic wakeups to poll time changes;
>  - changing system timekeeping policy for system-wide time management
>    programs;
>  - keeping guest applications/operating systems running in emulators
>    up to date.
> 
> This patch implements a notification interface via eventfd mechanism. Proccess
> wishing to be notified about time changes should create an eventfd and pass it
> to time_change_notify() syscall. After that, any calls to settimeofday()/
> stime()/adjtimex() made by other processes will be signalled to this eventfd.
> Credits for suggesting the eventfd mechanism for this purpose go to Kirill
> Shutemov.
> 
> This patch adds the syscall to asm-generic/unistd.h and a simple usage
> example.

Looks reasonable to me.

It would be good to have the man page for this, too. I guess it could
be added to the existing clock_{get,set}time man page, so you can
add a patch for that.

	Arnd
