Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab2GZBli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 21:41:38 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20848 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2GZBlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 21:41:37 -0400
Message-ID: <5010A067.8050300@oracle.com>
Date: Thu, 26 Jul 2012 09:41:59 +0800
From: "zhenzhong.duan" <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: khali@linux-fr.org, linux-kernel@vger.kernel.org,
        Feng Jin <joe.jin@oracle.com>
Subject: Re: [PATCH 2/2] Fetch dmi version from SMBIOS if it exist
References: <500FD2E5.3010307@oracle.com> <20120725125518.d89b78a6.akpm@linux-foundation.org>
In-Reply-To: <20120725125518.d89b78a6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



于 2012-07-26 03:55, Andrew Morton 写道:
> On Wed, 25 Jul 2012 19:05:09 +0800
> "zhenzhong.duan"<zhenzhong.duan@oracle.com>  wrote:
>
>> The right dmi version is in SMBIOS if it's zero in DMI region
>>
> This description is too brief to permit me to understand the patch.
> Can you please provide a more detailed explanation?
>
This issue was originally found from an oracle bug.
One customer noticed system UUID doesn't match between dmidecode & uek2.
HP ProLiant BL460c G6 :
# cat /sys/devices/virtual/dmi/id/product_uuid
00000000-0000-4C48-3031-4D5030333531
# dmidecode | grep -i uuid
UUID: 00000000-0000-484C-3031-4D5030333531
 From SMBIOS 2.6 on, spec use little-endian encoding for UUID other than 
network byte order.
So we need to get dmi version to distinguish. If version is 0.0, the 
real version is taken from the SMBIOS version. This is part of original 
kernel comment in code.

thanks
zduan
