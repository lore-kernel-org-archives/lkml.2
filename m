Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab1AKRaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:30:07 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54691 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab1AKRaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:30:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rNbPc2L9qVGeSg99I27VeTR6lv8nGN1NqsrLBPdYlYguG4DnXFUefDPmxbeVDop+V0
         1hFC9G6hJyUPSD/LEwaxNJHschEVL+igJfA/uC/1Co7WCEHVRNTg2pQLJ1mJC6HEJRYp
         lLVCAAcFHYO7oyHHVV27tqcipH6ndC+b3IKxY=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1101110044580.32164@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101110044580.32164@swampdragon.chaosbits.net>
Date: Tue, 11 Jan 2011 18:30:03 +0100
Message-ID: <AANLkTimDHO=oiR3ncX4BLmMJaoUAmaQL6r=bZcWV4-Gg@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Don't leak mem in error path of rt2x00lib_request_firmware()
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> We need to release_firmware() in order not to leak memory.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

I can assume that release_firmware() checks if 'fw' is null?
If so:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  rt2x00firmware.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
> index f0e1eb7..be0ff78 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
> @@ -58,6 +58,7 @@ static int rt2x00lib_request_firmware(struct rt2x00_dev *rt2x00dev)
>
>        if (!fw || !fw->size || !fw->data) {
>                ERROR(rt2x00dev, "Failed to read Firmware.\n");
> +               release_firmware(fw);
>                return -ENOENT;
>        }
>
>
>
> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>
>
