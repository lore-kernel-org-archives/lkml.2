Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab2GKOR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:17:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61356 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab2GKORZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:17:25 -0400
Subject: Re: Protocol handler using dev_add_pack
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jerry Yu <jerryy@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAP2AAQMvx5yxVRLN4AT_YdsFJAUDRgSNwzq0A3x8JyZgXKEjmw@mail.gmail.com>
References: <CAP2AAQMvx5yxVRLN4AT_YdsFJAUDRgSNwzq0A3x8JyZgXKEjmw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Jul 2012 16:17:19 +0200
Message-ID: <1342016239.3265.8007.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 10:38 -0300, Jerry Yu wrote:
> I am working on a kernel module to monitor all TCP packets. I created a protocol
> handler with protocol code ETH_P_ALL to handle all incoming and outgoing
> TCP packets. The code worked fine on 2.6.14 kernel, but in current 3.2.0-26
> kernel, I am no longer able to get the TCP payload for outgoing packets.
> The data in TCP payload section of skb->data are mainly 0x00. I am still
> able to get incoming TCP packets' payloads though.
> 
> Is there any change in 3.2.0 or other early kernel versions that will cause
> this issue?

Maybe you make wrong assumptions in your code.

skb->data doesnt exactly contains tcp payload of locally generated TCP
packets, unless you disabled scatter-gather on the NIC

ehtool -K eth0 sg off



