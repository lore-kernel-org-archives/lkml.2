Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab0FNWfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:35:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49293 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab0FNWfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:35:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JrklNoq77TGqn0dHdVHJchfBLxGomGszEHhHyRqpBguGCe03op9oZTryINnHaV+inX
         jeY0k6HvlrM+wzh+eZL2fp8CTT8LWaaGKiPRMfZ89EKTI6Ar6NOli2hjRxSvaQvVuBpS
         X8qee21nDw+o+sYfYh0vDFH/yABobAtKEEfEI=
Message-ID: <4C16AECD.50506@gmail.com>
Date: Mon, 14 Jun 2010 15:35:57 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH] ieee1394: sbp2: remove unused code
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-8-git-send-email-justinmattock@gmail.com> <tkrat.6f2ad8e8a9e281c2@s5r6.in-berlin.de>
In-Reply-To: <tkrat.6f2ad8e8a9e281c2@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 02:44 PM, Stefan Richter wrote:
> which caused gcc 4.6 to warn about
>      variable 'unit_characteristics' set but not used.
>
> The underlying problem that was spotted here --- an incomplete
> implementation --- is already 50% fixed in drivers/firewire/sbp2.c which
> observes mgt_ORB_timeout but not yet ORB_size.
>
> Reported-by: Justin P. Mattock<justinmattock@gmail.com>
> Signed-off-by: Stefan Richter<stefanr@s5r6.in-berlin.de>
> ---
>   drivers/ieee1394/sbp2.c |   11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)
>
> Index: b/drivers/ieee1394/sbp2.c
> ===================================================================
> --- a/drivers/ieee1394/sbp2.c
> +++ b/drivers/ieee1394/sbp2.c
> @@ -1350,12 +1350,11 @@ static void sbp2_parse_unit_directory(st
>   	struct csr1212_keyval *kv;
>   	struct csr1212_dentry *dentry;
>   	u64 management_agent_addr;
> -	u32 unit_characteristics, firmware_revision, model;
> +	u32 firmware_revision, model;
>   	unsigned workarounds;
>   	int i;
>
>   	management_agent_addr = 0;
> -	unit_characteristics = 0;
>   	firmware_revision = SBP2_ROM_VALUE_MISSING;
>   	model = ud->flags&  UNIT_DIRECTORY_MODEL_ID ?
>   				ud->model_id : SBP2_ROM_VALUE_MISSING;
> @@ -1372,17 +1371,15 @@ static void sbp2_parse_unit_directory(st
>   				lu->lun = ORB_SET_LUN(kv->value.immediate);
>   			break;
>
> -		case SBP2_UNIT_CHARACTERISTICS_KEY:
> -			/* FIXME: This is ignored so far.
> -			 * See SBP-2 clause 7.4.8. */
> -			unit_characteristics = kv->value.immediate;
> -			break;
>
>   		case SBP2_FIRMWARE_REVISION_KEY:
>   			firmware_revision = kv->value.immediate;
>   			break;
>
>   		default:
> +			/* FIXME: Check for SBP2_UNIT_CHARACTERISTICS_KEY
> +			 * mgt_ORB_timeout and ORB_size, SBP-2 clause 7.4.8. */
> +
>   			/* FIXME: Check for SBP2_DEVICE_TYPE_AND_LUN_KEY.
>   			 * Its "ordered" bit has consequences for command ORB
>   			 * list handling. See SBP-2 clauses 4.6, 7.4.11, 10.2 */
>


perfect!! compiled without any warning
with that one..
thanks for the reply and patch..

FWIW if you have time there's these guys as well
that I never looked at:

   CC [M]  drivers/firewire/core-transaction.o
drivers/firewire/core-transaction.c: In function 'fw_core_handle_response':
drivers/firewire/core-transaction.c:835:21: warning: variable 
'destination' set but not used
   CC [M]  drivers/firewire/ohci.o

   CC [M]  drivers/ieee1394/raw1394.o
drivers/ieee1394/raw1394.c: In function 'arm_write':
drivers/ieee1394/raw1394.c:1018:39: warning: variable 'length_conflict' 
set but not used
drivers/ieee1394/raw1394.c: In function 'arm_lock64':
drivers/ieee1394/raw1394.c:1373:11: warning: 'old' may be used 
uninitialized in this function
drivers/ieee1394/raw1394.c: In function 'arm_lock':
drivers/ieee1394/raw1394.c:1155:12: warning: 'old' may be used 
uninitialized in this function


  CC [M]  drivers/ieee1394/dv1394.o
drivers/ieee1394/dv1394.c: In function 'frame_prepare':
drivers/ieee1394/dv1394.c:613:15: warning: variable 'ts_off' set but not 
used
drivers/ieee1394/dv1394.c: In function 'ir_tasklet_func':
drivers/ieee1394/dv1394.c:2007:22: warning: variable 'packet_time' set 
but not used
drivers/ieee1394/dv1394.c: In function 'dv1394_host_reset':
drivers/ieee1394/dv1394.c:2323:18: warning: variable 'ohci' set but not used
   CC [M]  drivers/ieee1394/eth1394.o
drivers/ieee1394/eth1394.c: In function 'ether1394_iso':
drivers/ieee1394/eth1394.c:1261:23: warning: variable 'priv' set but not 
used
   LD      drivers/ieee802154/built-in.o


I can test and see!!

Justin P. Mattock
