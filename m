Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978Ab2HJShM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 14:37:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40979 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab2HJShH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 14:37:07 -0400
Date: Fri, 10 Aug 2012 19:40:28 +0100
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
Message-ID: <20120810194028.792f29f1@pyramind.ukuu.org.uk>
In-Reply-To: <5025537D.9060300@zytor.com>
References: <20120810125701.7115.71612.stgit@localhost.localdomain>
	<50254FA6.3060806@zytor.com>
	<20120810192628.79a34d28@pyramind.ukuu.org.uk>
	<5025537D.9060300@zytor.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > AF_UNIX between roots raises some interesting semantic questions when
> > you begin passing file descriptors down them as well.
> 
> Why is that?  A file descriptor carries all that information with it...

Things like fchdir(). It's not a machine breaking problem but for
containers as opposed to chroot we need to be clear what the expected
isolation sematics are.

Agreed on open() for sockets.. the lack of open is a Berklix derived
pecularity of the interface. It would equally be useful to be able to
open "/dev/socket/ipv4/1.2.3.4/1135" and the like for scripts and stuff

That needs VFS changes however so you can pass the remainder of a path to
a device node. It also lets you do a lot of other sane stuff like

	open /dev/ttyS0/9600/8n1


