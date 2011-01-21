Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1AURS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:18:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48559 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1AURSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:18:25 -0500
Date: Fri, 21 Jan 2011 15:18:57 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@ti.com>
Subject: Re: [RFC 0/2] remove BT references from TI_ST
Message-ID: <20110121171857.GC2400@joana>
References: <1294138788-10307-1-git-send-email-pavan_savoy@ti.com>
 <AANLkTinPC-i2xi9pCQ-RzGWuwZ5uTM3NXG7y6gwTnPYv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinPC-i2xi9pCQ-RzGWuwZ5uTM3NXG7y6gwTnPYv@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

* Pavan Savoy <pavan_savoy@sify.com> [2011-01-19 23:56:29 +0530]:

> Gustavo,
> 
> On Tue, Jan 4, 2011 at 4:29 PM,  <pavan_savoy@ti.com> wrote:
> > From: Pavan Savoy <pavan_savoy@ti.com>
> >
> > Gustavo,
> >
> > Based on your comments, that the underlying shared transport driver
> > for btwilink driver made use of the BT references to peek into the packets
> > I have modified the TI_ST.
> 
> Since there lacks a generic way to parse the packets coming in from the
> UART into BT, FM or GPS, we have to look into the data to fragment assembled
> data or assemble fragmented data.
> 
> Please have a look, Please suggest whether something like this is required,
> If not, please also suggest, if including BT headers is a problem ?

Not really. The real problem is to break the abstraction between drivers
layers (core and bluetooth drivers in this case)

> 
> Because I just include the BT headers and don't have a build
> dependency as such on
> BT/HCI and don't use any functions from hci_core in my shared transport driver.
> 
> > For this reason, Now the above lying protocol drivers like BT, FM and GPS
> > would send details about their packet types and header information which
> > would assist shared transport driver to parse the data.

Fair enough. This new approach is way better.

> >
> > Gustavo, please also notice the change in btwilink driver in and around,
> > st_register and suggest if something like this is OK.
> > btwilink can also be modified to send in all the packet specific data
> > in one shot, if that is preferred.
> >
> > Please review and provide comments..
> >
> > Note:
> > If this is alright, I will send out a modified patch with updated
> > subject to lkml/Greg for linux-next.

Ok. Go ahead. Then tell me when I'll be able to apply your patch. (I need to
have the core modifications in my tree first). Or I just ack the patch and it
finds its way to mainline through Greg's tree.

-- 
Gustavo F. Padovan
http://profusion.mobi
