Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab2GTJox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:44:53 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41513 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2GTJou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:44:50 -0400
Date: Fri, 20 Jul 2012 10:48:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] tty: handle NULL parameters in free_tty_struct()
Message-ID: <20120720104831.47cb4237@pyramind.ukuu.org.uk>
In-Reply-To: <20120720070634.GC11710@elgon.mountain>
References: <20120720070634.GC11710@elgon.mountain>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2012 10:06:34 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> We sometimes pass NULL pointers to free_tty_struct().  One example where
> it can happen is in the error handling code in pty_common_install().
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Alan Cox <alan@linux.intel.com>

We probably shouldn't be passing NULLs there but making
free_tty_struct(NULL) a no-op matches the kfree and other behaviours and
is robust.
