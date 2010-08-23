Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0HWVRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:17:12 -0400
Received: from tex.lwn.net ([70.33.254.29]:33806 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab0HWVRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:17:10 -0400
Date: Mon, 23 Aug 2010 15:17:08 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>
Subject: Re: [now bisected] i915: 2.6.36-rc2 hoses my Intel display
Message-ID: <20100823151708.6b242599@bike.lwn.net>
In-Reply-To: <20100823110145.08eb72fd@bike.lwn.net>
References: <20100823110145.08eb72fd@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 11:01:45 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> So I decided to fire up -rc2 today to see what would happen...the
> results are best described by the attached images.  Something is
> clearly scrambled between my hardware and the i915 driver.  Display with X
> is hosed, but things go weird before X gets a chance to run (it is worth
> noting that the initial output from the kernel is legible).

I went ahead and bisected the problem, which was added between -rc1 and
-rc2.  The end result is this:

32aad86fe88e7323d4fc5e9e423abcee0d55a03d is the first bad commit
commit 32aad86fe88e7323d4fc5e9e423abcee0d55a03d
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Aug 4 13:50:25 2010 +0100

    drm/i915/sdvo: Propagate errors from reading/writing control bus.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Eric Anholt <eric@anholt.net>

I don't know the driver or the hardware and can't begin to guess what
went wrong in that patch, but, hopefully, the information is useful to
somebody.  Please let me know if there's anything else I can do to help
track this down.

Thanks,

jon
