Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2HJSWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 14:22:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40954 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759779Ab2HJSWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 14:22:30 -0400
Date: Fri, 10 Aug 2012 19:26:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond.Myklebust@netapp.com, davem@davemloft.net,
        linux-nfs@vger.kernel.org, eric.dumazet@gmail.com, xemul@parallels.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, viro@zeniv.linux.org.uk,
        tim.c.chen@linux.intel.com, devel@openvz.org
Subject: Re: [RFC PATCH 0/2] net: connect to UNIX sockets from specified
 root
Message-ID: <20120810192628.79a34d28@pyramind.ukuu.org.uk>
In-Reply-To: <50254FA6.3060806@zytor.com>
References: <20120810125701.7115.71612.stgit@localhost.localdomain>
	<50254FA6.3060806@zytor.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On that whole subject...
> 
> Do we need a Unix domain socket equivalent to openat()?

I don't think so. The name is just a file system indexing trick, it's not
really the socket proper. It's little more than "ascii string with
permissions attached" - indeed we also support an abstract name space
which for a lot of uses is actually more convenient.

AF_UNIX between roots raises some interesting semantic questions when you
begin passing file descriptors down them as well.

Alan
