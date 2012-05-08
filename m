Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab2EHJca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:32:30 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34403 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2EHJc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:32:29 -0400
Date: Tue, 8 May 2012 10:35:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: Regression due to d29f3ef "tty_lock: Localise the lock"
Message-ID: <20120508103512.42db1c4b@pyramind.ukuu.org.uk>
In-Reply-To: <4FA8557E.5080402@wwwdotorg.org>
References: <4FA8557E.5080402@wwwdotorg.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 May 2012 17:06:38 -0600
Stephen Warren <swarren@wwwdotorg.org> wrote:

> Alan,
> 
> Commit d29f3ef "tty_lock: Localise the lock" appears to cause a problem
> for me.
> 
> With this commit (as in next-20120507), I can no longer log into my
> system (NVIDIA Tegra device with ARM CPU) over the serial console, since
> the login prompt no longer appears. If I wait a few minutes, I see the
> following console spew:

Eep. If it's reproducable can you test whether adding the unlock/relock
in drivers/tty/pty.c does the trick ?


ie:
	tty_unlock(tty);
	tty_vhangup(tty);
	tty_lock(tty);

or if changing it for tty_hangup(tty) does it.


There's some kind of lurking circular locking deadlock that I've not
managed to trigger here but a couple of reports point towards.
