Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2JBAsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:48:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52689 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2JBAsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:48:03 -0400
Date: Mon, 1 Oct 2012 17:47:29 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@google.com, tj@kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [RFC, PATCH] Extensible AIO interface
Message-ID: <20121002004728.GD29160@moria.home.lan>
References: <20121001222341.GF26488@google.com>
 <20121001231222.GB14533@lenny.home.zabbo.net>
 <20121001232235.GH26488@google.com>
 <20121001234439.GC14533@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001234439.GC14533@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 04:44:39PM -0700, Zach Brown wrote:
> And what about duplicate instances of a given attribute id?  Use the
> first?  The last?  Error?  Depends on the id?

I thought of a better idea, instead of explicitly checking for
disallowed dups:

We want to return -ENOTHANDLED for not handled attributes anyways, so
let's just do that for dups - that'll catch erronious usage just fine
and a generic mechanism's better than a one off hack any day.

This does mean we can't punt on return values, which isn't a bad thing.

Also, if we've got duplicate attributes userspace needs to be able to
figure out which return value was for which attribute.

Two possibilities: one, return values come out in the same order
attributes went in. That'd work, but I dislike the subtlety and I expect
it'd be a pain for userspace.

Instead, let's just stick a u64 cookie in the attribute and include that
in the return, just like we do everywhere else.
