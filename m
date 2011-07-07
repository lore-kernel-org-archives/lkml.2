Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1GGHvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:51:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43357 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752168Ab1GGHvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:51:48 -0400
Date: Thu, 7 Jul 2011 08:53:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@chromium.org>, Olaf Hering <olaf@aepfle.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic, vt: do not force oops output when panic_timeout
 < 0
Message-ID: <20110707085341.200a3c2b@lxorguk.ukuu.org.uk>
In-Reply-To: <20110622223039.GA13916@google.com>
References: <1308612129-12488-1-git-send-email-msb@chromium.org>
	<1308612129-12488-2-git-send-email-msb@chromium.org>
	<20110622223039.GA13916@google.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> a serial port. When I disabled the serial out, my machine started to
> get wedged on a panic. I guess screen_unblank was in bust_spinlocks
> for a reason. It probably bust some spin_locks somewhere.

No something else is wrong here. The console panic should be reliably
breaking the locks but a quick test of taking the console lock and BUG()
on a current kernel shows something has broken this.

> Below is a replacement for this patch which calls screen_unblank but
> does not force output when the panic timeout is negative (no wait).

The on screen console is not always just a vt, and some people log remote
management console output so we really really don't want to do this.

Instead the bug in the lock busting needs fixing. To start with it will
be hiding a ton of other oopses/bugs as hangs.

Alan
