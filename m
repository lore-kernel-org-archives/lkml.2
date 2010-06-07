Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab0FGHkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 03:40:01 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50025 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab0FGHj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 03:39:59 -0400
Subject: Re: OMAP video compile error; regression from 2.6.33-rc4 onward
 (including current master)
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Luke-Jr <luke@dashjr.org>
Cc: "slapin@ossfans.org" <slapin@ossfans.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
In-Reply-To: <201006061652.39248.luke@dashjr.org>
References: <201006061652.39248.luke@dashjr.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 10:39:01 +0300
Message-ID: <1275896341.2549.11.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jun 2010 07:39:10.0069 (UTC) FILETIME=[8467AA50:01CB0614]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-06 at 23:52 +0200, ext Luke-Jr wrote:
> This doesn't even build, so I don't know how it was tested... Reverting the 
> offending commit (simple, but does require conflict resolution) at least lets 
> it compile, but I haven't tested whether it alone is enough to work in 
> practise yet... hoping Tomi might provide a real fix. Maybe even in time for 
> 2.6.35 final? :)
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=16144
> 
> CC      drivers/video/omap/rfbi.o                                               
> drivers/video/omap/rfbi.c: In function 'rfbi_get_clocks':                       
> drivers/video/omap/rfbi.c:86: error: 'dispc' undeclared (first use in this
> function)
> drivers/video/omap/rfbi.c:86: error: (Each undeclared identifier is reported
> only once
> drivers/video/omap/rfbi.c:86: error: for each function it appears in.)          
> make[1]: *** [drivers/video/omap/rfbi.o] Error 1                                
> make: *** [drivers/video/omap/rfbi.o] Error 2                                   
> 
> The 'dispc' referred to herein is and has always been defined in
> drivers/video/omap/dispc.c as an anonymous struct.

Hmm yes, looks rather broken. I don't know how that has gotten through
=). Reverting the patch makes it compile, but RFBI won't work.

 Tomi


