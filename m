Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0DNMuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 08:50:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53540 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750715Ab0DNMuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 08:50:08 -0400
Date: Wed, 14 Apr 2010 13:53:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: add HP Compaq 2710p to 'noloop' table
Message-ID: <20100414135350.3b1643c2@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LNX.2.00.1004141437340.8345@pobox.suse.cz>
References: <alpine.LNX.2.00.1004141409450.8345@pobox.suse.cz>
	<20100414123643.GB9242@srcf.ucam.org>
	<alpine.LNX.2.00.1004141437340.8345@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 14:41:11 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 14 Apr 2010, Matthew Garrett wrote:
> 
> > On Wed, Apr 14, 2010 at 02:16:25PM +0200, Jiri Kosina wrote:
> > > +		.matches = {
> > > +			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> > > +			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 2710p (#ABD)"),
> > > +			DMI_MATCH(DMI_PRODUCT_VERSION, "F.14"),
> > 
> > Is this really the only BIOS version affected? It seems unlikely. 
> 
> I don't know, it's the only one I have received the report against (I 
> don't own the machine myself).
> 
> > It's also a pretty good indication that we're doing something wrong.
> 
> What do you mean exactly?
> 
> Sending AUX_LOOP is valid thing to do with i8042 controller. If it causes 
> such confusion that the controller doesn't function properly any more, 
> it's clearly broken.

You are assuming there is anything resembling an i8042 in the system.
There may not be, and even if there is there may be SMM code running in
front of it.

It's not really that unlikely that an AUX handling bug exists and only on
one BIOS version given we've seen things as neat as i8042 emulation that
only works on CPU #0 8)

Alan
