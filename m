Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab0DQOmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 10:42:19 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41332 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751920Ab0DQOmS (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 10:42:18 -0400
Date: Sat, 17 Apr 2010 10:42:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: linux-usb@vger.kernel.org, <Linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] usb: core: config.c: use buffer on stack rather then on
 heap
In-Reply-To: <871veecl05.fsf@erwin.mina86.com>
Message-ID: <Pine.LNX.4.44L0.1004171041240.4980-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Apr 2010, Michal Nazarewicz wrote:

> usb_get_configuration() uses a temporary buffer allocated on heap
> to read USB configuration descriptor.  The buffer is just nine
> bytes an so it is a waste to allocate it on heap where it can be
> allocated on stack with the rest of local variables.  This
> simplifies the code and minimises memory usage.

This is completely wrong.  You are not allowed to do DMA to buffers on 
the stack; some architectures are not capable of handling it.

Alan Stern

