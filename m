Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966202Ab2FBBpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 21:45:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40328 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966188Ab2FBBp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 21:45:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1206011511560.12839@eggly.anvils>
References: <20120530163317.GA13189@redhat.com> <20120531005739.GA4532@redhat.com>
 <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
 <20120601161205.GA1918@redhat.com> <20120601171606.GA3794@redhat.com> <alpine.LSU.2.00.1206011511560.12839@eggly.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Jun 2012 18:45:07 -0700
X-Google-Sender-Auth: MgjYepTACaQC49TKf5qQ11LrLmw
Message-ID: <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com>
Subject: Re: WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0x13a/0x170()
To: Hugh Dickins <hughd@google.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 1, 2012 at 3:17 PM, Hugh Dickins <hughd@google.com> wrote:
>
> +       spin_lock_irqsave(&zone->lock, flags);
>        for (page = start_page, pfn = start_pfn; page < end_page; pfn++,
>                                                                  page++) {

So holding the spinlock (and disabling irqs!) over the whole loop
sounds horrible.

At the same time, the iterators don't seem to require the spinlock, so
it should be possible to just move the lock into the loop, no?

                  Linus
