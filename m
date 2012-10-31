Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934812Ab2JaA7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:59:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab2JaA7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:59:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAGXu5jK22D_15jYopqaegYAGSHO2x0asXogXCnZGfMw2KwUVNw@mail.gmail.com>
References: <CAGXu5jK22D_15jYopqaegYAGSHO2x0asXogXCnZGfMw2KwUVNw@mail.gmail.com> <20121030191927.11000.68420.stgit@warthog.procyon.org.uk> <20121030192148.11000.3582.stgit@warthog.procyon.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, pjones@redhat.com,
        jwboyer@redhat.com, mjg@redhat.com, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/23] pefile: Parse a PE binary to find a key and a signature contained therein
Date: Wed, 31 Oct 2012 00:59:26 +0000
Message-ID: <23121.1351645166@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> This multiplication can push the cursor out of bounds. (n_data_dirents
> is unverified).
> ...
> Both of these cases of n_sections multiplications can wrap.
> Ultimately, you can end up with cursor close to zero, but n_sections
> being giant.

Good points.  I wonder if I should limit these to some low number, or just
check that they don't exceed header_size, which also needs checking as you
said.

> ... (Also, do you want a "break" in there after the first .keylist is found,
> or is this intentionally "use last key list"?)

I hadn't considered that.  Inserting a break is probably best, if only to
curtail the processing time slightly.

David
