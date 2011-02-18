Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab1BRIPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:15:49 -0500
Received: from symlink.to.noone.org ([85.10.207.172]:53270 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756241Ab1BRIPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 03:15:47 -0500
Date: Fri, 18 Feb 2011 09:15:46 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Chou <thomas@wytron.com.tw>, nios2-dev@sopc.et.ntust.edu.tw,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [Nios2-dev] [PATHV v2] tty: serial: altera_uart: Add
	devicetree support
Message-ID: <20110218081546.GC759@distanz.ch>
References: <c7a7085602687d2f1b6ac505c030f19bafda04e3.1297245277.git.tklauser@distanz.ch> <1297872732-10207-1-git-send-email-tklauser@distanz.ch> <4D5C86C1.8070404@wytron.com.tw> <20110217074846.GG4076@distanz.ch> <4D5DCB46.9090506@wytron.com.tw> <AANLkTinDD71YQbYovBSwU8YSCCZ56wQf35X97WFoY6R9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinDD71YQbYovBSwU8YSCCZ56wQf35X97WFoY6R9@mail.gmail.com>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-18 at 09:08:53 +0100, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, Feb 17, 2011 at 6:28 PM, Thomas Chou <thomas@wytron.com.tw> wrote:
> > On 02/17/2011 03:48 PM, Tobias Klauser wrote:
> >>>>
> >>>> +       ret = altera_uart_get_of_uartclk(pdev, port);
> >>>> +       if (ret&&   platp)
> >>>> +               port->uartclk = platp->uartclk;
> >>>> +       else if (ret)
> >>>> +               return ret;
> >>>> +
> >>>
> >>> Better reverse the priority, with platform data checked first.
> >>>
> >>>        if (platp)
> >>>                port->uartclk = platp->uartclk;
> >>>        else {
> >>>                ret = altera_uart_get_of_uartclk(pdev, port);
> >>>                if (ret)
> >>>                        return ret;
> >>>        }
> >>
> >> Do you have a specific reasoning for this? I thought it might make sense
> >> to do it in the same order as with the resources above, but I have no
> >> problem changing it to the way you suggest.
> >
> > Not quite sure. But I see some drivers follow this order, and I just
> > followed, too.
> 
> The reason to check for platform_data first is that if a device has
> *both* platform data and a device node pointer, then more than likely
> the platform_data is indented to override the device node data.

Thanks Grant and Thomas for the explanation. I was just wondering. I'll
send an updated patch including the changes suggested by Thomas.

Tobias
