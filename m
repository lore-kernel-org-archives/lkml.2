Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1AEJzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:55:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab1AEJzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:55:09 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110104152100.29d0da02.akpm@linux-foundation.org>
References: <20110104152100.29d0da02.akpm@linux-foundation.org> <1291978505-29076-1-git-send-email-andy.shevchenko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>
Subject: Re: [resend][PATCH] fs: use kernel's hex_to_bin() method
Date: Wed, 05 Jan 2011 09:54:58 +0000
Message-ID: <28315.1294221298@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Not a terribly convenient convenience, as most callers will need to cast
> away the constness of the return value.  Oh well, those callers should
> have been using a `const char *' anyway.

Maybe.  You could always do as strchr():

	char *strchr(const char *s, int c);

Then you don't need to cast the result.  The problem[*] is that you can't tell
the compiler that the return value should carry the same constness as one of
the arguments because you don't have something like C++ templates.

  [*] If indeed not having C++ or templates should be seen as a problem...

David
