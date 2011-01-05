Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab1AECrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 21:47:01 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:37682 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801Ab1AECrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 21:47:00 -0500
Message-ID: <937D26C0B8F34219AB4C23C4CDEB146A@hacdom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        "David Brownell" <dbrownell@users.sourceforge.net>
References: <1293022667-2904-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20101229073330.GH8172@angua.secretlab.ca>
Subject: Re: [PATCH] spi: Fix rmmod module issue
Date: Wed, 5 Jan 2011 11:46:57 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
X-Hosting-Pf: 0
X-NAI-Spam-Score: 2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Wednesday, December 29, 2010 4:33 PM, Grant Likely wrote:
>> It seems when spi_unregister_master is called,
>> device_unregister is called 2 times.
>
> This should be fixed in mainline now.  Can you please retest?
Seeing "spi.c" from linux-next, I could confirm the issue has already fixed.
and our SPI test is OK.

Thanks,
---
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

----- Original Message ----- 
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>; 
<spi-devel-general@lists.sourceforge.net>; <linux-kernel@vger.kernel.org>
Sent: Wednesday, December 29, 2010 4:33 PM
Subject: Re: [PATCH] spi: Fix rmmod module issue


> On Wed, Dec 22, 2010 at 09:57:47PM +0900, Tomoya MORINAGA wrote:
>> It seems when spi_unregister_master is called,
>> device_unregister is called 2 times.
>
> This should be fixed in mainline now.  Can you please retest?
>
> Thanks,
> g.
>
>>
>> Fix the following issue when removes SPI module.
>> [ 1355.220625] BUG: unable to handle kernel NULL pointer dereference at 
>> 0000001c
>> [ 1355.220642] IP: [<c10fc551>] sysfs_find_dirent+0xa/0x3a
>> [ 1355.220662] *pde = 00000000
>> [ 1355.220671] Oops: 0000 [#1] SMP
>> [ 1355.220679] last sysfs file: /sys/power/state
>> [ 1355.220688] Modules linked in: spi_topcliff_pch(-) spidev
>> [ 1355.220700]
>> [ 1355.220710] Pid: 3838, comm: rmmod Not tainted 2.6.37-rc6+ #7 To be 
>> filled by O.E.M./To be filled by O.E.M.
>> [ 1355.220721] EIP: 0060:[<c10fc551>] EFLAGS: 00010286 CPU: 1
>> [ 1355.220730] EIP is at sysfs_find_dirent+0xa/0x3a
>> [ 1355.220739] EAX: 00000000 EBX: c14a2d38 ECX: c14a2d38 EDX: 00000000
>> [ 1355.220748] ESI: 00000000 EDI: c14a2d38 EBP: f6605e60 ESP: f6605e54
>> [ 1355.220757]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> [ 1355.220767] Process rmmod (pid: 3838, ti=f6604000 task=f1281d40 
>> task.ti=f6604000)
>> [ 1355.220774] Stack:
>> [ 1355.220779]  c14a2d38 00000000 00000000 f6605e74 c10fc5a2 f124ae00 
>> f124ae08 c1643080
>> [ 1355.220801]  f6605e88 c10fdfd4 f124ae00 00000001 f124a200 f6605e90 
>> c1211184 f6605ea4
>> [ 1355.220822]  c120c9d4 f124ae00 00000001 000001f4 f6605eb0 c120cafe 
>> f124ae00 f6605ebc
>> [ 1355.220844] Call Trace:
>> [ 1355.220856]  [<c10fc5a2>] ? sysfs_get_dirent+0x21/0x39
>> [ 1355.220868]  [<c10fdfd4>] ? sysfs_remove_group+0x1a/0x85
>> [ 1355.220881]  [<c1211184>] ? dpm_sysfs_remove+0x10/0x12
>> [ 1355.220894]  [<c120c9d4>] ? device_del+0x31/0x150
>> [ 1355.220906]  [<c120cafe>] ? device_unregister+0xb/0x15
>> [ 1355.220917]  [<c1244428>] ? spi_unregister_master+0x54/0x57
>> [ 1355.220932]  [<f80c95e7>] ? pch_spi_remove+0x89/0xb6 
>> [spi_topcliff_pch]
>> [ 1355.220946]  [<c11a0286>] ? pci_device_remove+0x19/0x39
>> [ 1355.220959]  [<c120e6d9>] ? __device_release_driver+0x58/0x8e
>> [ 1355.220971]  [<c120e76c>] ? driver_detach+0x5d/0x7b
>> [ 1355.220983]  [<c120dc81>] ? bus_remove_driver+0x6c/0x92
>> [ 1355.220995]  [<c120eb84>] ? driver_unregister+0x4d/0x54
>> [ 1355.221007]  [<c11a0454>] ? pci_unregister_driver+0x2d/0x6a
>> [ 1355.221019]  [<f80ca095>] ? pch_spi_exit+0xd/0x1b [spi_topcliff_pch]
>> [ 1355.221020]  [<c105ab7b>] ? sys_delete_module+0x180/0x1d8
>> [ 1355.221020]  [<c10a7900>] ? __vma_link_file+0x3d/0x61
>> [ 1355.221020]  [<c10bfbea>] ? path_put+0xe/0x23
>> [ 1355.221020]  [<c100290c>] ? sysenter_do_call+0x12/0x22
>> [ 1355.221020] Code: 89 c3 74 18 8b 00 85 c0 75 0f ba b7 00 00 00 b8 c3 
>> 5a 58 c1 e8 10 4b f3 ff f0 ff 03 89 d8 5b 5d c3 55 89 e5 57 89 cf 56 89 
>> d6 53 <8b> 58 1c eb 20 85 f6 74 0b 8
>> b 43 14 85 c0 74 04 39 f0 75 0e 8b
>> [ 1355.221020] EIP: [<c10fc551>] sysfs_find_dirent+0xa/0x3a SS:ESP 
>> 0068:f6605e54
>> [ 1355.221020] CR2: 000000000000001c
>> [ 1355.221237] ---[ end trace ac3358f2d325b0b5 ]---
>>
>> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
>> ---
>>  drivers/spi/spi.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
>> index 709c836..3c8ff6f 100644
>> --- a/drivers/spi/spi.c
>> +++ b/drivers/spi/spi.c
>> @@ -586,7 +586,6 @@ void spi_unregister_master(struct spi_master *master)
>>
>>  dummy = device_for_each_child(master->dev.parent, &master->dev,
>>  __unregister);
>> - device_unregister(&master->dev);
>>  }
>>  EXPORT_SYMBOL_GPL(spi_unregister_master);
>>
>> -- 
>> 1.6.0.6
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

