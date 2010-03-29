Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0C2NrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:47:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:36362 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab0C2NrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:47:01 -0400
Date: Mon, 29 Mar 2010 15:46:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] usb:Push BKL on open down into the drivers
In-Reply-To: <201003291530.37183.oliver@neukum.org>
Message-ID: <alpine.LNX.2.00.1003291546040.24576@pobox.suse.cz>
References: <201001131533.15704.oliver@neukum.org> <alpine.LNX.2.00.1003291159470.24576@pobox.suse.cz> <201003291530.37183.oliver@neukum.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010, Oliver Neukum wrote:

> > For hiddev, this causes a problem, as you introduced BKL into 
> > hiddev_connect() exactly because of the proper dependency -- we have the 
> > BKL there to avoid race after usb_register_dev() -- once the device node 
> > has been created, open() could happen on it.
> 
> Hi,
> 
> it seems to me you cannot deadlock with the BKL and an rwsem,
> as BKL will be dropped if a task blocks on the rwsem. 

Ah, right you are.

> This is not a nice feature of the BKL to use. Do you have an alternative 
> idea?

Not right now, without introducing additional lock into USB core or 
redesigning the hiddev node registration completely. Hmmm ...

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
