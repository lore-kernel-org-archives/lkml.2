Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab1ICKrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 06:47:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35376 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752743Ab1ICKrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 06:47:46 -0400
Date: Sat, 3 Sep 2011 11:46:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, <gregkh@suse.de>,
        <akpm@linux-foundation.org>, <art@ified.ca>, <arnd@arndb.de>,
        <jslaby@suse.cz>
Subject: Re: [PATCH] vt_ioctl.c: fix compile error with pm_set_vt_switch()
Message-ID: <20110903114641.53170fef@lxorguk.ukuu.org.uk>
In-Reply-To: <201109021402.42503.hartleys@visionengravers.com>
References: <201109021402.42503.hartleys@visionengravers.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Sep 2011 14:02:42 -0700
H Hartley Sweeten <hartleys@visionengravers.com> wrote:

> When CONFIG_PM_SLEEP, CONFIG_VT, and CONFIG_VT_CONSOLE are not enabled
> the function pm_set_vt_switch() is defined as an inline in linux/suspend.h. This causes
> a compile error if CONFIG_VT is enabled.
> 
> drivers/tty/vt/vt_ioctl.c:1794: error: redefinition of 'pm_set_vt_switch'
> include/linux/suspend.h:17: error: previous definition of 'pm_set_vt_switch' was here
> 
> Fix this with an #if defined guard around the function in vt_ioctl.c.

Can you put the #if uglies into the buggy suspend.h header instead so the
code proper is kept clean of ifdefs.

Alan
