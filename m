Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0CXWQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:16:06 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:59030 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0CXWQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:16:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=T+8ELwi4gWbYoLVBmxCZpGJeE9aGK4unnWT7tivvznpyQPRe5uvXcQqy/zC0ljKvHt
         2qUWd0mc1raiioJnUlwfrtVK0olpCgBxRCARgi9I3+ZPr64mt4OK57/4cOVjiLAGrgeC
         GYcuXeMf8AoSfukKWSH/BTN9QY2iSueZHncuM=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] rt2500usb: improve powersaving reliability
Date: Wed, 24 Mar 2010 23:15:56 +0100
User-Agent: KMail/1.9.10
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       rt2x00 Users List <users@rt2x00.serialmonkey.com>,
       linux-kernel@vger.kernel.org
References: <201003221601.36559.linux@rainbow-software.org> <4BA8E11A.2020300@gmail.com> <201003242307.36363.linux@rainbow-software.org>
In-Reply-To: <201003242307.36363.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003242315.56374.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010, Ondrej Zary wrote:
> According to my debugging, retrying 5 times (REGISTER_BUSY_COUNT) does not
> provide enough time for the device to enter the required state. Sometimes,
> the device needs 12 to 15 retries. Increase it to 20 to be sure.
> 
> This improves powersaving reliability but one problem still remains: power
> state change sometimes fails completely - the bpp_state and rf_state get
> stuck and cannot be changed anymore.

Gertjan has disabled powersaving in rt2500usb until this can be sorted out.
I think for now that would be the way to go. This patch might be needed anyway,
but I'll let GertJan decide on that one.

My only comment about the fix itself is that the REGISTER_BUSY_COUNT should
be updated. rt2500usb is not the only one which suffers from the timeout, so those
might profit from the extra delay as well.

> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> --- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-20 02:17:57.000000000 +0100
> +++ linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-24 22:55:53.000000000 +0100
> @@ -968,7 +968,7 @@ static int rt2500usb_set_state(struct rt
>  	 * We must wait until the register indicates that the
>  	 * device has entered the correct state.
>  	 */
> -	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
> +	for (i = 0; i < 20; i++) {
>  		rt2500usb_register_read(rt2x00dev, MAC_CSR17, &reg2);
>  		bbp_state = rt2x00_get_field16(reg2, MAC_CSR17_BBP_CURR_STATE);
>  		rf_state = rt2x00_get_field16(reg2, MAC_CSR17_RF_CURR_STATE);
> 
> 


