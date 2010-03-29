Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0C2Rpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:45:35 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:63295 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab0C2Rpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SUT6AGULqSpQR/3WnrPT+LRIquOHTeU+hgGS5mHZNwdNsYNLwgLjepw/zR5JyPh94m
         lBXghiys+5giMwnLZz8ELxQ9Z4ayEimbT5gQTnyf5xKvuCUbYn47tSeaU0sOdTVcKoI/
         yltDlbxk/7LW3ng87BiL2+oDYumqt1troL6GU=
MIME-Version: 1.0
In-Reply-To: <4BA4A19C.1010607@kernel.org>
References: <4BA42A95.4000301@kernel.org> <4BA4A19C.1010607@kernel.org>
Date: Mon, 29 Mar 2010 10:45:31 -0700
Message-ID: <4807377b1003291045r601cc1dx4d2a567f03ab6df6@mail.gmail.com>
Subject: Re: [PATCH] intel-iommu: don't call domain_exit if can not attach 
	with iommu
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>, jbarnes@virtuousgeek.org,
       David.Woodhouse@intel.com, len.brown@intel.com, chrisw@sous-sol.org,
       suresh.b.siddha@intel.com, mingo@elte.hu, yu.zhao@intel.com,
       fenghua.yu@intel.com, weidong@intel.com,
       iommu@lists.linux-foundation.org, gregory.v.rose@intel.com
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<added some cc>

If this patch fixes a bug can it be applied?  I hadn't seen any
followup, sorry if it was in another thread, I'm still catching up
after being out.

On Sat, Mar 20, 2010 at 3:21 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> found when a lot of ixgbevf are used with intel iommu, will get crash
>
>>
>> eth304 ip=192.171.178.102 mac=56:95:16:88:4C:C1 pci=0000:0e:18.3 drv=ixgbevf
>> eth305 ip=192.171.179.102 mac=D6:41:8C:4A:87:B3 pci=0000:0e:18.5 drv=ixgbevf
>> [ 9534.886519] BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000008
>> [ 9534.889775] Call Trace:
>> [ 9534.889775]  [<ffffffff81406a3d>] domain_remove_dev_info+0x34/0xcf
>> [ 9534.889775]  [<ffffffff81408a1d>] domain_exit+0x23/0xc4
>> [ 9534.889775]  [<ffffffff81409c1c>] T.953+0x173/0x342
>> [ 9534.889775]  [<ffffffff81409fd0>] __intel_map_single+0x63/0x1b3
>> [ 9534.889775]  [<ffffffff8140a22a>] intel_alloc_coherent+0xc7/0xee
>> [ 9534.889775]  [<ffffffff816c3e7d>] ? ixgbevf_setup_tx_resources+0x2f/0x12c
>> [ 9534.889775]  [<ffffffff816c3f36>] ixgbevf_setup_tx_resources+0xe8/0x12c
>> [ 9534.889775]  [<ffffffff816c42d2>] ixgbevf_open+0x7a/0x160
>> [ 9534.889775]  [<ffffffff81adf21e>] __dev_open+0x8e/0xbc
>> [ 9534.889775]  [<ffffffff81adb716>] __dev_change_flags+0xad/0x130
>> [ 9534.889775]  [<ffffffff81adf15a>] dev_change_flags+0x21/0x57
>> [ 9534.889775]  [<ffffffff81b211e5>] devinet_ioctl+0x29d/0x541
>> [ 9534.889775]  [<ffffffff810a4b92>] ? trace_hardirqs_off_caller+0x1f/0xa9
>> [ 9534.889775]  [<ffffffff81b22801>] inet_ioctl+0x8f/0xa7
>> [ 9534.889775]  [<ffffffff81acc258>] sock_do_ioctl+0x29/0x48
>> [ 9534.889775]  [<ffffffff81acca64>] sock_ioctl+0x1fe/0x20d
>> [ 9534.889775]  [<ffffffff8113b86a>] vfs_ioctl+0x32/0xa6
>> [ 9534.889775]  [<ffffffff8113bd04>] do_vfs_ioctl+0x2b0/0x2cb
>> [ 9534.889775]  [<ffffffff81033c4c>] ? sysret_check+0x27/0x62
>> [ 9534.889775]  [<ffffffff8113bd66>] sys_ioctl+0x47/0x6a
>> [ 9534.889775]  [<ffffffff81033c1b>] system_call_fastpath+0x16/0x1b
>> [ 9534.889775] Code: cd 7f cc ff 41 54 9d 48 83 c4 20 5b 41 5c 41 5d 41
>> 5e c9 c3 55 48 89 e5 e8 11 ff ff ff c9 c3 55 48 89 e5 53 48 89 fb 48 83
>> ec 08 <48> 8b 47 08 4c 8b 00 49 39 f8 74 1d 48 89 f9 48 c7 c2 7f e9 18
>> [ 9534.889775] RIP  [<ffffffff813ddf94>] list_del+0xc/0x8b
>> [ 9534.889775]  RSP <ffff88c070373af8>
>> [ 9534.889775] CR2: 0000000000000008
>> [ 9534.889775] ---[ end trace 072bd8cdb08a760c ]---
>> xifconfig8_2x_vf.sh: line 10: 28555 Killed                  ifconfig
>> $DEV $IP
>>
>
> when intel_iommu=off or iommu=pt is used, will work well.
>
> root cause:
> domain is initialized after trying attached it,
>
> if it can not be attached, don't call domain_exit yet. it will cause kernel crash in domain_exit()
>
> after patch will will get error instead of crash.
>
> [ 1781.910241] IOMMU: no free domain ids
> [ 1781.910244] Allocating domain for 0000:d0:1f.5 failed
> SIOCSIFFLAGS: Cannot allocate memory
>
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Index: linux-2.6/drivers/pci/intel-iommu.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/intel-iommu.c
> +++ linux-2.6/drivers/pci/intel-iommu.c
> @@ -1853,7 +1857,7 @@ static struct dmar_domain *get_domain_fo
>
>        ret = iommu_attach_domain(domain, iommu);
>        if (ret) {
> -               domain_exit(domain);
> +               free_domain_mem(domain);
>                goto error;
>        }
>
