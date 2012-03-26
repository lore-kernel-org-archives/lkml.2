Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349Ab2CZSmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:42:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34859 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147Ab2CZSmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:42:22 -0400
Date: Mon, 26 Mar 2012 11:42:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 0/6] firmware_class: Fix problems with usermodehelper test
Message-ID: <20120326184217.GC29332@kroah.com>
References: <201203032122.36745.chunkeey@googlemail.com>
 <201203191225.00199.rjw@sisk.pl>
 <201203200000.43316.rjw@sisk.pl>
 <201203260000.34377.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203260000.34377.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 12:00:34AM +0200, Rafael J. Wysocki wrote:
> Hi all,
> 
> The following series of patches fixes two problems with
> request_firmware() and request_firmware_nowait() resulting from commit
> a144c6a6c924aa1da04dd77fb84b89927354fdff
> 
>     PM: Print a warning if firmware is requested when tasks are frozen
> 
> The first problem is that request_firmware_nowait() may fail if it happens
> to run in parallel with system suspend.  It should't fail in such situations
> and that is addressed by the first three patches (that code has been discussed
> with Linus at al already).
> 
> The second issue is that request_firmware() may be called in a thread which
> isn't related to system suspend and if suspend happens exactly at that time,
> request_firmware() will fail (and print a scary warning), although it shouldn't.
> This problem is addressed by the remaining three patches, which are new.

At first glance, they all look good to me, thanks for doing this work:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm guessing this will go in through one of your trees, right?

thanks,

greg k-h
