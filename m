Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934874Ab2J3WJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:09:10 -0400
Received: from tee.schottelius.org ([77.109.138.222]:58256 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934669Ab2J3WJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:09:03 -0400
Date: Tue, 30 Oct 2012 11:35:35 +0100
From: Nico Schottelius <nico-kernel20120920@schottelius.org>
To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
        Valdis.Kletnieks@vt.edu, David Rientjes <rientjes@google.com>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: Re: Out of memory on 3.5 kernels
Message-ID: <20121030103535.GA10526@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	Valdis.Kletnieks@vt.edu, David Rientjes <rientjes@google.com>,
	Arend van Spriel <arend@broadcom.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net
References: <505B1FA0.6030100@broadcom.com>
 <20120921194931.GA732@schottelius.org>
 <alpine.DEB.2.00.1209241538310.6356@chino.kir.corp.google.com>
 <20120926060653.GD16575@schottelius.org>
 <20120926085708.GA7839@schottelius.org>
 <20120927055208.GA25252@schottelius.org>
 <20121003212311.GA14018@schottelius.org>
 <22962.1349452084@turing-police.cc.vt.edu>
 <20121005175139.GC831@schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20121005175139.GC831@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.6.2-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning,

update: this problem still exists on 3.6.2-1-ARCH and it got worse:

I reformatted the external disk to use xfs, but as the my
root filesystem is still jfs, it still appears:

 Active / Total Objects (% used)    : 642732 / 692268 (92.8%)
 Active / Total Slabs (% used)      : 24801 / 24801 (100.0%)
 Active / Total Caches (% used)     : 79 / 111 (71.2%)
 Active / Total Size (% used)       : 603522.30K / 622612.05K (96.9%)
 Minimum / Average / Maximum Object : 0.01K / 0.90K / 15.25K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
475548 467649  98%    1.21K  18722       26    599104K jfs_ip
 25670  19143  74%    0.05K    302       85      1208K shared_policy_node
 24612  16861  68%    0.19K   1172       21      4688K dentry
 24426  19524  79%    0.17K   1062       23      4248K vm_area_struct
 21636  21180  97%    0.11K    601       36      2404K sysfs_dir_cache
 12352   9812  79%    0.06K    193       64       772K kmalloc-64
 11684   9145  78%    0.09K    254       46      1016K anon_vma
  9855   8734  88%    0.58K    365       27      5840K inode_cache
  9728   9281  95%    0.01K     19      512        76K kmalloc-8
  8932   4411  49%    0.55K    319       28      5104K radix_tree_node
  6336   5760  90%    0.25K    198       32      1584K kmalloc-256
  5632   5632 100%    0.02K     22      256        88K kmalloc-16
  4998   2627  52%    0.09K    119       42       476K kmalloc-96
  4998   3893  77%    0.04K     49      102       196K Acpi-Namespace
  4736   3887  82%    0.03K     37      128       148K kmalloc-32
  4144   4144 100%    0.07K     74       56       296K Acpi-ParseExt
  3740   3740 100%    0.02K     22      170        88K numa_policy
  3486   3023  86%    0.19K    166       21       664K kmalloc-192
  3200   2047  63%    0.12K    100       32       400K kmalloc-128
  2304   2074  90%    0.50K     72       32      1152K kmalloc-512
  2136   2019  94%    0.64K     89       24      1424K proc_inode_cache
  2080   2080 100%    0.12K     65       32       260K jfs_mp
  2024   1890  93%    0.70K     88       23      1408K shmem_inode_cache
  1632   1556  95%    1.00K     51       32      1632K kmalloc-1024


I am wondering if anyone is feeling responsible for this bug or if the mid-term
solution is to move away from jfs?

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
