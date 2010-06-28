Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0F1SKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 14:10:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49326 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab0F1SKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 14:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=c9xBGIyzATP8/wvnu0B9FpZPi60fu/2mZ/OJS214r2zRynzFl3+I/dKyc5WikYfNPR
         V3ytzncthAc7phRVCixY89HMC7W93YeArxrIoHD3LrtABF7AnK0UkMTqFOCpKyP+NN13
         a4CP1ilB0Ambzcv6+iR6p8o3ui4Y9Y5s8I84Y=
Message-ID: <4C28DF65.4010802@gmail.com>
Date: Mon, 28 Jun 2010 10:44:05 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       gustavo@padovan.org
Subject: Re: [PATCH] Bluetooth: Fix abuse of the preincrement operator
References: <1277621246-10960-6-git-send-email-justinmattock@gmail.com> <20100628125752.8945.50572.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100628125752.8945.50572.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 05:57 AM, David Howells wrote:
> Fix abuse of the preincrement operator as detected when building with gcc
> 4.6.0:
>
> 	 CC [M]  drivers/bluetooth/hci_bcsp.o
> 	drivers/bluetooth/hci_bcsp.c: In function 'bcsp_prepare_pkt':
> 	drivers/bluetooth/hci_bcsp.c:247:20: warning: operation on 'bcsp->msgq_txseq' may be undefined
>
> Reported-by: Justin P. Mattock<justinmattock@gmail.com>
> Signed-off-by: David Howells<dhowells@redhat.com>
> ---
>
>   drivers/bluetooth/hci_bcsp.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
> index 40aec0f..42d69d4 100644
> --- a/drivers/bluetooth/hci_bcsp.c
> +++ b/drivers/bluetooth/hci_bcsp.c
> @@ -244,7 +244,7 @@ static struct sk_buff *bcsp_prepare_pkt(struct bcsp_struct *bcsp, u8 *data,
>   	if (rel) {
>   		hdr[0] |= 0x80 + bcsp->msgq_txseq;
>   		BT_DBG("Sending packet with seqno %u", bcsp->msgq_txseq);
> -		bcsp->msgq_txseq = ++(bcsp->msgq_txseq)&  0x07;
> +		bcsp->msgq_txseq = (bcsp->msgq_txseq + 1)&  0x07;
>   	}
>
>   	if (bcsp->use_crc)
>
>

ahh.. so it's o.k. to add the value after bcsp->msgq_txseq instead of 
before. Anyways build clean over here..

Thanks!

Justin P. Mattock
