Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab1AMBZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 20:25:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44598 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab1AMBZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 20:25:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=REt8zeRK8oPvfYFq6qJle9ToS4Ecgu58+GiQbFj82Az7Gj6iGhni2i7c+OdATljfOf
         Q3CX6x3zYgxuFlAGqsWLVHpXGOYBgGqZSL5mcyDU/HfVA+4zLz8YQn196QxOFgoyLMaV
         3sNEZ0ZJjO3avFfLNIjRulJyBo36dAx3OP7LA=
MIME-Version: 1.0
In-Reply-To: <1294862680.2971.51.camel@heimdal.trondhjem.org>
References: <29345.1294861630@jrobl>
	<1294862680.2971.51.camel@heimdal.trondhjem.org>
Date: Thu, 13 Jan 2011 12:25:53 +1100
Message-ID: <AANLkTik-AdWpPqmR5TSCuijGwe3XLXm=HYVdUOhK3dDT@mail.gmail.com>
Subject: Re: vfs-scale, chroot
From: Nick Piggin <npiggin@gmail.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 7:04 AM, Trond Myklebust
<Trond.Myklebust@netapp.com> wrote:

> BTW, Nick: Given that some filesystems such as NFS are _always_ going to
> reject LOOKUP_RCU,

That's not very optimistic of you... why is that a given, my I ask?
Or do you just mean as-in the current code?


> it would appear to be completely out of place to use
> the 'unlikely()' keyword when testing the results of path_walk_rcu() and
> friends. In particular when the kernel is running with nfsroot, we're
> saying that 100% of all cases are 'unlikely'...

Well that _is_ an accepted use of branch annotations. For example it
is used when scheduling realtime tasks, because even if some systems
will do 99.9% of their scheduling on realtime tasks, it is not the common
case.

I'm not saying that applies here, but: if path walk performance is
important, then we should use local caching and rcu-walk. If not, then
why do we care about slightly slower branch?

The annotations really help to reduce icache penalty of added
complexity which is why I like them, but I'm happy to remove them
where they don't make sense of course.

Thanks,
Nick
