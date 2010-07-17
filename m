Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122Ab0GQTEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 15:04:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52971 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760103Ab0GQTEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 15:04:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TozD/uJPByLwK5+1/pxBZgf8kYKtI6kGAK9eAZsJBJmuRfngw0SvB8c4zTpOg3ZaUY
         bP+SxYV1vI547p6LGHu3bQw1G7wmj320sRnA6FiAu1eWuF5O9H4RrhbBbtZPx2ljtsK9
         joYv4mzMypWKuoGyQgiQDBzApNdxNEZqNz728=
MIME-Version: 1.0
In-Reply-To: <201007142304.48660.rjw@sisk.pl>
References: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>
	<201007142304.48660.rjw@sisk.pl>
Date: Sat, 17 Jul 2010 21:04:05 +0200
Message-ID: <AANLkTin5Bj6HEEriLVFDQKptrZHmh698TsnMWHzVYt5H@mail.gmail.com>
Subject: Re: 2.6.35-rc5 inconsistent lock state
From: Dan Carpenter <error27.lkml@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Martin Pirker <lkml.collector@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>, mjg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is from:

commit 31373d09da5b7fe21fe6f781e92bd534a3495f00
Author: Matthew Garrett <mjg@redhat.com>
Date:   Tue Apr 6 14:25:14 2010 +0200

    laptop-mode: Make flushes per-device

    One of the features of laptop-mode is that it forces a writeout of dirty
    pages if something else triggers a physical read or write from a device.
    The current implementation flushes pages on all devices, rather than only
    the one that triggered the flush. This patch alters the behaviour so that
    only the recently accessed block device is flushed, preventing other
    disks being spun up for no terribly good reason.

One way to fix it might be to change all the places that call
spin_lock(&bdi->wb_lock); to spin_lock_bh(&bdi->wb_lock); but I'm not
sure that's the right way.

I don't think Matthew Garrett has a bugzilla account?
