Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2GZPow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:44:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2GZPou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:44:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120726122016.GD30717@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-9-git-send-email-ming.lei@canonical.com>
	<20120725160425.GK11152@aftab.osrc.amd.com>
	<CACVXFVO5HHFraBXsV2S_a_KUrBg3ffyO0qqaGCjzq8Rksr9KaA@mail.gmail.com>
	<20120726122016.GD30717@aftab.osrc.amd.com>
Date: Thu, 26 Jul 2012 23:44:48 +0800
Message-ID: <CACVXFVMxUKezcR5BBv6jM0wZr8UivF7dJGe1gLNiFx=1h4U59g@mail.gmail.com>
Subject: Re: [RFC PATCH 08/13] driver core: firmware loader: fix device lifetime
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 8:20 PM, Borislav Petkov <bp@amd64.org> wrote:
>
> Ok, here's what I got from looking at the patch:
>
> Your commit message says: "Also request_firmware_nowait should be called
> in atomic context now, so fix the obsolete comments."
>
> Atomic context in my book means you're not allowed to sleep at all.

In fact, I mean the function can be called in atomic context now, and
I know some time ago the function will create kthread to execute
the request_firmware, and atomic context is not allowed.

So I remove the obsolete comment.

>
> But the comment says that it is possible to sleep a little. This is very
> wrongly formulated AFAICT.

The function can be run in both contexts, and I don't see any words which
says the function will sleep.

>
> But, since request_firmware_nowait receives a GFP mask as one of its
> arguments and some of its callers don't supply GFP_ATOMIC then this
> has nothing to do with atomic contexts at all. Then, you should simply
> explain in the comment why exactly callers aren't allowed to be sleeping
> for a long time. And using adjectives like "long" or "short" is very
> misleading in such explanations so please be more specific as to why the

It is the original one, and I don't think it is wrong. Also it
shouldn't be covered
by this patch.

Maybe I shouldn't have fixed the comment in this patch.


Thanks,
--
Ming Lei
