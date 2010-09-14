Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0INTb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:31:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40546 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753483Ab0INTb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:31:57 -0400
Date: Tue, 14 Sep 2010 20:52:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        kumar.gala@freescale.com, amit.shah@redhat.com
Subject: Re: [PATCH] hvc_console: fix dropping of characters when output
 byte channel is full
Message-ID: <20100914205246.0e35c9af@lxorguk.ukuu.org.uk>
In-Reply-To: <4C8FCC2E.1020107@freescale.com>
References: <1282329921-24394-1-git-send-email-timur@freescale.com>
	<20100914121721.c8671ed8.akpm@linux-foundation.org>
	<20100914204410.71942cdc@lxorguk.ukuu.org.uk>
	<4C8FCC2E.1020107@freescale.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 14:25:34 -0500
Timur Tabi <timur@freescale.com> wrote:

> Alan Cox wrote:
> > Its a printk handler - better to lose the bytes than hang the box. I
> > think the current code is probably right.
> 
> What do you think about this change:
> 
> http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-October/thread.html#76830
> 
> This is the original version of my patch.  In it, I simply allow drivers to
> return 0 to indicate that they're too busy to accept data.  It works great
> on the hvc driver that we have in-house today, but it might break other
> drivers that return 0 to indicate error.

If you want to make that change then I guess you need to audit every
other hvc driver first.

But I never understood the point of the hvc layer anyway 8)
