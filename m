Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab1FHKrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:47:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60966 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab1FHKrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:47:31 -0400
Date: Wed, 8 Jun 2011 11:47:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mathias Krause <minipli@googlemail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
Message-ID: <20110608104727.GT11521@ZenIV.linux.org.uk>
References: <1306772228-1603-1-git-send-email-minipli@googlemail.com>
 <20110606161254.5f02d855.akpm@linux-foundation.org>
 <BANLkTinwMyVsR-pvimeVkcqQrCuNDK4zKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinwMyVsR-pvimeVkcqQrCuNDK4zKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 07:00:24PM -0700, Linus Torvalds wrote:

> That said, that commit (it's commit ID 4095b99c09e3d in tglx's tree)
> predates the "real" BK history too: it's part of the (limited) 2.4.x
> history that was imported from the release patches into BK at the
> beginning of the use of BK. So at that point we didn't do indivual
> commits, it's just the import of the v2.4.3.7 -> v2.4.3.8 patch.
> 
> But yeah, it's old and crufty. And I agree that usually the correct
> fix is to remove the set_fs() calls entirely.

I think these days its job is done by start_thread(), which is where we
switch to USER_DS; it's called by ->load_binary() when it decides it's past
the point of no return.  However, it would be a good idea to verify that
all architectures do it there properly and we are not exposing a hole by
removal of this set_fs()...
