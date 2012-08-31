Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2HaNZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:25:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33492 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab2HaNZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:25:53 -0400
Subject: Re: [PATCH 1/1] tcp: Wrong timeout for SYN segments
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexander Bergmann <alex@linlab.net>
Cc: davem@davemloft.net, hkjerry.chu@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120831124831.GA23279@linlab.net>
References: <1345724123.5904.756.camel@edumazet-glaptop>
	 <20120824.134231.41073001349178209.davem@davemloft.net>
	 <20120825084819.GD430@linlab.net>
	 <201208281044.40057.carsten@wolffcarsten.de>
	 <1346414260.2591.8.camel@edumazet-glaptop>
	 <20120831124831.GA23279@linlab.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Aug 2012 06:25:50 -0700
Message-ID: <1346419550.2591.12.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-31 at 14:48 +0200, Alexander Bergmann wrote:

> Hi Eric!
> 
> I've also changed the Documentation file. As usual, comments are welcome!
> 
> 
> Alex
> 
> 
> From 848f34ce27f65401940ae98e0b2d395888d3986d Mon Sep 17 00:00:00 2001
> From: Alexander Bergmann <alex@linlab.net>
> Date: Fri, 31 Aug 2012 14:31:00 +0200
> Subject: [PATCH 1/1] tcp: Increase timeout for SYN segments
> 
> Commit 9ad7c049 changed the initRTO from 3secs to 1sec in accordance to
> RFC6298 (former RFC2988bis). This reduced the time till the last SYN
> retransmission packet gets sent from 93secs to 31secs.
> 
> RFC1122 is stating that the retransmission should be done for at least 3
> minutes, but this seems to be quite high.
> 
>   "However, the values of R1 and R2 may be different for SYN
>   and data segments.  In particular, R2 for a SYN segment MUST
>   be set large enough to provide retransmission of the segment
>   for at least 3 minutes.  The application can close the
>   connection (i.e., give up on the open attempt) sooner, of
>   course."
> 
> This patch increases the value of TCP_SYN_RETRIES to the value of 6,
> providing a retransmission window of 63secs.
> 
> The comments for SYN and SYNACK retries have also been updated to
> describe the current settings. The same goes for the documentation file
> "Documentation/networking/ip-sysctl.txt".
> 
> Signed-off-by: Alexander Bergmann <alex@linlab.net>
> ---

Thanks for your patience and followup, this seems good to me !

Acked-by: Eric Dumazet <edumazet@google.com>



