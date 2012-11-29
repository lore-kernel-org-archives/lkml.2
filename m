Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2K2Nge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:36:34 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45920 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2K2Ngd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:36:33 -0500
Date: Thu, 29 Nov 2012 13:41:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/tty: drivers/char/:  for
 MAX_ASYNC_BUFFER_SIZE
Message-ID: <20121129134136.36cbf936@pyramind.ukuu.org.uk>
In-Reply-To: <50B6ED90.6060100@asianux.com>
References: <50B6E751.9000000@asianux.com>
	<50B6ED90.6060100@asianux.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 13:07:28 +0800
Chen Gang <gang.chen@asianux.com> wrote:

> Hello Greg Kroah-Hartman:
> 
> for MAX_ASYNC_BUFFER_SIZE:
>   it is defined as 4096;
>   but for the max buffer size which it processes, is 65535.
>   so suggest to #define MAX_ASYNC_BUFFER_SIZE 0x10000  (better than 0xffff)

I don't see the need to change this. Possibly some of the old synclink
drivers need to check more carefully for overflows if configured for very
large frame sizes ?

> 
> ---------------------------------------------------------------------------------
> Step 3:
> 
> one sample in drivers/tty/n_gsm.c  (same for another implementation)
> 
>   receive_buf is a function ptr which may be gsmld_receive_buf at line 2819. 
>   it does not check the length of count whether larger than MAX_ASYNC_BUFFER_SIZE.
>   if count is larger than MAX_ASYNC_BUFFER_SIZE, will cause issue.

Why should it - MAX_ASYNC_BUFFER_SIZE is an internal detail of the
synclink drivers. 

Alan
