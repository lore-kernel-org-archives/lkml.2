Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab1HZQmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:42:37 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2158 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab1HZQme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:42:34 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4E57CCEC.9060000@broadcom.com>
Date: Fri, 26 Aug 2011 09:42:20 -0700
From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.20)
 Gecko/20110804 Thunderbird/3.1.12
MIME-Version: 1.0
To: "Randy Dunlap" <rdunlap@xenotime.net>
cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "robert.w.love@intel.com" <robert.w.love@intel.com>,
        "devel@open-fcoe.org" <devel@open-fcoe.org>
Subject: Re: linux-next: Tree for Aug 25
References: <20110825163515.0ed2cf354f61a3e9c53564b2@canb.auug.org.au>
 <885a6d6210a7d4c56601380f146e7ba9.squirrel@xenotime.net>
In-Reply-To: <885a6d6210a7d4c56601380f146e7ba9.squirrel@xenotime.net>
X-WSS-ID: 624911D64R02667209-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/2011 12:26 AM, Randy Dunlap wrote:
>
> On Wed, August 24, 2011 11:35 pm, Stephen Rothwell wrote:
>> Hi all,
>>
>> The powerpc allyesconfig build still fails today.
>
>
> CONFIG_FCOE is not enabled:
>
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c: In function 'bnx2fc_net_config':
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:765: error: 'NETDEV_FCOE_WWNN'
> undeclared (first use in this function)
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:771: error: 'NETDEV_FCOE_WWPN'
> undeclared (first use in this function)
>
>
> Maybe this driver should select FCOE?
bnx2fc does not depend on FCOE. Instead both fcoe and bnx2fc drivers 
depend on LIBFCOE.  So, I'll modify to access 
NETDEV_FCOE_WWNN/NETDEV_FCOE_WWPN when CONFIG_LIBFCOE  is enabled.

Patch will be submitted soon.

Thanks,
Bhanu
>
> ~Randy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


