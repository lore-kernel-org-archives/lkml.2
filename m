Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab0LVWcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 17:32:31 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54409 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0LVWca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 17:32:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LmgbrliMxajzIFdTfXid9xSjys8t/L+Xa+DpS6vWTOy6+NFUOCRIUdq5yOZbzjqWCo
         xMDvtrOg0zBjF6A9jvRmOQnArQegOA3xJ1PVe2vyrGaHwt10AigON15FEXhEXVfClUKH
         l/gGeJr+wk69rh44MR5PFrpbLbBVEul98g42E=
MIME-Version: 1.0
In-Reply-To: <20101222213403.GP1263@parisc-linux.org>
References: <20101221233942.GL1263@parisc-linux.org>
	<4D1266F5.8040702@am.sony.com>
	<20101222213403.GP1263@parisc-linux.org>
Date: Wed, 22 Dec 2010 14:32:29 -0800
Message-ID: <AANLkTin=C=Srtfx=S+d0_7BeK-akebVxg9F39jehX3S6@mail.gmail.com>
Subject: Re: [PATCH] Prevent users from disabling tickless
From: Frank Rowand <frank.rowand@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Frank Rowand <frank.rowand@am.sony.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 1:34 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>
> On Wed, Dec 22, 2010 at 01:00:37PM -0800, Frank Rowand wrote:
> > Why remove the ability to make the configuration choice?  Why not
> > just add the info about performance impact to the help text and
> > let me shoot myself in the foot (that is the unix way (tm)) if
> > I desire to?
>
> $ wc -l .config
> 2601 .config
>
> It's too hard to get every single config option right ... unless it's a
> works / doesn't work choice, having a "make my performance suck" config
> option is a bad idea.

(And yet one more duplicate, because lkml rejected my previous reply. Sorry!!)
(sorry for the duplicate, I dropped the cc's on my previous reply)

Agreed that setting config options can be painful!

Various options that improve performance for your system  can negatively impact
the performance of systems and applications that are different than your system.
On some of my real time systems, CONFIG_NO_HZ=y results in larger maximum
interrupts disabled values, meaning larger real time latency.

For the option in question, would it be sufficient to just add
"default y", so that the
common case gets the correct value, but the value remains configurable?

-Frank
