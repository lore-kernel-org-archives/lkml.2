Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1EPM3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:29:55 -0400
Received: from lo.gmane.org ([80.91.229.12]:40138 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab1EPM3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:29:54 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ulrich Keller <uhkeller@googlemail.com>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
Date: Mon, 16 May 2011 12:29:31 +0000 (UTC)
Message-ID: <loom.20110516T141956-898@post.gmane.org>
References: <4DAF6C0B.3070009@gmx.de> <loom.20110511T124036-180@post.gmane.org> <20110512140352.GG11579@random.random> <loom.20110516T110647-285@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 88.68.215.108 (Mozilla/5.0 (X11; Linux i686; rv:2.0.1) Gecko/20110429 Firefox/4.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't have to wait until tomorrow, the problem just occurred again. I was
using Gnome Shell with three instances of R in separate EMACS sessions, Java
(JabRef), Evolution and Totem playing a video file. Shortly after starting the
video, Gnome Shell froze. I could switch to a tty and iotop showed totem,
gnome-shell and khugepaged at 99% IO. I managed to kill Totem and then Gnome
Shell, which respawned and let me save my work before rebooting.

I did a "cat /proc/zoneinfo" four times, the last time is after killing and
restartong Gnome Shell. I forgot to do SYSRQ+T, sorry. I'll remember it the next
time, shouldn't be long...

1st /proc/zoneinfo:

Node 0, zone      DMA
  pages free     3270
        min      196
        low      245
        high     294
        scanned  0
        spanned  4080
        present  3951
    nr_free_pages 3270
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 594
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 706
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 2
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 298
    nr_shmem     0
    nr_dirtied   1414
    nr_written   1414
    nr_anon_transparent_hugepages 0
        protection: (0, 865, 3023, 3023)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 0
  start_pfn:         16
  inactive_ratio:    1
Node 0, zone   Normal
  pages free     18200
        min      11003
        low      13753
        high     16504
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 18200
    nr_inactive_anon 69521
    nr_active_anon 48778
    nr_inactive_file 37202
    nr_active_file 16530
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 14029
    nr_mapped    175
    nr_file_pages 55304
    nr_dirty     91
    nr_writeback 0
    nr_slab_reclaimable 15225
    nr_slab_unreclaimable 2797
    nr_page_table_pages 1134
    nr_kernel_stack 319
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 1023
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     1750
    nr_dirtied   1215288
    nr_written   958209
    nr_anon_transparent_hugepages 100
        protection: (0, 0, 17262, 17262)
  pagesets
    cpu: 0
              count: 174
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 144
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  start_pfn:         4096
  inactive_ratio:    1
Node 0, zone  HighMem
  pages free     150806
        min      128
        low      6989
        high     13850
        scanned  0
        spanned  556754
        present  552404
    nr_free_pages 150806
    nr_inactive_anon 54225
    nr_active_anon 143153
    nr_inactive_file 142731
    nr_active_file 63382
    nr_unevictable 12
    nr_mlock     12
    nr_anon_pages 134200
    nr_mapped    15674
    nr_file_pages 245898
    nr_dirty     862
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 4921
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     39003
    nr_dirtied   4316856
    nr_written   3258730
    nr_anon_transparent_hugepages 23
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 181
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 148
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  start_pfn:         227326
  inactive_ratio:    4


2nd /proc/zoneinfo:

Node 0, zone      DMA
  pages free     3270
        min      196
        low      245
        high     294
        scanned  0
        spanned  4080
        present  3951
    nr_free_pages 3270
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 594
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 706
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 2
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 298
    nr_shmem     0
    nr_dirtied   1414
    nr_written   1414
    nr_anon_transparent_hugepages 0
        protection: (0, 865, 3023, 3023)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 0
  start_pfn:         16
  inactive_ratio:    1
Node 0, zone   Normal
  pages free     18165
        min      11003
        low      13753
        high     16504
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 18165
    nr_inactive_anon 69521
    nr_active_anon 48778
    nr_inactive_file 37220
    nr_active_file 16531
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 14029
    nr_mapped    175
    nr_file_pages 55324
    nr_dirty     16
    nr_writeback 0
    nr_slab_reclaimable 15224
    nr_slab_unreclaimable 2805
    nr_page_table_pages 1134
    nr_kernel_stack 319
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 1023
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     1750
    nr_dirtied   1215307
    nr_written   958303
    nr_anon_transparent_hugepages 100
        protection: (0, 0, 17262, 17262)
  pagesets
    cpu: 0
              count: 156
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 168
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  start_pfn:         4096
  inactive_ratio:    1
Node 0, zone  HighMem
  pages free     146280
        min      128
        low      6989
        high     13850
        scanned  0
        spanned  556754
        present  552404
    nr_free_pages 146280
    nr_inactive_anon 54225
    nr_active_anon 143128
    nr_inactive_file 146871
    nr_active_file 63760
    nr_unevictable 12
    nr_mlock     12
    nr_anon_pages 134163
    nr_mapped    15674
    nr_file_pages 250402
    nr_dirty     1820
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 4921
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     39003
    nr_dirtied   4323393
    nr_written   3262270
    nr_anon_transparent_hugepages 23
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 184
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 164
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  start_pfn:         227326
  inactive_ratio:    4


3rd /proc/zoneinfo:

Node 0, zone      DMA
  pages free     3270
        min      196
        low      245
        high     294
        scanned  0
        spanned  4080
        present  3951
    nr_free_pages 3270
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 594
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 706
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 2
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 298
    nr_shmem     0
    nr_dirtied   1414
    nr_written   1414
    nr_anon_transparent_hugepages 0
        protection: (0, 865, 3023, 3023)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 0
  start_pfn:         16
  inactive_ratio:    1
Node 0, zone   Normal
  pages free     18200
        min      11003
        low      13753
        high     16504
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 18200
    nr_inactive_anon 69521
    nr_active_anon 48778
    nr_inactive_file 37228
    nr_active_file 16534
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 14029
    nr_mapped    175
    nr_file_pages 55334
    nr_dirty     5
    nr_writeback 0
    nr_slab_reclaimable 15224
    nr_slab_unreclaimable 2801
    nr_page_table_pages 1134
    nr_kernel_stack 319
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 1023
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     1750
    nr_dirtied   1215316
    nr_written   958323
    nr_anon_transparent_hugepages 100
        protection: (0, 0, 17262, 17262)
  pagesets
    cpu: 0
              count: 127
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 132
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  start_pfn:         4096
  inactive_ratio:    1
Node 0, zone  HighMem
  pages free     143087
        min      128
        low      6989
        high     13850
        scanned  0
        spanned  556754
        present  552404
    nr_free_pages 143087
    nr_inactive_anon 54225
    nr_active_anon 143127
    nr_inactive_file 150208
    nr_active_file 63776
    nr_unevictable 12
    nr_mlock     12
    nr_anon_pages 134163
    nr_mapped    15674
    nr_file_pages 253755
    nr_dirty     740
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 4921
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     39003
    nr_dirtied   4329000
    nr_written   3266708
    nr_anon_transparent_hugepages 23
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 166
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 22
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  start_pfn:         227326
  inactive_ratio:    4


4th /proc/zoneinfo:

Node 0, zone      DMA
  pages free     3270
        min      196
        low      245
        high     294
        scanned  0
        spanned  4080
        present  3951
    nr_free_pages 3270
    nr_inactive_anon 0
    nr_active_anon 0
    nr_inactive_file 594
    nr_active_file 0
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 706
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 2
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 298
    nr_shmem     0
    nr_dirtied   1414
    nr_written   1414
    nr_anon_transparent_hugepages 0
        protection: (0, 865, 3023, 3023)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 0
  start_pfn:         16
  inactive_ratio:    1
Node 0, zone   Normal
  pages free     128730
        min      11003
        low      13753
        high     16504
        scanned  0
        spanned  223230
        present  221486
    nr_free_pages 128730
    nr_inactive_anon 8337
    nr_active_anon 3
    nr_inactive_file 37354
    nr_active_file 16679
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 140
    nr_mapped    7
    nr_file_pages 53743
    nr_dirty     55
    nr_writeback 0
    nr_slab_reclaimable 15233
    nr_slab_unreclaimable 2654
    nr_page_table_pages 622
    nr_kernel_stack 251
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 1023
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     3
    nr_dirtied   1215764
    nr_written   958721
    nr_anon_transparent_hugepages 8
        protection: (0, 0, 17262, 17262)
  pagesets
    cpu: 0
              count: 163
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 133
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  start_pfn:         4096
  inactive_ratio:    1
Node 0, zone  HighMem
  pages free     263502
        min      128
        low      6989
        high     13850
        scanned  0
        spanned  556754
        present  552404
    nr_free_pages 263502
    nr_inactive_anon 24892
    nr_active_anon 26289
    nr_inactive_file 174037
    nr_active_file 65827
    nr_unevictable 12
    nr_mlock     12
    nr_anon_pages 29472
    nr_mapped    11150
    nr_file_pages 259669
    nr_dirty     9
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_kernel_stack 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 4921
    nr_writeback_temp 0
    nr_isolated_anon 0
    nr_isolated_file 0
    nr_shmem     18959
    nr_dirtied   4364710
    nr_written   3290304
    nr_anon_transparent_hugepages 2
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 149
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 74
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  start_pfn:         227326
  inactive_ratio:    4

