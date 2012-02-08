Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab2BHJY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 04:24:58 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46718 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2BHJY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 04:24:56 -0500
Date: Wed, 8 Feb 2012 09:26:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] char/mem: Add /dev/io (v2)
Message-ID: <20120208092611.49ada8c5@pyramind.ukuu.org.uk>
In-Reply-To: <4F31C417.30502@redhat.com>
References: <1328623901-20628-1-git-send-email-ajax@redhat.com>
	<1328657985-13942-1-git-send-email-ajax@redhat.com>
	<20120208001724.7e5c7be4@pyramind.ukuu.org.uk>
	<4F31C417.30502@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, I'll be sure to do that right as soon as I can stop supporting the 
> vesa driver.  Until that time I don't really have any choice but to 
> expose the whole of I/O port space, since I have no idea what the video 
> BIOS is going to touch.

I would be surprised if you couldn't make a very good guess, and many
things it might want to touch are things that need blocking/emulating
anyway.

> I don't disagree with wanting to limit access to these services, but 
> /dev/io is at least somewhat containable, whereas iopl is insane.

They are both equally insane and have effectively identical security
semntics. Continuing to use iopl is both faster and avoids adding a kernel
API however. Even better it's x86 specific so that piece of manure
doesn't escape onto other platforms without the legacy vesa mess.

Alan
