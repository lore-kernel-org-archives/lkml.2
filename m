Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311Ab2EJSeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:34:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41901 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760618Ab2EJSef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:34:35 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
Date: Thu, 10 May 2012 11:34:34 -0700
X-Google-Sender-Auth: 7XFtZOupMsigAK4-hwryhkj0G-Y
Message-ID: <CAA9_cmdozzzapZrU2uAiquuquggzMUBficntrJBo5KXV_Q58sA@mail.gmail.com>
Subject: Re: [Bcache v13 00/16]
From: Dan Williams <dan.j.williams@intel.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com,
        Alasdair G Kergon <agk@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 8:07 PM, Kent Overstreet <koverstreet@google.com> wrote:
> bcache: a cache for arbitrary block devices using an SSD.
>
> Short overview:
> Bcache does both writethrough and writeback caching. It presents itself as a
> new block device, a bit like say md. You can cache an arbitrary number of
> block devices with a single cache device, and attach and detach things at
> runtime - it's quite flexible.
>
> It's very fast. It uses a b+ tree for the index, along with a journal to
> coalesce index updates, and a bunch of other cool tricks like auxiliary binary
> search trees with software floating point keys for searching within btree
> nodes.
>
> Bcache is solid, production ready code. There are still bugs being found that
> affect specific configurations, but there haven't been any major issues found
> in awhile - it's well past time I started working on getting it into mainline.
>
> It's a lot of code - I tried to split it out so that it'd make some sort of
> sense for reviewing. Let me know if there's anything else I can do to make
> review easier.
>
> TODO/known issues:
>
> __up_write() needs to be exported for bcache to compile as a module - it's
> used for bypassing lockdep when traversing the btree during garbage
> collection. If someone else knows a better solution, please let me know.
>
> The userspace interface is going to change before it goes in. The general
> consensus at LSF was that we don't want yet another interface for
> probing/managing block devices, and dm exists so we may as well use that. I
> don't think anyone's started on that yet, though.

Might as well mention I've started work on a md conversion.  Nearing
the point of having RFC patches ready to post.

I'm doing it in such a way that it does not preclude a dm target from
coming along as well.  Like I mentioned to Alasdair at LSF, there's no
reason this could not be treated the same as the shared raid
personalities between dm and md.

--
Dan
