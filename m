Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab0FIUnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:43:04 -0400
Received: from fw.wantstofly.org ([80.101.37.227]:57851 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab0FIUnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:43:01 -0400
Date: Wed, 9 Jun 2010 22:42:57 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Alexander Clouter <alex@digriz.org.uk>
Cc: Dmytro Milinevskyy <milinevskyy@gmail.com>,
       linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Dhaval Vasa <dhaval.vasa@einfochips.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Nicolas Pitre <nico@fluxnic.net>, Simon Guinot <sguinot@lacie.com>,
       Martin Michlmayr <tbm@cyrius.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Marvell OpenRD-Ultimate machine support
Message-ID: <20100609204257.GJ1743@mail.wantstofly.org>
References: <4c0ff6b2.0c3ddf0a.2185.2e09@mx.google.com> <20100609203720.GK7660@chipmunk> <20100609203929.GL7660@chipmunk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609203929.GL7660@chipmunk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 09:39:29PM +0100, Alexander Clouter wrote:

> > >  	kirkwood_ge00_init(&openrd_ge00_data);
> > > -	if (machine_is_openrd_client())
> > > +	if (machine_is_openrd_client() ||      \__same line
> > > +		machine_is_openrd_ultimate())  /
> > >  		kirkwood_ge01_init(&openrd_ge01_data);
> > > +  <------- REMOVE
> > >  	kirkwood_sata_init(&openrd_sata_data);
> > >  	kirkwood_sdio_init(&openrd_mvsdio_data);
> > >  
> > As that 'if()' clause is still less than 77 chars wide:
> > ----
> > kirkwood_ge00_init(&openrd_ge00_data);
> > if (machine_is_openrd_client() || machine_is_openrd_ultimate())
> > 	kirkwood_ge01_init(&openrd_ge01_data);
> > kirkwood_sata_init(&openrd_sata_data);
> > kirkwood_sdio_init(&openrd_mvsdio_data);
> > ----
> 
> Better still, just make this 'if(!machine_is_openrd_base())'.

That form is more error prone when someone adds the OpenRD-SuperDuper,
though.
