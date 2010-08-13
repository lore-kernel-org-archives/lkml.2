Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934590Ab0HMQJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 12:09:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65290 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0HMQJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 12:09:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=nbGKNs4A2KPhv7EQtAmdalEd7nCGUZY6tzuhN7qzs913MxCUC2XsgmUso2EuWaxEOl
         UO8yCulKfVg9ytqIMYqRBPjZIb0ROmjL4ewcmmK65dSTrUaq9ihj11tGY+UZ1E7Gi7eU
         d23q+GEJiPzxEvvz4EuWfRG5jxCcFJSUl9qZs=
MIME-Version: 1.0
In-Reply-To: <AANLkTin6cHofTWkAysi_hojxaYUJtXg44_F0AyffMy5k@mail.gmail.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274733081-4623-7-git-send-email-walken@google.com>
	<AANLkTikFEy26V4epRGCJiDkQNQ5BH0fPP0C=4phUB=o3@mail.gmail.com>
	<AANLkTimDGbrja5EgGQ+sQxHBRNMnmt7=rjtOfwAKEKFe@mail.gmail.com>
	<AANLkTim3thKSwTHSQ7UXir+1cT9cfFaEjTFGGMdz0_Bt@mail.gmail.com>
	<AANLkTikz2=pa5csA+pqDfKc_zYihyn+C9pUb_YNS9g0L@mail.gmail.com>
	<AANLkTiny_GOfvX-t=SoXZVi8uO3SHC_h2YgbPtCcLXcu@mail.gmail.com>
	<AANLkTin6cHofTWkAysi_hojxaYUJtXg44_F0AyffMy5k@mail.gmail.com>
Date: Fri, 13 Aug 2010 09:09:04 -0700
X-Google-Sender-Auth: LD7UjAbb9KzhDgBbB_CIKSzwS3g
Message-ID: <AANLkTi=hW0ceGxAPko4qG6uRz6tSEQEdzxRdeKWMueiz@mail.gmail.com>
Subject: Re: [PATCH 06/11] rwsem: wake queued readers when writer blocks on
 active read lock
From: Tony Luck <tony.luck@intel.com>
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

On Thu, Aug 12, 2010 at 3:23 PM, Tony Luck <tony.luck@gmail.com> wrote:
> I'm going to try the current kernel with the 424acaae reverted (and
> with the ia64 rwsem.h reverted too) to check whether this is still the same
> root cause

This kernel ran "make clean ; make -j32" all night long. It's completed 415
cycles with no apparent problems. Average cycle time is 147.2 seconds.
Minimum is 144, max is 158 ... which all looks very normal.

It's probably a good thing that the unsigned RWSEM_WAITING_BIAS
problem led me to this commit with a problem that showed up during
boot. I'd hate to be bisecting this based on a problem that only shows
up after an unknown number of kernel builds :-)

Still no reports from other architectures? So this still seems to be an
ia64 specific problem. Time to start reading rwsem.c

-Tony
