Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0I2McD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:32:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54008 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0I2McB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:32:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Petr Vandrovec <petr@vandrovec.name>
Subject: Re: [PATCH] Remove BKL usage from ncpfs
Date: Wed, 29 Sep 2010 14:31:54 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, aia21@cam.ac.uk,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20100926234733.GA31884@vana.vc.cvut.cz> <201009271616.42190.arnd@arndb.de> <AANLkTinhD+P8y3BwNxro9fVr62MmASTubrefP9=Z8ce4@mail.gmail.com>
In-Reply-To: <AANLkTinhD+P8y3BwNxro9fVr62MmASTubrefP9=Z8ce4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009291431.54709.arnd@arndb.de>
X-Provags-ID: V02:K0:LvftJzusCHtxGsr42PXoZ6AMwKbQG7TTM3IJ0cGbAmO
 7e7NIMDFZgV8LApp5EwgA7SpIF+5T22DUtmJQQNhj3AY+1ZQ/2
 i8ssgjNIQYeenL/GKhRix/sfN7PcFdezb4vFDqdhozQ+mK9c4E
 C2Fa4w0hb8+R3KFHcIMfXE8ZbGqFv6U+5hM2op2Yah0yeSsbcE
 zuSkj9ordJuA5g1opCkYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 September 2010, Petr Vandrovec wrote:
> Yes, I believe it is not necessary.  fill_super(sb) should not run
> concurrently with anything else because MS_BORN and MS_ACTIVE are not
> set yet so nobody else should use this sb from VFS.  One thing which
> seems to be missing is doing lock_sock() around code which sets
> sk->sk_{error_report,data_ready,write_space} - there does not seem to
> be anything else to protect ipv4/ipv6/ipx from seeing partially
> updated pointers on systems where these writes are not atomic - that's
> ncpfs2.patch.
> 
> Also I found some whitespace problems, and one missing const, so if
> you could merge ncpfs3.patch & ncpfs4.patch with original BKL removal,
> it would be cool.  Or I can resend all 4 patches as one bigger diff if
> you prefer.

Generally I prefer separate patches for changes that make sense to be
split, so I left ncpfs2.patch separately.

I think it would be nice to do the first patch in smaller steps, but
since you are the maintainer, I'm not going to complain ;-)

Applied both patches to my bkl/vfs series now.

	Arnd
