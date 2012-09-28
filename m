Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab2I1RDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:03:52 -0400
Received: from smtp181.iad.emailsrvr.com ([207.97.245.181]:37788 "EHLO
	smtp181.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab2I1RDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:03:51 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: "linux1394-devel@lists.sourceforge.net" 
	<linux1394-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 28 Sep 2012 13:03:45 -0400
Subject: Re: [PATCH] firewire: remove global lock around address handlers,
 convert to RCU
Thread-Topic: [PATCH] firewire: remove global lock around address handlers,
 convert to RCU
Thread-Index: Ac2dmziF8Amhg02FSKu+PWJZx/SVxQ==
Message-ID: <1348851825.2229.1.camel@thor>
References: <1345359002.6089.3.camel@thor>	<20120819122759.30f9981f@stein>
	 <1345403610.7706.72.camel@thor>	<20120820030450.7f5bfa37@stein>
	 <20120927214436.1da8b8ef@stein> <20120928113837.4f5de6ef@stein>
In-Reply-To: <20120928113837.4f5de6ef@stein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 05:38 -0400, Stefan Richter wrote:
> On Sep 27 Stefan Richter wrote:
> > --- a/drivers/firewire/core-transaction.c
> > +++ b/drivers/firewire/core-transaction.c
> > @@ -489,7 +489,7 @@ static struct fw_address_handler *lookup
> >  {
> >  	struct fw_address_handler *handler;
> >  
> > -	list_for_each_entry(handler, list, link) {
> > +	list_for_each_entry_rcu(handler, list, link) {
> >  		if (handler->offset < offset + length &&
> >  		    offset < handler->offset + handler->length)
> >  			return handler;
> [...]
> 
> I will add an #include <linux/rculist.h> to core-transaction.c.

Thanks Stefan. Apologies for missing that.

Peter Hurley
