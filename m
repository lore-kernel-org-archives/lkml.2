Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab2DJMWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 08:22:40 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:45372
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758361Ab2DJMWi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 08:22:38 -0400
X-SpamScore: -8
X-BigFish: PS-8(zz1432N98dKzz1202hzz8275ch8275bhz2ei2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:198.70.193.64;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
Date: Tue, 10 Apr 2012 08:22:29 -0400
From: Chad Dupuis <chad.dupuis@qlogic.com>
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 19/26] [SCSI] qla2xxx: Remove redundant NULL check before
 release_firmware() call.
In-Reply-To: <alpine.LNX.2.00.1204092229370.13925@swampdragon.chaosbits.net>
Message-ID: <alpine.WNT.2.00.1204100821500.5072@N5102REMCQXM4BS.qlogic.org>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net> <alpine.LNX.2.00.1204092229370.13925@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
X-X-Sender: cdupuis@qlm.qlogic.com
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 9 Apr 2012, Jesper Juhl wrote:

> release_firmware() checks for NULL pointers internally so checking
> before calling it is redundant.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> drivers/scsi/qla2xxx/qla_os.c |    3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index a2f9992..91b6fe6 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4106,8 +4106,7 @@ qla2x00_release_firmware(void)
>
>       mutex_lock(&qla_fw_lock);
>       for (idx = 0; idx < FW_BLOBS; idx++)
> -             if (qla_fw_blobs[idx].fw)
> -                     release_firmware(qla_fw_blobs[idx].fw);
> +             release_firmware(qla_fw_blobs[idx].fw);
>       mutex_unlock(&qla_fw_lock);
> }
>
>

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

