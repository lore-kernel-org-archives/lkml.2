Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2ALXkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:40:42 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45114 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab2ALXkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:40:39 -0500
Date: Thu, 12 Jan 2012 23:41:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, Arnd Bergmann <arnd@arndb.de>, alan@linux.intel.com,
        linux-serial@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, "3.0 3.1 3.2" <stable@vger.kernel.org>
Subject: Re: [PATCH] TTY: fix UV serial console regression
Message-ID: <20120112234132.0a973cb9@pyramind.ukuu.org.uk>
In-Reply-To: <1326405315-6601-1-git-send-email-jslaby@suse.cz>
References: <4EDE988B.6010501@suse.cz>
	<1326405315-6601-1-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unless there is some bad race in the code, the hardware seems to be
> pretty broken. Otherwise pure MSR read should not cause such a bug,
> or?

UV serial being what actual hardware and system ?

> So to prevent the bug, revert to the old behavior. I.e. read modem
> status only if we really have to -- for non-CLOCAL set serials.
> Non-CLOCAL works on this hardware OK, I tried. See? I don't.

The old behaviour is rather driver dependant eg whether it used
serial_core or not.

Doesn't look an unreasonable change though.

Alan
