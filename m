Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab0IOK5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:57:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48190 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0IOK46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:56:58 -0400
Date: Wed, 15 Sep 2010 13:56:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, "Balbi, Felipe" <balbi@ti.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [Discussion] USB: musb-gadget: how to fix ZLP issue in
 musb_g_tx
Message-ID: <20100915105641.GO3393@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <AANLkTinPVUBNJoOR496KgSy2TT0f6i1f5xEKVhKod2R=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AANLkTinPVUBNJoOR496KgSy2TT0f6i1f5xEKVhKod2R=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 15, 2010 at 05:53:10AM -0500, Ming Lei wrote:
>1),  why is the check for "is_dma" needed here?
>
>      if (is_dma || request->actual == request->length) {
>           ....
>      }

if you programmed dma to request->length (and assuming it worked just
fine) mode1 will only interrupt you when the entire request has been
sent.

>2), why is a zlp needed in the case below?
>
>      #ifdef CONFIG_USB_INVENTRA_DMA
>                  || (is_dma && (!dma->desired_mode ||
>                     (request->actual & (musb_ep->packet_sz - 1))))
>     #endif

in that case, it's not a zlp, it's short packet. Inventra will *NOT*
transfer short packets, you need to set txpktrdy by hand to get it
transfered.

>IMO, it is not difficult to give a good fix for the ZLP problem
>if the two questions are clear.

true, but some re-work needs to be done.

-- 
balbi
