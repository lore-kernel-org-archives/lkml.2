Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211Ab2JaBDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 21:03:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab2JaBDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 21:03:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAGXu5jL6hqy-5aZQnLetxDh+XyDr5HUDYKCuPw_dcS7RQB77_w@mail.gmail.com>
References: <CAGXu5jL6hqy-5aZQnLetxDh+XyDr5HUDYKCuPw_dcS7RQB77_w@mail.gmail.com> <20121030191927.11000.68420.stgit@warthog.procyon.org.uk> <20121030192157.11000.12874.stgit@warthog.procyon.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, pjones@redhat.com,
        jwboyer@redhat.com, mjg@redhat.com, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/23] pefile: Strip the wrapper off of the cert data block
Date: Wed, 31 Oct 2012 01:03:39 +0000
Message-ID: <23196.1351645419@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> > +       memcpy(&wrapper, prep->data + ctx->sig_offset, 8);
> 
> Instead of the literal 8, sizeof(wrapper)?

Reasonable.  It was originally an array of bytes until I found out that it had
structure.  Even so, I should probably have used sizeof() then.

> > +               if (pkcs7[1] == 0x82 &&
> > +                   pkcs7[2] == (((ctx->sig_len - 4) >> 8) & 0xff) &&
> > +                   pkcs7[3] ==  ((ctx->sig_len - 4)       & 0xff))
> > +                       return 0;
> > +               if (pkcs7[1] == 0x80)
> > +                       return 0;
> > +               if (pkcs7[1] > 0x82)
> > +                       return -EMSGSIZE;
>
> Can these literals be replaced with something more meaningful?

Certainly the 0x80 can.  I have a patch to define ASN1_INDEFINITE_LENGTH.  The
question is how to define the 0x82 since it's a flag plus a value.  Maybe by
using something like:

	#define ASN1_LONG_LENGTH(x) (0x80 | (x))

Anyway, thanks for the reviews!

David
