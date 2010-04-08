Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab0DHIDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 04:03:01 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:40201 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab0DHICz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:02:55 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: USB transfer_buffer allocations on 64bit systems
Date: Thu, 8 Apr 2010 08:09:11 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, Pedro Ribeiro <pedrib@gmail.com>,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
References: <20100407090623.GN30807@buzzloop.caiaq.de> <20100407153154.GC13425@kroah.com> <20100407153551.GK30801@buzzloop.caiaq.de>
In-Reply-To: <20100407153551.GK30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004080809.11756.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. April 2010 17:35:51 schrieb Daniel Mack:
> > Alan, any objection to just using usb_buffer_alloc() for every driver?
> > Or is that too much overhead?
> 
> FWIW, most drivers I've seen in the past hours use a wild mix of
> kmalloc(), kzalloc(), kcalloc() and usb_buffer_alloc(). That should
> really be unified.

kmalloc() & friends != usb_buffer_alloc(). They do different things.
It makes no sense to unify them. If you really need an ordinary
buffer DMA will surely work on, this needs a third primitive.

	Regards
		Oliver
