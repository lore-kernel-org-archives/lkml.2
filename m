Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1BBEXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 23:23:03 -0500
Received: from smtp2.mail.ru ([94.100.176.130]:52835 "EHLO smtp2.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab1BBEXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 23:23:01 -0500
Date: Wed, 2 Feb 2011 07:23:47 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH] ufs: Check if page has buffers before calling
 page_buffers()
Message-ID: <20110202042347.GA3870@maclin>
Mail-Followup-To: Alessio Igor Bogani <abogani@kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tim Bird <tim.bird@am.sony.com>
References: <1296595418-2457-1-git-send-email-abogani@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296595418-2457-1-git-send-email-abogani@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 10:23:38PM +0100, Alessio Igor Bogani wrote:
> In ufs_change_blocknr() we have called page_buffers() without checking if the
> page actually had pages attached to it and this could cause a BUG oops.
> 

This looks wrong for me. May be I missed something?
Put little more context here.
In ufs the tail of small files consists of fragments (usually 2K),
the rest of file consists of blocks (usually 16K=8 fragments).
When file is growing, and tail become too big (8 fragments)
we allocate one block and move content of 8 fragments to it.

So in our case we reach (during realocation) point when
!page_has_buffers(page) (how?) and in your patch you suggest
just ignore such buffer (in terms of ufs - fragments),
in other words silently corrupt user data.
May be there is better variant?


-- 
/Evgeniy

