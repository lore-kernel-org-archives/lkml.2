Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0FNX6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:58:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64650 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0FNX6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:58:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bR2NT/T/pU022Dxyj/tVbv8nDkQuKvZxpuL2/o8Qjq8pHYufce9kvrx0TZuqtaeCJP
         33sKl3tcWM4pMLAm/WhyepjNXO82DBPQXhCKKo9+boT1G8vYTI4dUy2eg7gDuz2mzEfW
         tqKX405B1DKHjYQalRlcGrYC9EOCZcUMjC+zI=
Message-ID: <4C16C241.80209@gmail.com>
Date: Mon, 14 Jun 2010 16:58:57 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re:
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-8-git-send-email-justinmattock@gmail.com> <tkrat.6f2ad8e8a9e281c2@s5r6.in-berlin.de> <4C16AECD.50506@gmail.com> <tkrat.5070b3a06affdcfa@s5r6.in-berlin.de>
In-Reply-To: <tkrat.5070b3a06affdcfa@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 04:22 PM, Stefan Richter wrote:
> which caused gcc 4.6 to warn about
>      variable 'destination' set but not used.
>
> Reported-by: Justin P. Mattock<justinmattock@gmail.com>
>
> Since the hardware ensures that we receive only response packets with
> proper destination node ID (in a given bus generation), we have no use
> for destination here in the core as well as in upper layers.
>
> (This is different with request packets.  There we pass destination node
> ID to upper layers because they may for example need to check whether
> this was an unicast or broadcast request.)
>
> Signed-off-by: Stefan Richter<stefanr@s5r6.in-berlin.de>
> ---
>   drivers/firewire/core-transaction.c |   11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
>
> Index: b/drivers/firewire/core-transaction.c
> ===================================================================
> --- a/drivers/firewire/core-transaction.c
> +++ b/drivers/firewire/core-transaction.c
> @@ -881,13 +881,12 @@ void fw_core_handle_response(struct fw_c
>   	unsigned long flags;
>   	u32 *data;
>   	size_t data_length;
> -	int tcode, tlabel, destination, source, rcode;
> +	int tcode, tlabel, source, rcode;
>
> -	tcode       = HEADER_GET_TCODE(p->header[0]);
> -	tlabel      = HEADER_GET_TLABEL(p->header[0]);
> -	destination = HEADER_GET_DESTINATION(p->header[0]);
> -	source      = HEADER_GET_SOURCE(p->header[1]);
> -	rcode       = HEADER_GET_RCODE(p->header[1]);
> +	tcode	= HEADER_GET_TCODE(p->header[0]);
> +	tlabel	= HEADER_GET_TLABEL(p->header[0]);
> +	source	= HEADER_GET_SOURCE(p->header[1]);
> +	rcode	= HEADER_GET_RCODE(p->header[1]);
>
>   	spin_lock_irqsave(&card->lock, flags);
>   	list_for_each_entry(t,&card->transaction_list, link) {
>


built good.. here's what I see now:

   LD      kernel/built-in.o
   CC [M]  fs/reiserfs/stree.o
   LD [M]  fs/reiserfs/reiserfs.o
   CC [M]  drivers/firewire/core-transaction.o
   LD [M]  drivers/firewire/firewire-core.o
   LD [M]  drivers/firewire/firewire-ohci.o
   LD [M]  drivers/firewire/firewire-sbp2.o
   CC [M]  drivers/ieee1394/sbp2.o
   CC [M]  drivers/net/wireless/hostap/hostap_80211_rx.o
   CC [M]  drivers/net/wireless/hostap/hostap_80211_tx.o
   CC [M]  drivers/net/wireless/hostap/hostap_ap.o

nice and clean!!

Reported-and-Tested-By: Justin P. Mattock <justinmattock@gmail.com>

Justin P. Mattock
