Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1KNQHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 11:07:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58757 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799Ab1KNQHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 11:07:14 -0500
Date: Mon, 14 Nov 2011 16:08:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH v3 2/2] TTY: tty flip buffer optimisation.
Message-ID: <20111114160814.2f9de9a9@lxorguk.ukuu.org.uk>
In-Reply-To: <4EC137F6.1050509@ilyx.ru>
References: <4EC10DC6.8070807@ilyx.ru>
	<4EC124EB.4050203@suse.cz>
	<20111114150523.2abdf7a1@lxorguk.ukuu.org.uk>
	<4EC137F6.1050509@ilyx.ru>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For avoid complexity we need remove free buffer at all.
> And use kmalloc()-kfree() for every chunk. Don't need tty_buffer_find().
> It will be fast and easy.

The buffer cycling was added because it speeds up some cases (as you
found), and because its needed for high speed serial on some very low end
devices. From your benchmarks it's also speeding up pty/tty so it's
clearly relevant.

Alan
