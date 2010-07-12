Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab0GLPow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:44:52 -0400
Received: from mxout-07.mxes.net ([216.86.168.182]:34814 "EHLO
	mxout-07.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab0GLPov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:44:51 -0400
Date: Mon, 12 Jul 2010 11:44:48 -0400
From: =?iso-8859-1?B?RnLpZOlyaWMgQnJp6HJl?= <fbriere@fbriere.net>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, linux-parport@lists.infradead.org
Subject: Re: [PATCH] parport/serial: add support for Timedia/SUNIX cards to
 parport_serial
Message-ID: <20100712154448.GA2558@toroia.fbriere.dyndns.org>
References: <1277511823-6973-1-git-send-email-fbriere@fbriere.net>
 <20100708121122.17d3e823@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708121122.17d3e823@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 12:11:22PM +0100, Alan Cox wrote:
> If you did that check in the serial driver and returned -ENODEV to the
> probe the id will be handed on to the next driver that matches (ie
> parport_serial)

Thanks for the suggestion; it does look much cleaner that way.

Instead of sticking a big-ass if() in the function, I took the liberty
of adding a .probe alongside the .init/.setup quirks, in case this could
be useful for other devices.

Note that I did not bother to cache the result of find_quirk(), so it
will be called twice.  I did not find it worth to add extra complexity
just for that; let me know if you disagree.


-- 
On the Internet, no one knows you're using Windows NT
		-- Submitted by Ramiro Estrugo, restrugo@fateware.com
