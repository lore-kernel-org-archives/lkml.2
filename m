Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab0JTS4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:56:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069Ab0JTS4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:56:33 -0400
Date: Wed, 20 Oct 2010 11:56:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>
Subject: Re: kfifo must_check warning (+ patch)
Message-Id: <20101020115608.996a9db4.akpm@linux-foundation.org>
In-Reply-To: <20101020193702.584f2c9a@lxorguk.ukuu.org.uk>
References: <20101019151048.ae79bb25.randy.dunlap@oracle.com>
	<20101019221242.c732e1fa.akpm@linux-foundation.org>
	<20101020094659.091113f5.randy.dunlap@oracle.com>
	<20101020193702.584f2c9a@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 19:37:02 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Some versions of gcc mysteriously report:
> > drivers/char/n_gsm.c:1580: warning: ignoring return value of '__kfifo_must_check_helper', declared with attribute warn_unused_result
> > 
> > This warning can be eliminated by using a local variable for the
> > returned result value, as suggested by Andrew Morton.
> 
> But that just hides the bug in the helper surely - the helper has type
> errors so needs fixing - not this. If you apply this then the underlying
> bug is just going to get forgotten
> 

It won't get forgotten.

I agree that the warning is probably an artifact of the signedness
thing.  So for 2.6.36, disabling __kfifo_must_check_helper() will
suffice.  I'm sure that Stefani will fix up __kfifo_must_check_helper()
for real for 2.6.37, then we can see if the warning reoccurs.
