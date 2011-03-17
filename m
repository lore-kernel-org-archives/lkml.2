Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1CQOQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:16:38 -0400
Received: from mx1.guavus.com ([204.232.241.167]:49412 "EHLO mx1.guavus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab1CQOQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:16:36 -0400
From: Preeti Khurana <Preeti.Khurana@guavus.com>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: rcu_sched_state detected stall on CPU issue
Thread-Topic: rcu_sched_state detected stall on CPU issue
Thread-Index: AQHL5DjRyp5tGIVRmkGAvfFAk36UcJQwcGkAgAEcutA=
Date: Thu, 17 Mar 2011 14:11:39 +0000
Message-ID: <9F0C2539CB50A743894F8FCEEB1D56920818B0@mx1.guavus.com>
References: <20110316101820.GA17540@linux.vnet.ibm.com>
 <20110317085938.C938.A69D9226@jp.fujitsu.com>
 <20110317022506.GG2304@linux.vnet.ibm.com>
In-Reply-To: <20110317022506.GG2304@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > > Any thoughts or recent patches that might help?
> >
> > We fixed a kswapd infinite loop issue when memory is fragmented at
> 2.6.38.
> > Could you please try following commits? (all are mm/vmscan.c change)
> >
> > commit dc83edd941f412e938841b4989be24aa288a1aa6
> > commit 355b09c47a0cbb73b3e65a57c03f157f2e7ddb0b
> > commit 4d40502ea580c35414a1466d86f96484910ebaec
> > commit 0abdee2bd4118366c62349a304f81537be69af33
> > commit 1741c87757448cedd03224f01586504f9256415d
> > commit 9950474883e027e6e728cbcff25f7f2bf0c96530
> 
> Thank you, Kosaki!

    I will try patching with the commits & test the same, though patches don't cleanly fit because they are on top of the changes which are not there in 2.6.35  ( have come in 2.6.37), so it's a lttle challenge.
Meanwhile, I  am trying out the changes specified in thread https://lkml.org/lkml/2011/1/6/131 because I think that also might issue.

> 
> > And, your attached file and your quoted mail don't have /proc/zoneinfo
> > information. then I have no way to confirn his environment is heavy
> > fragmented or not. If possible, could you please get /proc/zoneinfo
> > info?
> 
> Preeti, could you please send this info and try out the above patches?

  Output of /proc/zoneinfo at the time of stall :


Node 0, zone   Normal
  pages free     7484
        min      4982
        low      6227
        high     7473
        scanned  0
        spanned  12582912
        present  12410880
    nr_free_pages 7422
    nr_inactive_anon 42096
    nr_active_anon 882918
    nr_inactive_file 5635172
    nr_active_file 5635111
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 924987
    nr_mapped    1208
    nr_file_pages 11270146
    nr_dirty     49494
    nr_writeback 0
    nr_slab_reclaimable 169648
    nr_slab_unreclaimable 4202
    nr_page_table_pages 2271
    nr_kernel_stack 295
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 291
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     27
    numa_hit     225959693
    numa_miss    20838462
    numa_foreign 69636123
    numa_interleave 27282
    numa_local   225959685
    numa_other   20838470
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 172
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 1
              count: 165
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 2
              count: 60
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 3
              count: 0
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 4
              count: 63
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 5
              count: 94
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 6
              count: 63
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 7
              count: 0
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 8
              count: 55
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 9
              count: 0
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 10
              count: 41
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 11
              count: 112
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 12
              count: 75
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 13
              count: 18
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 14
              count: 171
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 15
              count: 0
              high:  186
              batch: 31
  vm stats threshold: 100
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         12845056
  inactive_ratio:    21
Node 1, zone      DMA
  pages free     3979
        min      1
        low      1
        high     1
        scanned  0
        spanned  4095
        present  3943
    nr_free_pages 3979
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 0
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
    numa_hit     0
    numa_miss    0
    numa_foreign 0
    numa_interleave 0
    numa_local   0
    numa_other   0
        protection: (0, 2987, 48437, 48437)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 2
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 3
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 4
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 5
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 6
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 7
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 8
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 9
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 10
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 11
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 12
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 13
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 14
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
    cpu: 15
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 10
  all_unreclaimable: 1
  prev_priority:     12
  start_pfn:         1
  inactive_ratio:    1
Node 1, zone    DMA32
  pages free     45968
        min      307
        low      383
        high     460
        scanned  0
        spanned  1044480
        present  764849
    nr_free_pages 45968
    nr_inactive_anon 9708
    nr_active_anon 38161
    nr_inactive_file 291211
    nr_active_file 291169
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 47869
    nr_mapped    50
    nr_file_pages 582385
    nr_dirty     1897
    nr_writeback 0
    nr_slab_reclaimable 81872
    nr_slab_unreclaimable 115
    nr_page_table_pages 98
    nr_kernel_stack 2
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 116
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     0
    numa_hit     6109982
    numa_miss    9113118
    numa_foreign 0
    numa_interleave 0
    numa_local   6109665
    numa_other   9113435
        protection: (0, 0, 45450, 45450)
  pagesets
    cpu: 0
              count: 65
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 1
              count: 181
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 2
              count: 46
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 3
              count: 27
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 4
              count: 78
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 5
              count: 33
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 6
              count: 0
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 7
              count: 57
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 8
              count: 90
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 9
              count: 166
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 10
              count: 65
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 11
              count: 25
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 12
              count: 29
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 13
              count: 29
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 14
              count: 0
              high:  186
              batch: 31
  vm stats threshold: 60
    cpu: 15
              count: 77
              high:  186
              batch: 31
  vm stats threshold: 60
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096
  inactive_ratio:    4
Node 1, zone   Normal
  pages free     6028
        min      4670
        low      5837
        high     7005
        scanned  0
        spanned  11796480
        present  11635200
    nr_free_pages 6028
    nr_inactive_anon 27762
    nr_active_anon 554870
    nr_inactive_file 5417543
    nr_active_file 5416505
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 582591
    nr_mapped    2512
    nr_file_pages 10834147
    nr_dirty     24700
    nr_writeback 0
    nr_slab_reclaimable 169345
    nr_slab_unreclaimable 1736
    nr_page_table_pages 1640
    nr_kernel_stack 32
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 143
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     45
    numa_hit     154438673
    numa_miss    60523005
    numa_foreign 20838462
    numa_interleave 27227
    numa_local   154411416
    numa_other   60550262
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 149
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 1
              count: 154
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 2
              count: 43
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 3
              count: 175
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 4
              count: 46
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 5
              count: 57
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 6
              count: 0
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 7
              count: 104
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 8
              count: 92
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 9
              count: 21
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 10
              count: 147
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 11
              count: 168
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 12
              count: 0
              high:  186
              batch: 31
  vm stats threshold: 100
             count: 92
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 9
              count: 21
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 10
              count: 147
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 11
              count: 168
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 12
              count: 0
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 13
              count: 46
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 14
              count: 146
              high:  186
              batch: 31
  vm stats threshold: 100
    cpu: 15
              count: 180
              high:  186
              batch: 31
  vm stats threshold: 100
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         1048576
  inactive_ratio:    20

