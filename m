Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2KVSrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:47:07 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36289 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab2KVSrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:47:05 -0500
Date: Wed, 21 Nov 2012 21:30:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Andrew McGregor <andrew.mcgregor@alliedtelesis.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: Add driver unthrottle in ioctl(...,TCFLSH,..).
Message-ID: <20121121213037.154306da@pyramind.ukuu.org.uk>
In-Reply-To: <50AD43DB.4030800@ilyx.ru>
References: <50AD43DB.4030800@ilyx.ru>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Function reset_buffer_flags() also invoked during the
> ioctl(...,TCFLSH,..). At the time of request we can have full buffers
> and throttled driver too. If we don't unthrottle driver, we can get
> forever throttled driver, because after request, we will have
> empty buffers and throttled driver and there is no place to unthrottle driver.
> It simple reproduce with "pty" pair then one side sleep on tty->write_wait,
> and other side do ioctl(...,TCFLSH,..). Then there is no place to do writers wake up.


So instead of revertng it why not just fix it ? Just add an argument to
the reset_buffer_flags function to indicate if unthrottling is permitted.

Alan
