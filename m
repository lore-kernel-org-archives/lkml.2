Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab2K1MEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 07:04:38 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43919 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab2K1MEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 07:04:37 -0500
Date: Wed, 28 Nov 2012 12:08:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Yangbin (Robin)" <robin.yb@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fs@vger.kernel.org" <linux-fs@vger.kernel.org>
Subject: Re: A question about proc file system
Message-ID: <20121128120855.53181bb2@pyramind.ukuu.org.uk>
In-Reply-To: <27C64424A5A15E448C64C14B9C9BC079112E05A3@szxeml526-mbx.china.huawei.com>
References: <27C64424A5A15E448C64C14B9C9BC079112E05A3@szxeml526-mbx.china.huawei.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 02:55:30 +0000
"Yangbin (Robin)" <robin.yb@huawei.com> wrote:

> Hi all:
> 
> 	I write a kernel module which make a dir and create a file in proc file system. 
> I use proc_mkdir() and create_proc_entry() in init and use remove_proc_entry() in exit.
> Now I got a problem during my test:
> 1. open terminal A, insmod and cd into the dir the module created in proc
> 2. open terminal B. rmmod and insmod angain.
> Then I cannot see the file which should be created by the module, unless terminal A quit the dir.
> 
> This will be ok with regale file system like ext3, one teminal's operation will not affert others.
> Is this a bug or not?

It's not. You are doing the same as this


	mkdir /tmp/example
	cd /tmp/example
	rmdir /tmp/example

	mkdir /tmp/example

in Unix like systems the file handles and current directory references
apply to the object itself not to the path.

When yo reload the driver you create a new and different directory that
has the same name but is not the same thing.

