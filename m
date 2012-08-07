Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2HGKJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 06:09:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34944 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2HGKJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 06:09:10 -0400
Date: Tue, 7 Aug 2012 11:13:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russ Gorby <russ.gorby@intel.com>
Subject: Re: [PATCH] serial: ifx6x60: fix paging fault on
 spi_register_driver
Message-ID: <20120807111339.4a369066@pyramind.ukuu.org.uk>
In-Reply-To: <20120807051247.GA24140@localhost>
References: <20120807051247.GA24140@localhost>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Aug 2012 13:12:47 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> [  117.240866] BUG: unable to handle kernel paging request at 815b627c
> [  117.240866] IP: [<813fe94b>] spi_register_driver+0xb/0x50
> ...
> [  117.240866] Call Trace:
> [  117.240866]  [<817de977>] ifx_spi_init+0xbe/0xf0
> 
> The root cause is, spi_register_driver() is trying to write into the
> passed *const* struct spi_driver.
> 
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Acked-by: Alan Cox <alan@linux.intel.com>
