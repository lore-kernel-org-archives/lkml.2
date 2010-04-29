Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109Ab0D3Sfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:35:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:17305 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934087Ab0D3SfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Kiibzb75PsGOGkJHcIC3Vu8wldtHaKQh34zLkdrsAOHNs6TSspf6DLcMYXiKWfimoI
         l3OBtt3+XjLMqSjJAjx6+Z2WTWLgJMDzg7kWpsuL5mGjAJhNoGcTc1aOify8luooig+P
         JZ+21/++66btFS+hVxd4zuS/uzgjs4RTUC/b0=
Subject: RE: [PATCH] sst25l.c: simplify reading the device ManID/DevID
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
       "andre@bluewatersys.com" <andre@bluewatersys.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <0D753D10438DA54287A00B0270842697636E305B2F@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636D85BD7C@AUSP01VMBX24.collaborationhost.net>
	 <1272519398.7750.67.camel@localhost>
	 <0D753D10438DA54287A00B0270842697636E305B2F@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Apr 2010 21:07:46 +0300
Message-Id: <1272564466.2593.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 12:11 -0500, H Hartley Sweeten wrote:
> On Wednesday, April 28, 2010 10:37 PM, Artem Bityutskiy wrote:
> > On Tue, 2010-04-20 at 18:17 -0500, H Hartley Sweeten wrote:
> >> The Read-ID command will continuously output the Manufacture ID and Device ID
> >> until the command is terminated by a low to high transition on the CE# pin.
> >> We can take advantage of this in the sst25l_match_device routine by reading
> >> both bytes in one spi_write_then_read transaction.
> >> 
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >> Cc: David Woodhouse <dwmw2@infradead.org>
> >> Cc: Andre Renaud <andre@bluewatersys.com>
> >> Cc: Ryan Mallon <ryan@bluewatersys.com>
> >
> > Pushed to l2-mtd-2.6.git / dunno.
> 
> Artem,
> 
> I have discovered that the Read-Status-Register command has the same problem.
> With the SST25L SPI flash chips, if the chip enable is deasserted after sending
> a command that command will get aborted.
> 
> I ran across this while testing a new spi master driver for the ep93xx on an
> EDB9307A dev board.  That board uses the processors SFRMOUT signal as part of
> the chip select logic.  Unfortunately the ep93xx only asserts the SFRMOUT
> signal as long as the spi transmit fifo contains data.  As soon as the last
> bit is clocked into the receive fifo it gets deasserted.  Many of the other
> ep93xx based boards have that same issue.
> 
> I have an updated patch that changes both of these into one synchronous message
> which fixes the sst25l_status and sst25l_match_device functions.  These changes
> should be transparent to any users of this driver.
> 
> Could you drop the current patch and I will submit the updated one for review?

Of course, just send it.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

