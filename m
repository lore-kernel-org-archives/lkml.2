Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965944Ab0CPBpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:45:11 -0400
Received: from sh.osrg.net ([192.16.179.4]:53816 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965901Ab0CPBpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:45:08 -0400
Date: Tue, 16 Mar 2010 10:44:59 +0900
To: albert_herranz@yahoo.es
Cc: linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH v4 05/11] swiotlb: add swiotlb_set_default_size()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1268421166-4791-6-git-send-email-albert_herranz@yahoo.es>
References: <1268421166-4791-1-git-send-email-albert_herranz@yahoo.es>
	<1268421166-4791-6-git-send-email-albert_herranz@yahoo.es>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100316104440Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 16 Mar 2010 10:45:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 20:12:40 +0100
Albert Herranz <albert_herranz@yahoo.es> wrote:

> The current SWIOTLB code uses a default of 64MB for the IO TLB area.
> This size can be influenced using a kernel command line parameter "swiotlb".
> Unfortunately, the parsing of the kernel command line is done _after_ the
> swiotlb is initialized on some architectures.
> 
> This patch adds a new function swiotlb_set_default_size() which can be used
> before swiotlb_init() to indicate the desired IO TLB area size in bytes.
> 
> This will be used later to implement a smaller IO TLB on the Nintendo Wii
> video game console which just comes with 24MB + 64MB of RAM.
> 
> CC: linuxppc-dev@lists.ozlabs.org
> CC: linux-kernel@vger.kernel.org
> CC: x86@kernel.org
> CC: linux-ia64@vger.kernel.org
> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
> ---
>  include/linux/swiotlb.h |    2 ++
>  lib/swiotlb.c           |   20 ++++++++++++++++++++
>  2 files changed, 22 insertions(+), 0 deletions(-)

Please fix the powerpc swiotlb initialization instead.

Calling swiotlb_init() before parsing kernel parameters sounds
wrong. Any reasons why you can't fix it?
