Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2G0SMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:12:54 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:45074 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab2G0SMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:12:53 -0400
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2012 14:12:53 EDT
Date: Fri, 27 Jul 2012 11:04:19 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>, pv-drivers@vmware.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, vm-crosstalk@vmware.com
Subject: Re: [Pv-drivers] [vmw_vmci 11/11] Apply the header code to make VMCI
 build
Message-ID: <20120727180419.GA8262@dtor-ws.eng.vmware.com>
References: <1343345980-32397-1-git-send-email-astiegmann@vmware.com>
 <1343345980-32397-12-git-send-email-astiegmann@vmware.com>
 <20120727105357.2e40dd10@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120727105357.2e40dd10@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Fri, Jul 27, 2012 at 10:53:57AM +0100, Alan Cox wrote:
> > +enum {
> > +	VMCI_SUCCESS_QUEUEPAIR_ATTACH	=  5,
> > +	VMCI_SUCCESS_QUEUEPAIR_CREATE	=  4,
> > +	VMCI_SUCCESS_LAST_DETACH	=  3,
> > +	VMCI_SUCCESS_ACCESS_GRANTED	=  2,
> > +	VMCI_SUCCESS_ENTRY_DEAD	=  1,
> 
> We've got a nice collection of Linux error codes than you, and it would
> make the driver enormously more readable on the Linux side if as low
> level as possible it started using Linux error codes.

If VMCI was only used on Linux we'd definitely do that; however VMCI
core is shared among several operating systems (much like ACPI is) and
we'd like to limit divergencies between them while conforming to the
kernel coding style as much as possible.

We'll make sure that we will not leak VMCI-specific errors to the
standard kernel APIs.

Thanks,
Dmitry
