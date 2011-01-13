Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab1AMQmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:42:15 -0500
Received: from www.tglx.de ([62.245.132.106]:60654 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757097Ab1AMQmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:42:13 -0500
Date: Thu, 13 Jan 2011 17:41:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
cc: Nick Piggin <npiggin@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Subject: Re: [PATCH] fs: Work around NFS wreckage
In-Reply-To: <8952.1294927845@jrobl>
Message-ID: <alpine.LFD.2.00.1101131732500.2678@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6> <8952.1294927845@jrobl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011, J. R. Okajima wrote:
> Thomas Gleixner:
> > The dcache scalability work broke NFS root filesystems.
> 	:::
> > Check for parent equal dentry and skip the nested lock to avoid the
> > deadlock. I'm sure this is the wrong fix, but at least it "works" :)
> 
> With this patch, can you unmount it cleanly?
> It skips incrementing d_count for both dentries.
> Do we need at least one?

Not sure, as we should not end up there at all I guess.
