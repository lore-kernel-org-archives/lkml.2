Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0CVMFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:05:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab0CVMFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:05:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100320111938.GT5331@bicker>
References: <20100320111938.GT5331@bicker>
To: Dan Carpenter <error27@gmail.com>
Cc: dhowells@redhat.com, kernel-janitors@vger.kernel.org,
       linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] afs: potential null dereference
Date: Mon, 22 Mar 2010 12:05:20 +0000
Message-ID: <28809.1269259520@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <error27@gmail.com> wrote:

> It seems clear from the surrounding code that xpermits is allowed to be 
> NULL here.

Interesting.  The memcpy() won't oops due to this because if it is given a
NULL pointer, it will also be given a zero count.  I wonder if this means the
if-statement your patch adds is actually unnecessary...

David
