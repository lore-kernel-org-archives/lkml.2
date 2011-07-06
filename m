Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab1GFVpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:45:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65232 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1GFVpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:45:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110705.080123.2174577714045488116.davem@davemloft.net>
References: <1308708650-25509-2-git-send-email-loke.chetan@gmail.com>
	<20110701.153633.267893668051099806.davem@davemloft.net>
	<CAAsGZS5vvmb_qX+cG507=hU_+kwnowEEojXGNMt5ShEZ9+ZeAA@mail.gmail.com>
	<20110705.080123.2174577714045488116.davem@davemloft.net>
Date: Wed, 6 Jul 2011 17:45:20 -0400
Message-ID: <CAAsGZS67G8H5NLBxQTY88+T1cRQ3aiwBXK5qa8SJ_TbQ7xqvhw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next af-packet 1/2] Enhance af-packet to provide
 (near zero)lossless packet capture functionality.
From: chetan loke <loke.chetan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, joe@perches.com,
        bhutchings@solarflare.com, shemminger@vyatta.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 11:01 AM, David Miller <davem@davemloft.net> wrote:

>
> That issue only exists because you haven't defined a common header
> struct that the current, and all future, block descriptor variants can
> include at the start of their definitions.

what's common today may not be common tomorrow. After much thinking I
decided to not provide a generic header because I wouldn't want to
enforce anything.

new format:

union bd_header_u {
       /* renamed struct bd_v1 to hdr_v1 */
       struct hdr_v1 h1;
} __attribute__ ((__packed__));

struct block_desc {
       __u16 version;
       __u16 offset_to_priv;
       union bd_header_u hdr;
} __attribute__ ((__packed__));

Is this ok with you?


>
> Use real data structures, not opaque "offset+size" poking into the
> descriptors.
>
Used to writing firmware APIs. APIs use words/bytes so that they can
be interpreted by firmware folks too.

Chetan Loke
