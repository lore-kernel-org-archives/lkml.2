Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1HAMPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:15:37 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:46510 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1HAMPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:15:33 -0400
Date: Mon, 1 Aug 2011 14:12:36 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Dan Carpenter <error27@gmail.com>
CC: <gregkh@suse.de>, <martyn.welch@ge.com>, <devel@driverdev.osuosl.org>,
        <cota@braap.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] staging: vme: allow explicit assignment of bus
 numbers
Message-ID: <20110801121236.GA32358@becoht-mvanga>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, gregkh@suse.de,
	martyn.welch@ge.com, devel@driverdev.osuosl.org, cota@braap.org,
	linux-kernel@vger.kernel.org
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-3-git-send-email-manohar.vanga@cern.ch>
 <20110801111000.GF5575@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110801111000.GF5575@shale.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 02:10:00PM +0300, Dan Carpenter wrote:
> On Mon, Aug 01, 2011 at 12:20:47PM +0200, Manohar Vanga wrote:
> > -static int vme_alloc_bus_num(void)
> > +/* call with vme_bus_num_mtx held */
> 
> Why move the lock outside the function?
> 
> > +static int __vme_alloc_bus_num(int bus_num)
> >  {
> 
> regards,
> dan carpenter
> 

It just makes the code in __vme_add_bus cleaner when you have failures.
I can merge __vme_add_bus and __vme_alloc_bus_num into one.

--
/manohar
