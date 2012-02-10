Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab2BJT2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:28:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62955 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab2BJT2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:28:47 -0500
MIME-Version: 1.0
In-Reply-To: <D35F212C-0C17-43CE-885D-62C6DF58E2C2@dilger.ca>
References: <92291682-5422-4AE2-9608-97775603E7FD@tuxera.com>
 <20120208001519.501b6fea@pyramind.ukuu.org.uk> <673AFC57-2B73-49AC-962E-CAB1DE775B2C@tuxera.com>
 <D35F212C-0C17-43CE-885D-62C6DF58E2C2@dilger.ca>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Feb 2012 11:28:27 -0800
X-Google-Sender-Auth: VM2zWB5Q1P5Dd6kfco74SudB0Lg
Message-ID: <CA+55aFyBAiZ3khqQiSU0OBafMABsAzdU5DLzZvaM_Et52Wte5w@mail.gmail.com>
Subject: Re: Direct i/o changes break all non-GPL file systems
To: Andreas Dilger <adilger@dilger.ca>
Cc: Anton Altaparmakov <anton@tuxera.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Szabolcs Szakacsits <szaka@tuxera.com>,
        =?ISO-8859-1?Q?Janne_Kalliom=E4ki?= <janne@tuxera.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 5:51 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>
> This doesn't affect me directly, since Lustre is itself a GPL filesystem,
> but it does seem a bit harsh for such a minor amount of functionality.

It also wasn't documented in the commit or apparently even intentional.

> Looking at inode_dio_wait(), there isn't anything in there that couldn't
> be implemented without using that GPL-only symbol export.  Both inode_dio_wait()
> and __inode_dio_wait() use only functions that are themselves EXPORT_SYMBOL()
> (i.e. not GPL-only) and locally accessible structures (inode->i_dio_count
> and inode->i_state), so I don't see any benefit or reason in making
> inode_dio_wait() itself GPL.

Yes. I suspect we should just remove the _GPL part. Christoph, Al?

                      Linus
