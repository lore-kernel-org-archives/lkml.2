Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1BGH2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 02:28:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55528
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823Ab1BGH2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 02:28:21 -0500
Date: Sun, 06 Feb 2011 23:28:56 -0800 (PST)
Message-Id: <20110206.232856.246531984.davem@davemloft.net>
To: Knut_Petersen@t-online.de
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, mostrows@earthlink.net,
        linux-ppp@vger.kernel.org
Subject: Re: [BUG] 2.6.38-rc2: Circular Locking Dependency
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D3D45A3.7040809@t-online.de>
References: <4D3D45A3.7040809@t-online.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Knut Petersen <Knut_Petersen@t-online.de>
Date: Mon, 24 Jan 2011 10:25:55 +0100

> As I was hunting something different I found the following (potential)
> problem on an openSuSE 11.3 system with kernel 2.6.38-rc2.
> The message is triggerd by smpppd starting a dsl connection.
> 
> Knut
> 
> 
>  NET: Registered protocol family 24
> 
>  =======================================================
>  [ INFO: possible circular locking dependency detected ]
>  2.6.38-rc2-kape #7
>  -------------------------------------------------------
>  pppd/2529 is trying to acquire lock:
>   (&(&pch->downl)->rlock){+.....}, at: [<f814a634>] ppp_push+0x59/0x4a8
> [ppp_generic]
> 
>  but task is already holding lock:
>   (&(&ppp->wlock)->rlock){+.-...}, at: [<f814ae1b>]
> ppp_xmit_process+0x19/0x451 [ppp_generic]
> 
>  which lock already depends on the new lock.

I've stared over this trace several times and can't figure out what
the problem is.

Paul, any idea?
