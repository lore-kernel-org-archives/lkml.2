Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1KYW2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 17:28:17 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:39460 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab1KYW2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 17:28:15 -0500
Date: Fri, 25 Nov 2011 23:22:11 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        Armin Kazmi <armin.kazmi@tu-dortmund.de>, Gerd <booster@wolke7.net>
Subject: Re: [bug?] r8169: hangs under heavy load
Message-ID: <20111125222211.GA13719@electric-eye.fr.zoreil.com>
References: <4E7F4D45.7040902@wolke7.net> <1316978632.4122.103.camel@deadeye> <4E82C0B5.1050902@wolke7.net> <1317254171.4068.12.camel@deadeye> <20111124044137.GA18262@elie.hsd1.il.comcast.net> <4ECFE7A7.5070300@wolke7.net> <20111125201936.GA26692@elie.hsd1.il.comcast.net> <1322253122.2550.3.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322253122.2550.3.camel@edumazet-laptop>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> :
[...]
> rtl8169_rx_interrupt(..., budget) can return budget + 1 sometimes
> because of :
> 
>                 /* Work around for AMD plateform. */
>                 if ((desc->opts2 & cpu_to_le32(0xfffe000)) &&
>                     (tp->mac_version == RTL_GIGA_MAC_VER_05)) {
>                         desc->opts2 = 0;
>                         cur_rx++;
>                 }

It needs fixing but RTL_GIGA_MAC_VER_05 is an old PCI 8169sc while
debian's bug #642911 is about a 8168c (aka RTL_GIGA_MAC_VER_{19 .. 22}).

This path is not used.

-- 
Ueimor
