Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab0GNSWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:22:48 -0400
Received: from mail.candelatech.com ([208.74.158.172]:51666 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab0GNSWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:22:47 -0400
Message-ID: <4C3E0073.7070302@candelatech.com>
Date: Wed, 14 Jul 2010 11:22:43 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
CC: Robert Hancock <hancockrwd@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression: 2.6.34 boot fails on E5405 system, bisected: 	de08e2c26
References: <4C3D067C.10507@candelatech.com>	<4C3D101E.5010605@candelatech.com>	<4C3D1942.1090207@gmail.com>	<4C3D1F82.1040907@candelatech.com> <AANLkTinDv7I4v51j-Lev9Ry_3DyVVv58lAyCQXZV1CwB@mail.gmail.com> <4C3DC64F.5040505@candelatech.com> <43F901BD926A4E43B106BF17856F0755EA8EE7E2@orsmsx508.amr.corp.intel.com> <4C3DEEAB.8090106@candelatech.com> <43F901BD926A4E43B106BF17856F0755EA8EEA18@orsmsx508.amr.corp.intel.com>
In-Reply-To: <43F901BD926A4E43B106BF17856F0755EA8EEA18@orsmsx508.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 11:19 AM, Pan, Jacob jun wrote:
>> -----Original Message-----
>> From: Ben Greear [mailto:greearb@candelatech.com]
>> Sent: Wednesday, July 14, 2010 10:07 AM
>> To: Pan, Jacob jun
>> Cc: Robert Hancock; linux-kernel; jbarnes@virtuousgeek.org
>> Subject: Re: Regression: 2.6.34 boot fails on E5405 system, bisected:
>> de08e2c26
>>
>> On 07/14/2010 08:36 AM, Pan, Jacob jun wrote:
>>> what is the config size of 10.1?
>>> ls -l /sys/bus/pci/devices/0000:00:10.1/config
>>>
>>> if that is 256, it might be related to this patch.
>>
>> That patch is already in 2.6.34.y (with slight white-space
>> change it seems:  space before<).
>>
>> I just posted a patch to lkml that fixes the problem for me,
>> based on a suggestion by Robert Hancock.
>>
>> I think this or something similar should to go 2.6.34.y stable
>> as well.
>>
>
>
> I have not seen the patch yet, but there is no guarantee that
> capabilities are always laid out in ascending address. So I think
> we cannot bail out when
> 	pcie_cap>>  20<= pos
>
> If that is some bug in the config space, can we fix it with some quirks?

No idea, but if it's on this one motherboard/device, I imagine it's somewhere
else as well.

Is there at least a maximum number of capabilities that can exist so that
you can limit the loop by that?

Thanks,
Ben

>
> Thanks,
>
> Jacob
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

