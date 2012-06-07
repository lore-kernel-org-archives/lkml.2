Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921Ab2FGOZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 10:25:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760760Ab2FGOZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 10:25:21 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, kernel-janitors@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 4/7] fs/direct-io.c: adjust suspicious bit operation
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr>
	<1339018901-28439-5-git-send-email-Julia.Lawall@lip6.fr>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 07 Jun 2012 10:24:46 -0400
In-Reply-To: <1339018901-28439-5-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Wed, 6 Jun 2012 23:41:38 +0200")
Message-ID: <x49bokvb3o1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <Julia.Lawall@lip6.fr> writes:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> READ is 0, so the result of the bit-and operation is 0.  Rewrite with == as
> done elsewhere in the same file.
>
> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).

Interesting catch, that one.  Yeah, we don't expect any readahead I/O to
be done via O_DIRECT.  The test for rw == READ all over that file seems
fine to me, given that.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
