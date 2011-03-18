Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab1CRRMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:12:08 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:50586 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757182Ab1CRRMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:12:02 -0400
Date: Fri, 18 Mar 2011 19:08:02 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stefan Bigler <stefan.bigler@keymile.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
Message-ID: <20110318170801.GA2857@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4D8121F6.9060600@keymile.com>
 <20110317000408.GA18911@kroah.com>
 <4D8389EC.5030704@keymile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8389EC.5030704@keymile.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(please don't top-post)

On Fri, Mar 18, 2011 at 05:35:56PM +0100, Stefan Bigler wrote:
> Thanks for your quick answer. Meanwhile we ported our board to 2.6.38.
> We recognize the same problem again.
> I had also a look at the relevant fixes, a lot is done but I could not find
> the required protection of the attribute receive_room.
> 
> I added a printk in case of failure were receive_room shows more
> space that is really available in the queue and also used.
> 
> The printk is attached below and also the log.
> 
> Regards
> Stefan
> 
> 
> Log:
> flush_to_ldisc, receive_room to small count=201, receive_room=287,
> real_room=0
> flush_to_ldisc, receive_room to small count=225, receive_room=1031,
> real_room=0
> flush_to_ldisc, receive_room to small count=33, receive_room=4095,
> real_room=0


I had the same problem while I was working at Nokia developing the N900.
I even sent a patch (twice) with Alan Cox on the loop but nothing has
happened. The patch might still be floating on the archives but
essentially it would make ->receive_buf() return the amount of received
bytes (as IMHO it should be done).

-- 
balbi
