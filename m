Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1IUKGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:06:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:48845 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab1IUKGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:06:54 -0400
Date: Wed, 21 Sep 2011 12:06:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ben Hutchings <ben@decadent.org.uk>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andres Salomon <dilinger@queued.net>, Andy Lutomirski <luto@mit.edu>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH] x86-32: Fix alignment of alternative instruction
 entries
In-Reply-To: <1316580313.4122.21.camel@deadeye>
Message-ID: <alpine.LFD.2.02.1109211206130.2723@ionos>
References: <1316580313.4122.21.camel@deadeye>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011, Ben Hutchings wrote:

> The altinstruction_entry macro was originally used only on x86-64,
> and assumed 64-bit pointers and alignment.
> 
> Commit b4ca46e4e82a0a5976fe5eab85be585d75f8202f ("x86-32: Fix boot
> with CONFIG_X86_INVD_BUG") introduced a use of the macro on x86-32.
> Before this, the 64-bit pointers had been replaced by 32-bit offsets,
> so it worked - in at least one case.  However, the alignment is still
> wrong for x86-32, which can result in zero-padding between entries and
> a BUG in apply_alternatives.

Fixed in Linus tree already: commit a7f934d4f16144cb

Thanks,

	tglx
