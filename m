Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab2CRWBa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 18:01:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64504 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab2CRWB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 18:01:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120318190744.GA6589@ZenIV.linux.org.uk>
References: <20120318190744.GA6589@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Mar 2012 15:01:08 -0700
X-Google-Sender-Auth: um4gyVVPYItTK98ZRa1STPRP6NY
Message-ID: <CA+55aFwBEoD167oD=X9d6jR+wn6Tb-QFgZR+wGwdej4qakCMgg@mail.gmail.com>
Subject: Re: [rfc][patches] fix for munmap/truncate races
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 12:07 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> -       tlb_finish_mmu(&tlb, 0, end);
> +       tlb_finish_mmu(&tlb, 0, -1);

Hmm. The fact that you drop the end pointer means that some
architectures that optimize the TLB flushing for ranges now
effectively can't do it any more.

Now, I think it's only ia64 that really is affected, but it *might* matter.

In particular, ia64 has some logic for "if you only flush one single
region, you can optimize it", and the region sizes are in the
terabytes. And I'm pretty sure you broke that - I'm just not entirely
sure how much we care.

                 Linus
