Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1I1HyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:54:18 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:54658 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1I1HyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:54:17 -0400
Subject: Re: [PATCH v5]: Improve performance of LZO hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 28 Sep 2011 17:54:16 +1000
In-Reply-To: <CAOJsxLFGpU53AQRw-nKsz_Lz_QMDP+RDUD5J3bYzbAA_+ngaAA@mail.gmail.com>
References: <1317183650.2067.10.camel@shrek.rexursive.com>
	 <CAOJsxLGam5htmwtTZOuPka02+CZ1Fkv1b+SuYMJ8x9VRntFzRQ@mail.gmail.com>
	 <1317194947.1998.18.camel@shrek.rexursive.com>
	 <CAOJsxLFGpU53AQRw-nKsz_Lz_QMDP+RDUD5J3bYzbAA_+ngaAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317196456.1998.24.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 10:48 +0300, Pekka Enberg wrote:
> > The compression/decompression threads stop by breaking out of the
> loop.
> > At least they should, right? Did I misread some docs here?
> 
> Yes, the threads are stopped. What happens after that? Will the
> hibernation process be aborted? How can this be tested? 

I'm guessing here that you mean that parts of the kernel other than
hibernation code itself can do this (i.e. set the flag for the thread to
stop, so kthread_should_stop() returns true). Correct?

If that is a possibility (which I didn't take into account at all), I
will need to rewrite so that if such a thing happens, we abort the
hibernation process. It should not be difficult.

Right now, this would result in - well I don't know what exactly - most
likely corrupted data on disk or on memory.

-- 
Bojan

