Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab2LTUPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:15:50 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:53328 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751036Ab2LTUPm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:15:42 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Sasha Levin <sasha.levin@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Dec 2012 12:13:44 -0800
Subject: RE: [PATCH] wireless: mwifiex: remove unreachable paths
Thread-Topic: [PATCH] wireless: mwifiex: remove unreachable paths
Thread-Index: Ac3e5iJ51wt5nf3uTR+G8SgZJ6wKVgAB0iLw
Message-ID: <477F20668A386D41ADCC57781B1F70430D13D806CA@SC-VEXCH1.marvell.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-17-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1356030701-16284-17-git-send-email-sasha.levin@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

Thanks for the patch.

> We know 'firmware' is non-NULL from the beginning of mwifiex_prog_fw_w_helper,
> remove all !firmware paths from the rest of the function.

After removing all !firmware paths the function 'mwifiex_get_fw_data' becomes an orphan.

Could you please remove that function as well and resend a v2 patch?

Thanks,
Bing

> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/net/wireless/mwifiex/usb.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
> index 63ac9f2..8bd7098 100644
> --- a/drivers/net/wireless/mwifiex/usb.c
> +++ b/drivers/net/wireless/mwifiex/usb.c
> @@ -836,23 +836,14 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
>  			dlen = 0;
>  		} else {
>  			/* copy the header of the fw_data to get the length */
> -			if (firmware)
> -				memcpy(&fwdata->fw_hdr, &firmware[tlen],
> -				       sizeof(struct fw_header));
> -			else
> -				mwifiex_get_fw_data(adapter, tlen,
> -						    sizeof(struct fw_header),
> -						    (u8 *)&fwdata->fw_hdr);
> +			memcpy(&fwdata->fw_hdr, &firmware[tlen],
> +			       sizeof(struct fw_header));
> 
>  			dlen = le32_to_cpu(fwdata->fw_hdr.data_len);
>  			dnld_cmd = le32_to_cpu(fwdata->fw_hdr.dnld_cmd);
>  			tlen += sizeof(struct fw_header);
> 
> -			if (firmware)
> -				memcpy(fwdata->data, &firmware[tlen], dlen);
> -			else
> -				mwifiex_get_fw_data(adapter, tlen, dlen,
> -						    (u8 *)fwdata->data);
> +			memcpy(fwdata->data, &firmware[tlen], dlen);
> 
>  			fwdata->seq_num = cpu_to_le32(fw_seqnum);
>  			tlen += dlen;
> --
> 1.8.0

