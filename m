Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab1EMNf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:35:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51524 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab1EMNfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:35:25 -0400
Date: Fri, 13 May 2011 15:35:20 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: question about drivers/isdn/hisax/st5481_init.c
In-Reply-To: <1305292826.4065.443.camel@localhost>
Message-ID: <Pine.LNX.4.64.1105131535070.20447@pc-004.diku.dk>
References: <Pine.LNX.4.64.1105130748060.9190@ask.diku.dk>
 <1305292826.4065.443.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011, Ben Hutchings wrote:

> On Fri, 2011-05-13 at 07:53 +0200, Julia Lawall wrote:
> > The function probe_st5481 allocates an adapter value using kzalloc, adds 
> > it to adapter_list, and then performs various initialization operations, 
> > which may fail.  adapter_list is a static variable that is never otherwise 
> > referenced in the file.  There is a list_del that removes the adapter from 
> > the list in the function disconnect_st5481.  The presence of the adapter 
> > on the list makes it possibly unsafe to free adapter in the failure cases.
> > 
> > Could the list just be removed, if it is not being used anywhere?
> > 
> > Or if the list should be kept because it is useful or it is planned to be 
> > useful in the future, could the insertion into the list be moved to the 
> > end of the function, after the potentially failing operations, so that 
> > adapter can be freed when a failure occurs?
> 
> Some older drivers have these device lists hanging around from before
> the device model has implemented.  If the list isn't being used now then
> it's probably fine to remove.

OK, I'll propose a patch in that direction.  Thanks.

julia
