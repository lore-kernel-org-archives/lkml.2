Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2BHARM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:17:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59312 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2BHARK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:17:10 -0500
Date: Wed, 8 Feb 2012 00:17:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] char/mem: Add /dev/io (v2)
Message-ID: <20120208001724.7e5c7be4@pyramind.ukuu.org.uk>
In-Reply-To: <1328657985-13942-1-git-send-email-ajax@redhat.com>
References: <1328623901-20628-1-git-send-email-ajax@redhat.com>
	<1328657985-13942-1-git-send-email-ajax@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Feb 2012 18:39:45 -0500
Adam Jackson <ajax@redhat.com> wrote:

> This is like /dev/port except not broken.  /dev/port will translate all
> read/write into inb/outb streams, which is wrong since hardware can and
> does care about cycle size.  /dev/io will only allow 1, 2, or 4 byte
> access, and will translate that into the appropriate bus cycle size.

>From a security perspective /dev/[k][mem is a dumb bit of ancient Unix
history we'd dearly like to kill off. /dev/port is a similar early PC
unixism that wants to go the same way. /dev/io just adds another horror
to the pile.

Please do the decent thing, stop using /dev/mem and /dev/port for
anything. If you need to access an I/O device make it properly visible
via the kernel only for the ports and in a manner that is safe.

Alan
