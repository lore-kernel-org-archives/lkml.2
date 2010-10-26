Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab0JZOs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:48:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58625 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751219Ab0JZOsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:48:55 -0400
Date: Tue, 26 Oct 2010 15:48:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: #ifdef CONFIG_ checks not working
Message-ID: <20101026154800.18c5cfe6@lxorguk.ukuu.org.uk>
In-Reply-To: <47266B0D-0A99-4C5F-BA85-FCC8986E8862@mac.com>
References: <47266B0D-0A99-4C5F-BA85-FCC8986E8862@mac.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010 18:28:22 +0400
Elvis Dowson <elvis.dowson@mac.com> wrote:

> Hi,
>        I just noticed that with the 2.6.36-rc8 kernel, the #ifdef checks aren't working. 

They seem to be working fine

> So for example, if I add the following code fragment in my omap3_beagle_init function, CONFIG_WL1271 doesn't get detected, even though in my .config file, CONFIG_WL1271=m.

You are checking for Y/N not for modular (check how other drivers check
for both)

> Would you happen to know why this is not working. This type of checks used to work with the 2.6.32 kernel versions.
> 
> #ifdef CONFIG_WL1271
>     printk(KERN_INFO "%s: CONFIG_WL1271 detected\n", __func__);
> #else
>     printk(KERN_INFO "%s: CONFIG_WL1271 not detected\n", __func__);
> #endif

The code looks wrong anyway - if you didn't compile it in then presumably
you *did* detect it but didn't have a driver ?

Alan
