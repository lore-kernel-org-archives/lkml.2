Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1K1UoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:44:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59367 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab1K1UoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:44:15 -0500
Date: Mon, 28 Nov 2011 21:44:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nicolas Kalkhof <nkalkhof@web.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        deepthi@linux.vnet.ibm.com
Subject: Re: Too many poll_idle cpu calls in kernel 3.2 rc-series
Message-ID: <20111128204412.GM24062@one.firstfloor.org>
References: <492649473.3864850.1322512273580.JavaMail.fmail@mwmweb020>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492649473.3864850.1322512273580.JavaMail.fmail@mwmweb020>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 09:31:13PM +0100, Nicolas Kalkhof wrote:
> Andi,
> 
> correct. The issue was introduced somewhere between 3.1 final and 3.2-rc1. I've tried to track down the bad commit but so far I haven't been successfull. The only workaround I found is to set the idle boot parameter to mwait and to disable CONFIG_INTEL_IDLE. Somehow the kernel seems to set idle to poll by default - no idea why :-(. I wonder if other mobile sandy bridge cpus are affected as well.

There are only a few changesets affecting drivers/idle

Can you try to git revert 

46bcfad7a819bd17ac4e831b04405152d59784ab
4202735e8ab6ecfb0381631a0d0b58fefe0bd4e2
e978aa7d7d57d04eb5f88a7507c4fb98577def77

?

-Andi
