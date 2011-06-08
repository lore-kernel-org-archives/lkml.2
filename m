Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1FHCBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 22:01:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273Ab1FHCBS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 22:01:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110606161254.5f02d855.akpm@linux-foundation.org>
References: <1306772228-1603-1-git-send-email-minipli@googlemail.com> <20110606161254.5f02d855.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Jun 2011 19:00:24 -0700
Message-ID: <BANLkTinwMyVsR-pvimeVkcqQrCuNDK4zKw@mail.gmail.com>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathias Krause <minipli@googlemail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 4:12 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> I tried to work out how that set_fs() got there, in the historical git
> tree but it's part of 14592fa9:
>
>        73 files changed, 963 insertions(+), 798 deletions(-)
>
> which is pretty useless (what's up with that?)

Use tglx's more complete linux-history tree:

    http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=summary

instead of the bkcvs import tree.

That said, that commit (it's commit ID 4095b99c09e3d in tglx's tree)
predates the "real" BK history too: it's part of the (limited) 2.4.x
history that was imported from the release patches into BK at the
beginning of the use of BK. So at that point we didn't do indivual
commits, it's just the import of the v2.4.3.7 -> v2.4.3.8 patch.

But yeah, it's old and crufty. And I agree that usually the correct
fix is to remove the set_fs() calls entirely.

                            Linus
