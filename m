Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1ICD7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 23:59:30 -0400
Received: from nm3.bullet.mail.ird.yahoo.com ([77.238.189.60]:46302 "HELO
	nm3.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753644Ab1ICD71 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 23:59:27 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 11829.79756.bm@omp1032.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=uD7EPA/PRnw/4kS5yhAtf2HYkGvjducEk5sKTQtxMcPqiXJX63u7yfklwrKMyx4AaGYNajJQB74BdxAVR/wKhInoYtsJtbzM+vC6SE+A+ZNZmRDWxqt6xGCCfRKkQEnwRiGv7rdXifUwlpuVTpugBmAeUrpwc1UknQNoVPv76Xw=;
X-YMail-OSG: 59IbMrwVM1m3D_KAyBOkv8vG9ccpty54oB4gJ4x9IJARoD3
 N8rO_g1vfwGtZk6NFVQ7SfoRIy346T5rkgaIyc0eyHSH6LmaFsNt3mEsB35z
 y6I0e7pARnLw2xTP9bzoqxwnG_KHEXG4jzKZ2X0TBZvms9.gwXj5PAhh9UpX
 tcRm1UFXvlKrbn6unz5QV4PKK7RWsMJHd.XlMlXHjG1uVKta5n4lC0PMb4pG
 Vrql_zsSSeic6z4uchP3F.2kSXCqWhGuGkEZrWJgpQajlPjAf38RHObZ234d
 4ZN9SzYlhjcn7KRd4hc8RQwDB54MSuQ6l6veYJxDrN49xzmiDQrmwZfqQ6vC
 wQvIhGz2QPeFJU4zMLB8tQ1j4dgqfAw4_78GMOSMefmrwjAVZ1zdotgekCGC
 PalRVILpkh6z8K80O.ByM
X-Mailer: YahooMailClassic/14.0.5 YahooMailWebService/0.8.113.315625
Message-ID: <1315022365.50883.YahooMailClassic@web29510.mail.ird.yahoo.com>
Date: Sat, 3 Sep 2011 04:59:25 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: linux-fsdevel@vger.kernel.org, Pavel Ivanov <paivanof@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CAG1a4ruWCARq5NLXSDo9Hmc6i2d5XDeuwJTKEqyeOm20hcO66A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Sat, 3/9/11, Pavel Ivanov <paivanof@gmail.com> wrote:

> Hi,
> 
> With kernel 3.1.0-rc4 any attempt to connect iPod to USB
> leads to
> kernel oops. I'd say that stacktrace of the oops is pretty
> much random
> and not related to HFS. But I was able to get useful info
> from it when
> I recompiled with CONFIG_SLUB_DEBUG_ON=y. In this case I
> don't get
> oops but the following instead:

There are a few hfsplus related changes to do protection against invalid data like this, but may be there are more. It would be useful to have the output from your 
objdump -l -d hfsplus.ko | grep  -A 1000 '<hfsplus_fill_super>'
(the -l gives line numbers against the kernel tree, so would be useful if you run this against the ko there...)

> 
> [   81.508807] hfs: filesystem size too
> large.
> [   81.559295]
> =============================================================================
> [   81.656965] BUG kmalloc-4096: Invalid
> object pointer 0xffff880136160400
> [   81.735947]
> -----------------------------------------------------------------------------
> [   81.735948]
> [   81.851359] INFO: Slab 0xffffea0004d85800
> objects=7 used=7 fp=0x
>       (null) flags=0x2000000000004081
> [   81.965628] Pid: 2086, comm:
> ipod-set-info Not tainted 3.1.0-rc4+ #2
> [   81.965629] Call Trace:
> [   81.965636] 
> [<ffffffff8119359f>] slab_err+0xaf/0xd0
> [   81.965640] 
> [<ffffffff8119381f>] ? slab_pad_check+0xaf/0x1a0
> [   81.965644] 
> [<ffffffff8119719f>]
> free_debug_processing+0x1ef/0x310
> [   81.965647] 
> [<ffffffff811974ba>] __slab_free+0x1fa/0x490
> [   81.965653] 
> [<ffffffffa0516c4d>] ? hfsplus_fill_super+0x2ed/0x610
> [hfsplus]
> [   81.965656] 
> [<ffffffff81197a3c>] kfree+0x12c/0x150
> [   81.965660] 
> [<ffffffffa0516c4d>] hfsplus_fill_super+0x2ed/0x610
> [hfsplus]
> [   81.965665] 
> [<ffffffff81438771>] ?
> ioctl_internal_command.clone.4+0x61/0x1b0
> [   81.965671] 
> [<ffffffff8161fe9e>] ? _raw_spin_unlock+0xe/0x40
> [   81.965675] 
> [<ffffffff81195eb8>] ? deactivate_slab+0x578/0x750
> [   81.965679] 
> [<ffffffff811af3cb>] ? sget+0xab/0x480
> [   81.965683] 
> [<ffffffff8133f0c9>] ? put_dec+0x59/0x60
> [   81.965685] 
> [<ffffffff813407d1>] ? number.clone.2+0x311/0x350
> [   81.965690] 
> [<ffffffff8116bd7b>] ? pcpu_alloc_area+0x10b/0x2c0
> [   81.965693] 
> [<ffffffff81341b81>] ? vsnprintf+0x471/0x610
> [   81.965696] 
> [<ffffffff8116c639>] ? pcpu_alloc+0x399/0x9e0
> [   81.965699] 
> [<ffffffff81341dc4>] ? snprintf+0x34/0x40
> [   81.965702] 
> [<ffffffff8133ebc6>] ? strlcpy+0x46/0x60
> [   81.965707] 
> [<ffffffff8115bfb2>] ? register_shrinker+0x52/0x60
> [   81.965710] 
> [<ffffffff811afa26>] mount_bdev+0x1c6/0x210
> [   81.965714] 
> [<ffffffffa0516960>] ? hfsplus_iget+0x240/0x240
> [hfsplus]
> [   81.965718] 
> [<ffffffffa05160a5>] hfsplus_mount+0x15/0x20
> [hfsplus]
> [   81.965720] 
> [<ffffffff811b0547>] mount_fs+0x47/0x1c0
> [   81.965723] 
> [<ffffffff8116cc90>] ? __alloc_percpu+0x10/0x20
> [   81.965727] 
> [<ffffffff811ca383>] vfs_kern_mount+0x63/0xd0
> [   81.965731] 
> [<ffffffff811cb4d4>] do_kern_mount+0x54/0x110
> [   81.965734] 
> [<ffffffff811cd022>] do_mount+0x502/0x7e0
> [   81.965736] 
> [<ffffffff8116738b>] ? strndup_user+0x5b/0x80
> [   81.965739] 
> [<ffffffff811cd710>] sys_mount+0x90/0xe0
> [   81.965744] 
> [<ffffffff81627402>] system_call_fastpath+0x16/0x1b
> [   81.965746] FIX kmalloc-4096: Object at
> 0xffff880136160400 not freed
> 
> Following by 2 other bugs with the same stack trace.
> 
> (BTW, before oops first message "hfs: filesystem size too
> large"
> always appears twice.)
> 
> 
> Another question: is hfsplus supposed to work at all? I see
> it's
> marked as "Orphaned" in MAINTAINERS and on attempt to
> connect iPod
> with kernel 2.6.38.11 (standard kernel in Ubuntu 11.04) I
> still don't
> get it working. Although without oops I get the following
> messages:
> 
> [   65.479360] usb 2-3: new high speed USB
> device using ehci_hcd and address 4
> [   65.686470] usbcore: registered new
> interface driver uas
> [   65.706455] Initializing USB Mass Storage
> driver...
> [   65.706901] scsi4 : usb-storage 2-3:1.0
> [   65.707251] usbcore: registered new
> interface driver usb-storage
> [   65.707254] USB Mass Storage support
> registered.
> [   66.702320] scsi 4:0:0:0:
> Direct-Access     Apple   
> iPod
>   1.62 PQ: 0 ANSI: 0
> [   66.704537] sd 4:0:0:0: Attached scsi
> generic sg2 type 0
> [   66.809047] sd 4:0:0:0: [sdb] 1946049
> 4096-byte logical blocks:
> (7.97 GB/7.42 GiB)
> [   66.809930] sd 4:0:0:0: [sdb] Write
> Protect is off
> [   66.809935] sd 4:0:0:0: [sdb] Mode Sense:
> 68 00 00 08
> [   66.809938] sd 4:0:0:0: [sdb] Assuming
> drive cache: write through
> [   66.885037] sd 4:0:0:0: [sdb] 1946049
> 4096-byte logical blocks:
> (7.97 GB/7.42 GiB)
> [   66.885933] sd 4:0:0:0: [sdb] Assuming
> drive cache: write through
> [   66.979400]  sdb: [mac] sdb1 sdb2
> [   66.981940] sd 4:0:0:0: [sdb] 1946049
> 4096-byte logical blocks:
> (7.97 GB/7.42 GiB)
> [   66.982834] sd 4:0:0:0: [sdb] Assuming
> drive cache: write through
> [   67.055808] sd 4:0:0:0: [sdb] Attached
> SCSI removable disk
> [   67.299357] sd 4:0:0:0: [sdb] Bad block
> number requested
> [   67.362982] hfs: unable to find HFS+
> superblock
> [   67.499457] sd 4:0:0:0: [sdb] Bad block
> number requested
> [   67.563085] hfs: unable to find HFS+
> superblock
> 
> 
> Thank you,
> Pavel
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
