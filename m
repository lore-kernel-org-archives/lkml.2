Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0DQQNh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 12:13:37 -0400
Received: from netrider.rowland.org ([192.131.102.5]:47838 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751686Ab0DQQNf (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 12:13:35 -0400
Date: Sat, 17 Apr 2010 12:13:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: linux-usb@vger.kernel.org, <Linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] usb: core: config.c: usb_get_configuration() simplified
In-Reply-To: <87sk6uaz9h.fsf@erwin.mina86.com>
Message-ID: <Pine.LNX.4.44L0.1004171212550.6609-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Apr 2010, Michal Nazarewicz wrote:

> usb_gat_configuratio() used two pointers to point to the same
> memory.  Code simplified, by removing one of them.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/usb/core/config.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> > On Sat, 17 Apr 2010, Michal Nazarewicz wrote:
> >> usb_get_configuration() uses a temporary buffer allocated on heap
> >> to read USB configuration descriptor.  The buffer is just nine
> >> bytes an so it is a waste to allocate it on heap where it can be
> >> allocated on stack with the rest of local variables.  This
> >> simplifies the code and minimises memory usage.
> 
> Alan Stern <stern@rowland.harvard.edu> writes:
> > This is completely wrong.  You are not allowed to do DMA to buffers on 
> > the stack; some architectures are not capable of handling it.
> 
> That makes sense; I haven't considered this thinking that copying nine
> bytes by CPU, rather then using DMA, is not a big issue.
> 
> Still, the change proposed by attached commit does not suffer from DMA
> issue and still simplify the code.

Yes, this is fine.

Alan Stern

