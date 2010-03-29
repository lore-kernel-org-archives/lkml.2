Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0C2Bw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 21:52:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:50129 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab0C2BwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 21:52:25 -0400
Date: Mon, 29 Mar 2010 10:52:02 +0900
To: ben@decadent.org.uk
Cc: bzolnier@gmail.com, gregkh@suse.de, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt28xx: Make PCI_{MAP,UNMAP}_SINGLE type-safe
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1269822285.8653.251.camel@localhost>
References: <alpine.DEB.2.00.1003282040480.4731@ernie.pinecrest>
	<1269821357.8653.231.camel@localhost>
	<1269822285.8653.251.camel@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100329105129Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 29 Mar 2010 10:52:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 01:24:45 +0100
Ben Hutchings <ben@decadent.org.uk> wrote:

> To avoid recurrence of bugs such as <http://bugs.debian.org/575726>,
> change the type of the first parameter to linux_pci_{map,unmap}_single()
> from void * to struct rt_rtmp_adapter *.  Also do not define the macros
> PCI_{MAP,UNMAP}_SINGLE() when building the rt2870sta driver; they are
> not used and if they were that would be a bug.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk> 
> ---
>  drivers/staging/rt2860/rt_linux.h    |   14 +++++---------
>  drivers/staging/rt2860/rt_pci_rbus.c |   12 ++++--------
>  2 files changed, 9 insertions(+), 17 deletions(-)

I think using dma_map_single directly instead of inventing a wrapper
function make the code more readable.
