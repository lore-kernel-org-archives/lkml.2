Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab1LWOun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 09:50:43 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58080 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1LWOul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:50:41 -0500
Date: Fri, 23 Dec 2011 14:50:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "John Stoffel" <john@stoffel.org>
Cc: Gaurav Saxena <grvsaxena419@gmail.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Intercepting system calls
Message-ID: <20111223145014.4bb74f30@pyx>
In-Reply-To: <20211.28256.111279.27933@quad.stoffel.home>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
	<CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
	<CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
	<20211.28256.111279.27933@quad.stoffel.home>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Write a FUSE module to mount the filesystem through, inside your FUSE
> module you can intercept the unlink/truncate/write calls and decide
> what you want to have happen.

Using fanotify and/or a custom security module (or selinux rules) might
well also be a cleaner way to do it, depending what is actually intended.

Trying to do stuff like archive 'old versions' isn't just about unlink
however because many programs update the inplace file rather than
unlink/replace.
