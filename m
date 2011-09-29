Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab1I2IXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:23:36 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:53078 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1I2IXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:23:34 -0400
Subject: Re: [PATCH v5]: Improve performance of LZO hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Thu, 29 Sep 2011 18:23:32 +1000
In-Reply-To: <CAOJsxLGUmV=5+fOJShbfc+kELcPS9pnE+DkNY9+TBS33VmzRFg@mail.gmail.com>
References: <1317183650.2067.10.camel@shrek.rexursive.com>
	 <CAOJsxLGam5htmwtTZOuPka02+CZ1Fkv1b+SuYMJ8x9VRntFzRQ@mail.gmail.com>
	 <1317194947.1998.18.camel@shrek.rexursive.com>
	 <CAOJsxLFGpU53AQRw-nKsz_Lz_QMDP+RDUD5J3bYzbAA_+ngaAA@mail.gmail.com>
	 <1317196456.1998.24.camel@shrek.rexursive.com>
	 <CAOJsxLGUmV=5+fOJShbfc+kELcPS9pnE+DkNY9+TBS33VmzRFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317284612.1956.5.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 16:02 +0300, Pekka Enberg wrote:
> On Wed, Sep 28, 2011 at 10:54 AM, Bojan Smojver <bojan@rexursive.com> wrote:
> > I'm guessing here that you mean that parts of the kernel other than
> > hibernation code itself can do this (i.e. set the flag for the thread to
> > stop, so kthread_should_stop() returns true). Correct?
> 
> Sorry, I'm not familiar this code. However, if you're checking for the
> condition..
> 
> [snip]
> 
> > Right now, this would result in - well I don't know what exactly - most
> > likely corrupted data on disk or on memory.
> 
> ...this is not really an option for handling it.

I think we should be good with v7. If anyone called kthread_stop(),
error codes will be set. And we discard hibernation/thaw attempt based
on errors coming from compression/decompression threads.

In terms of thread pointer becoming a dangling one, I don't think that's
a worry. I see many instances of kthread_stop() throughout the kernel
code and none of them worry themselves with the pointer being bad.

I may still have v8, with some variable name cleanups and some redundant
code taken out.

-- 
Bojan

