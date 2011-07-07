Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab1GGHNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:13:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60175 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1GGHNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:13:09 -0400
Date: Thu, 07 Jul 2011 00:13:01 -0700 (PDT)
Message-Id: <20110707.001301.1054777374178479078.davem@davemloft.net>
To: loke.chetan@gmail.com
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, joe@perches.com,
        bhutchings@solarflare.com, shemminger@vyatta.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next af-packet 1/2] Enhance af-packet to provide
 (near zero)lossless packet capture functionality.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAAsGZS67G8H5NLBxQTY88+T1cRQ3aiwBXK5qa8SJ_TbQ7xqvhw@mail.gmail.com>
References: <CAAsGZS5vvmb_qX+cG507=hU_+kwnowEEojXGNMt5ShEZ9+ZeAA@mail.gmail.com>
	<20110705.080123.2174577714045488116.davem@davemloft.net>
	<CAAsGZS67G8H5NLBxQTY88+T1cRQ3aiwBXK5qa8SJ_TbQ7xqvhw@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 07 Jul 2011 00:13:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chetan loke <loke.chetan@gmail.com>
Date: Wed, 6 Jul 2011 17:45:20 -0400

> new format:
> 
> union bd_header_u {
>        /* renamed struct bd_v1 to hdr_v1 */
>        struct hdr_v1 h1;
> } __attribute__ ((__packed__));
> 
> struct block_desc {
>        __u16 version;
>        __u16 offset_to_priv;
>        union bd_header_u hdr;
> } __attribute__ ((__packed__));
> 
> Is this ok with you?

Get rid of __packed__, it's going to kill performance on RISC
platforms.  If you use __packed__, regardless of the actual alignment,
the compiler must assume that each part of the struct "might" be
unaligned.  So on architectures such as sparc where alignment matters,
a word is going to be accessed by a sequence of byte loads/stores.

Do not use packed unless absolutely enforced by a protocol or hardware
data structure, it's evil.
