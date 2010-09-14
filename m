Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0INTXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:23:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51469 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753533Ab0INTXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:23:32 -0400
Date: Tue, 14 Sep 2010 20:44:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Timur Tabi <timur@freescale.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        kumar.gala@freescale.com, amit.shah@redhat.com
Subject: Re: [PATCH] hvc_console: fix dropping of characters when output
 byte channel is full
Message-ID: <20100914204410.71942cdc@lxorguk.ukuu.org.uk>
In-Reply-To: <20100914121721.c8671ed8.akpm@linux-foundation.org>
References: <1282329921-24394-1-git-send-email-timur@freescale.com>
	<20100914121721.c8671ed8.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, hvc_push() reschedules.  It doesn't sit in a tight loop burning
> electrons!
> 
> Can we do something safer&smarter here?


Its a printk handler - better to lose the bytes than hang the box. I
think the current code is probably right.
