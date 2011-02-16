Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab1BPMHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:07:20 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36435 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964Ab1BPMHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:07:18 -0500
Date: Wed, 16 Feb 2011 05:07:14 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] tty: serial: altera_uart: Add devicetree support
Message-ID: <20110216120714.GA24203@angua.secretlab.ca>
References: <cover.1297245277.git.tklauser@distanz.ch>
 <c7a7085602687d2f1b6ac505c030f19bafda04e3.1297245277.git.tklauser@distanz.ch>
 <20110216043201.GA11684@angua.secretlab.ca>
 <20110216074321.GB4076@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216074321.GB4076@distanz.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 08:43:21AM +0100, Tobias Klauser wrote:
> On 2011-02-16 at 05:32:01 +0100, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Wed, Feb 09, 2011 at 10:58:13AM +0100, Tobias Klauser wrote:
> > > With the recent switch of the (currently still out-of-tree) Nios2 Linux
> > > port to devicetree we want to be able to retreive the resources and
> > > properties from dts.
> > > 
> > > The old method to retreive resources and properties from platform data
> > > is still supported.
> > > 
> > > Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> > > ---
[...]
> > > +static struct of_device_id altera_uart_match[] = {
> > > +	{ .compatible = "altr,uart-1.0", },
> > > +	{},
> > > +};
> > > +MODULE_DEVICE_TABLE(of, altera_uart_match);
> > 
> > Need to protect the MODULE_DEVICE_TABLE with #ifdef/#endif.  You don't
> > want to advertise device tree support when CONFIG_OF isn't selected.
> 
> Shall I put the #ifdef around the whole table and define it as NULL if
> CONFIG_OF is not defined - like this:
> 
> 	#ifdef CONFIG_OF
> 	static struct of_device_id altera_uart_match[] = {
> 		{ .compatible = "altr,uart-1.0", },
> 		{},
> 	};
> 	MODULE_DEVICE_TABLE(of, altera_uart_match);
> 	#else
> 	#define altera_uart_match NULL
> 	#endif /* CONFIG_OF */
> 
> or will it be sufficient to just #ifdef the MODULE_DEVICE_TABLE:
> 
> 	static struct of_device_id altera_uart_match[] = {
> 		{ .compatible = "altr,uart-1.0", },
> 		{},
> 	};
> 	#ifdef CONFIG_OF
> 	MODULE_DEVICE_TABLE(of, altera_uart_match);
> 	#endif

Either is fine, but the first will have a smaller memory footprint
when CONFIG_OF is deselected.

g.

