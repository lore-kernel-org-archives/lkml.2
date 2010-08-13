Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0HMVTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:19:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50037 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab0HMVTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:19:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EiFHwlcFlmHz7aHFvOc81HdMYAVzqk9IwjIMu5PmH2+0IvlbClKrl7XWCycUuNmVOK
         ThimUdxySBeTRgpXqRQPsU+Z2gRjCPrMhyEpBwCepF5OQqiBF0jI3WF/q3GGQnJqpItK
         4Y0P2DG5xR2nj315KDwgt2IyGzlLfPsRu3pco=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=hW0ceGxAPko4qG6uRz6tSEQEdzxRdeKWMueiz@mail.gmail.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274733081-4623-7-git-send-email-walken@google.com>
	<AANLkTikFEy26V4epRGCJiDkQNQ5BH0fPP0C=4phUB=o3@mail.gmail.com>
	<AANLkTimDGbrja5EgGQ+sQxHBRNMnmt7=rjtOfwAKEKFe@mail.gmail.com>
	<AANLkTim3thKSwTHSQ7UXir+1cT9cfFaEjTFGGMdz0_Bt@mail.gmail.com>
	<AANLkTikz2=pa5csA+pqDfKc_zYihyn+C9pUb_YNS9g0L@mail.gmail.com>
	<AANLkTiny_GOfvX-t=SoXZVi8uO3SHC_h2YgbPtCcLXcu@mail.gmail.com>
	<AANLkTin6cHofTWkAysi_hojxaYUJtXg44_F0AyffMy5k@mail.gmail.com>
	<AANLkTi=hW0ceGxAPko4qG6uRz6tSEQEdzxRdeKWMueiz@mail.gmail.com>
Date: Fri, 13 Aug 2010 14:19:03 -0700
Message-ID: <AANLkTi=c9DsAZArMpbz-7wUmR3nPQyAsOyOYxmeKh=2Q@mail.gmail.com>
Subject: Re: [PATCH 06/11] rwsem: wake queued readers when writer blocks on
 active read lock
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Waychison <mikew@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 9:09 AM, Tony Luck <tony.luck@intel.com> wrote:
> Still no reports from other architectures? So this still seems to be an
> ia64 specific problem. Time to start reading rwsem.c

My hung process is "make" (GNU Make 3.81). Stuck forever here:

SYSCALL_DEFINE1(brk, unsigned long, brk)
{
        unsigned long rlim, retval;
        unsigned long newbrk, oldbrk;
        struct mm_struct *mm = current->mm;
        unsigned long min_brk;

        down_write(&mm->mmap_sem);  <<<<<<<<<<<<<<<

Is make multi-threaded these days? If not, I'm confused about how anything
complicated could have happened on mmap_sem.

-Tony
