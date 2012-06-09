Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2FISnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 14:43:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60612 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab2FISnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 14:43:33 -0400
Message-ID: <4FD39904.2010808@mvista.com>
Date: Sat, 09 Jun 2012 22:42:12 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
CC: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org,
        mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu,
        bvanassche@acm.org, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 2/4] usb: storage: add support for write cache quirk
 on usb hdd
References: <1339263660-4039-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1339263660-4039-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/09/2012 09:41 PM, Namjae Jeon wrote:

> Add support for write cache quirk on usb hdd. scsi driver will be set to wce
> by detecting write cache quirk in quirk list when plugging usb hdd.

> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar<pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat<a.sahrawat@samsung.com>
> ---
>   drivers/usb/storage/scsiglue.c |    5 +++++
>   drivers/usb/storage/usb.c      |    5 ++++-
>   include/linux/usb_usual.h      |    4 +++-
>   3 files changed, 12 insertions(+), 2 deletions(-)

> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index a324a5d..fe42547 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
[...]
> @@ -529,6 +529,9 @@ static void adjust_quirks(struct us_data *us)
>   		case 'o':
>   			f |= US_FL_CAPACITY_OK;
>   			break;
> +		case 'p':
> +			f |= US_FL_WRITE_CACHE;
> +			break;
>   		case 'r':
>   			f |= US_FL_IGNORE_RESIDUE;
>   			break;

    You probably should unite this chunk with the documentation update patch.

> diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
> index 17df360..96fc152 100644
> --- a/include/linux/usb_usual.h
> +++ b/include/linux/usb_usual.h
> @@ -64,7 +64,9 @@
>   	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
>   		/* cannot handle READ_CAPACITY_16 */		\
>   	US_FLAG(INITIAL_READ10,	0x00100000)			\
> -		/* Initial READ(10) (and others) must be retried */
> +		/* Initial READ(10) (and others) must be retried */	\
> +	US_FLAG(WRITE_CACHE, 0x00200000)		\

    You've been already told to keep '\' at the same level with the above '\' 
and you're continuing to ignore this.

> +		/* Write Cache status is not available */
>
>   #define US_FLAG(name, value)	US_FL_##name = value ,
>   enum { US_DO_ALL_FLAGS };

WBR, Sergei
