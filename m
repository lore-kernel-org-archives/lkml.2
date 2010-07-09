Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab0GIN7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:59:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab0GIN7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:59:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTikP-u1adVItGDgUZdee14Z13k8MLRC5V7UN-gpV@mail.gmail.com>
References: <AANLkTikP-u1adVItGDgUZdee14Z13k8MLRC5V7UN-gpV@mail.gmail.com> <20100630233614.32422.97038.stgit@warthog.procyon.org.uk>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, linux-ext4@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats available [ver #3]
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Date: Fri, 09 Jul 2010 14:59:06 +0100
Message-ID: <21105.1278683946@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@gmail.com> wrote:

> >        struct xstat_parameters {
> >                unsigned long long      request_mask;
> 
> Poor name, since it's a value-result arg? Better maybe something like
> "field_mask"?

No.  The contents of xstat_parameters aren't changed.  request_mask is what
you're asking for, result_mask in the xstat struct is what you actually got.

result_mask may be more or less than request_mask as the filesystem isn't
obliged to supply anything you didn't ask for, and may not be able to supply
something you did ask for, and may give you stuff anyway that you didn't ask
for if it's trivial to do so.

> There is no XSTAT_REQUEST__GET_ANYWAY, AFAICS. I guess here you meant
> XSTAT_REQUEST__EXTENDED_STATS? Or?

Yep.  I forgot to change that in the patch description.

> This case is almost certainly a user error, so why not simply return
> an error (-1 and ERANGE or E2BIG)? The above approach invites
> userspace errors of the form:
> 
> if (xtat(...) < 0) { /* How users often check for error */
>     /* I'll handle the error */
> } else {
>     /* The call succeeded; I'm fine */
> }

I suppose.

> If you are looking for a way to inform the user about the required
> buffer size, I think it would be better to take a leaf from the
> getxattr(2) book: if 'buflen' is zero, then do nothing with the output
> arg, but return the size that would be required.

That's reasonable.

David
