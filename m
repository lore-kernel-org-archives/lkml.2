Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2B0VYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:24:35 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50546 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab2B0VXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:23:20 -0500
Date: Mon, 27 Feb 2012 21:24:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20120227212459.01f50b76@pyramind.ukuu.org.uk>
In-Reply-To: <20120227211748.GB18418@kroah.com>
References: <20120227180601.bc286be07ce32fcf01725410@canb.auug.org.au>
	<20120227211748.GB18418@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012 13:17:48 -0800
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Mon, Feb 27, 2012 at 06:06:01PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the final tree, today's linux-next build (sparc32 defconfig)
> > failed like this:
> > 
> > drivers/tty/vt/keyboard.c: In function 'vt_do_diacrit':
> > drivers/tty/vt/keyboard.c:1500:3: error: implicit declaration of function 'put_user' [-Werror=implicit-function-declaration]
> > drivers/tty/vt/keyboard.c:1502:3: error: implicit declaration of function 'copy_to_user' [-Werror=implicit-function-declaration]
> > drivers/tty/vt/keyboard.c:1545:3: error: implicit declaration of function 'get_user' [-Werror=implicit-function-declaration]
> > drivers/tty/vt/keyboard.c:1556:4: error: implicit declaration of function 'copy_from_user' [-Werror=implicit-function-declaration]
> > 
> > Caused by commit 247ff8e610cb ("vt: lock the accent table") from the tty
> > tree.
> > 
> > I have reverted that patch for today.
> 
> Odd.  Alan, a simple:
> 	#include <linux/uaccess.h>
> in that file should solve this, right?

Yep.. I guess other archs have a lucky include path to it already. Sorry
about that.

Alan
