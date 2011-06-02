Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1FBNqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:46:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57496 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab1FBNqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :organization:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=PhTxMJa0TkqDhb0FFhuuvG7oddATl9tTyX+PW68X1mAcs6lWG1cVMLh5b7KGd0IR4X
         VtxAwpWUURRRLsE73y11TkYeL+Es0VS7B/vPgrb79vUfCTr+2qh3UCs3RyTrlmCLE5Bv
         kBaBF5+G9g8C7/8b5FZeRovXAKlf6xxuVTQJY=
From: Florian Fainelli <florian@openwrt.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VLYNQ: vlynq_enable_device should try remote enabling first
Date: Thu, 2 Jun 2011 15:46:37 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-9-generic; KDE/4.6.2; x86_64; ; )
Cc: akpm@linux-foundation.org
References: <201103111157.28347.florian@openwrt.org>
In-Reply-To: <201103111157.28347.florian@openwrt.org>
Organization: OpenWrt
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106021546.37924.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Friday 11 March 2011 11:57:28 Florian Fainelli wrote:
> I noticed device lockups on TNETD7200 chips when vlynq_enable_device tried
> enabling the device in the following order: external -> local -> remote
> 
> inverting the external and remote order fixes the lock up and allows normal
> operation of the remote VLYNQ device on all TNETD generations (7100, 7200,
> 7300).
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

I did not get a feedback from you whether you applied this patch or not, it is
still valid though.

Thank you.

> ---
> diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
> index f885c86..0dd05ce 100644
> --- a/drivers/vlynq/vlynq.c
> +++ b/drivers/vlynq/vlynq.c
> @@ -516,9 +516,9 @@ static int __vlynq_enable_device(struct vlynq_device
> *dev) !__vlynq_try_external(dev))
>  				return 0;
>  		} else {
> -			if (!__vlynq_try_external(dev) ||
> -				!__vlynq_try_local(dev)    ||
> -				!__vlynq_try_remote(dev))
> +			if (!__vlynq_try_remote(dev) ||
> +				!__vlynq_try_local(dev)  ||
> +				!__vlynq_try_external(dev))
>  				return 0;
>  		}
>  		break;
> --
> 1.7.1

-- 
Florian
