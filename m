Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab2IQLMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:12:39 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33018 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab2IQLMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:12:38 -0400
Date: Mon, 17 Sep 2012 12:17:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Advice on mmap() "feature"
Message-ID: <20120917121717.2c99d28f@pyramind.ukuu.org.uk>
In-Reply-To: <505626A8.8040806@mimc.co.uk>
References: <505626A8.8040806@mimc.co.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (a) Since all the mappings have been removed, so why don't the fd's get 
> released ?

Because your code is buggy.

Firstly its files it keeps a reference to not file handles, so your close
closes the file handle. You do however end up with lots of file structs
pinned and that's because you've got a bug.

You map twice as much as you unmap, the kernel therefore keeps the second
half mapped for you. Fix your munmap and all will be happy.

You owe the oracle an ice cream

Alan
