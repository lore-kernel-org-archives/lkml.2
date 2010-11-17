Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab0KQC4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:56:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759431Ab0KQC4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:56:30 -0500
MIME-Version: 1.0
In-Reply-To: <20101116170005.2646f4fb.randy.dunlap@oracle.com>
References: <AANLkTimYevUOSxDm+nGq_ctPEFp_E2zJR7rNGvUi2fWY@mail.gmail.com> <20101116170005.2646f4fb.randy.dunlap@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 18:56:08 -0800
Message-ID: <AANLkTimE_y=GFP+Sg-MYvEfQyg7GtzGRs+gdqjzOZm-_@mail.gmail.com>
Subject: Re: [PATCH] cciss: fix build for PROC_FS disabled
To: Randy Dunlap <randy.dunlap@oracle.com>, Jens Axboe <jaxboe@fusionio.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 5:00 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> Fix cciss driver for CONFIG_PROC_FS not enabled:
>
> drivers/block/cciss.c:4929: error: 'proc_cciss' undeclared (first use in this function)

Hmm. I would almost prefer to not have this #ifdef inside code, and
solve it by simply moving the definition of "proc_cciss" to outside
the other #ifdef CONFIG_PROC_FS.

That way it allways stays NULL, and without CONFIG_PROC_FS the code in
question will all be empty inline function calls anyway, so the
compiler will compile it all away (at the cost of just keeping that
one unnecessary variable around).

I'd rather waste one useless pointer than have ugly source code.

Comments?

                Linus
