Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab1CCH7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:59:01 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48586 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793Ab1CCH7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:59:00 -0500
X-Sasl-enc: 5wffNwCseEEaf9rtkz04lzgZoF7Nto6ksSQmWuWvO2ka 1299139139
Message-ID: <4D6F4A43.5050903@fastmail.fm>
Date: Thu, 03 Mar 2011 07:58:59 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.14) Gecko/20110221 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jonathan_Neusch=E4fer?= <j.neuschaefer@gmx.net>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Al Cho <acho@novell.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: keucr: use kernel byteorder functions
References: <1299109694-28758-1-git-send-email-j.neuschaefer@gmx.net> <1299109694-28758-2-git-send-email-j.neuschaefer@gmx.net>
In-Reply-To: <1299109694-28758-2-git-send-email-j.neuschaefer@gmx.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -455,10 +457,10 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
>  			}
>  
>  			idi = &((MemStickBootBlockCIS_IDI *)(PageBuffer + (EntryOffset % MS_BYTES_PER_PAGE)))->idi.idi;
> -			if (LittleEndianWORD(idi->wIDIgeneralConfiguration) != MS_IDI_GENERAL_CONF)
> +			if (le16_to_cpu(idi->wIDIgeneralConfiguration) != MS_IDI_GENERAL_CONF)
>  				goto exit;
>  
> -			us->MS_Lib.BytesPerSector = LittleEndianWORD(idi->wIDIbytesPerSector);
> +			us->MS_Lib.BytesPerSector = be16_to_cpu(idi->wIDIbytesPerSector);

Shouldn't this be le16_to_cpu?

>  			if (us->MS_Lib.BytesPerSector != MS_BYTES_PER_PAGE)
>  				goto exit;
>  		}

Thanks,

Jack
