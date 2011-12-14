Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab1LNXiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:38:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:1105 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742Ab1LNXiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:38:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85828708"
Date: Wed, 14 Dec 2011 22:59:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: XFS/btrfs performance after IO-less dirty throttling
Message-ID: <20111214145958.GA25329@localhost>
References: <20111214143156.GA22511@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214143156.GA22511@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 10:31:56PM +0800, Wu Fengguang wrote:
> Hi,
> 
> This very basic 1-disk performance comparison shows +8.3% overall
> improvements for XFS and +6.2% for btrfs.

Hmm... this is beyond my expectation. Actually I see lower overall
numbers in earlier tests:

wfg@bee /export/writeback% ./compare -g xfs fat/*/*-{3.1.0+,3.2.0-rc1-ioless-full+}
                  3.1.0+    3.2.0-rc1-ioless-full+
------------------------  ------------------------
                   43.24        -0.6%        42.96  fat/UKEY-HDD/xfs-100dd-1-3.1.0+
                   42.94        +2.9%        44.19  fat/UKEY-HDD/xfs-100dd-2-3.1.0+
                   43.13        +2.6%        44.23  fat/UKEY-HDD/xfs-100dd-3-3.1.0+
                   51.35        +6.1%        54.50  fat/UKEY-HDD/xfs-10dd-1-3.1.0+
                   51.31        +3.4%        53.03  fat/UKEY-HDD/xfs-10dd-2-3.1.0+
                   52.72        +2.7%        54.12  fat/UKEY-HDD/xfs-10dd-3-3.1.0+
                   58.73        +8.1%        63.50  fat/UKEY-HDD/xfs-1dd-1-3.1.0+
                   57.74        +4.6%        60.42  fat/UKEY-HDD/xfs-1dd-2-3.1.0+
                   61.12        +2.0%        62.33  fat/UKEY-HDD/xfs-1dd-3-3.1.0+
                    2.00       +16.8%         2.34  fat/mmap_randwrite_4k/xfs-fio_fat_mmap_randwrite_4k-1-3.1.0+
                    2.07       +12.3%         2.33  fat/mmap_randwrite_4k/xfs-fio_fat_mmap_randwrite_4k-2-3.1.0+
                   44.12       +18.8%        52.41  fat/mmap_randwrite_64k/xfs-fio_fat_mmap_randwrite_64k-1-3.1.0+
                   44.70        +5.5%        47.14  fat/mmap_randwrite_64k/xfs-fio_fat_mmap_randwrite_64k-2-3.1.0+
                   48.17        +5.8%        50.97  fat/rates/xfs-fio_fat_rates-1-3.1.0+
                   48.79        +5.0%        51.23  fat/rates/xfs-fio_fat_rates-2-3.1.0+
                   38.23       +13.5%        43.40  fat/thresh=1000M/xfs-100dd-1-3.1.0+
                   38.91       +14.1%        44.41  fat/thresh=1000M/xfs-100dd-2-3.1.0+
                   39.56       +16.0%        45.88  fat/thresh=1000M/xfs-100dd-3-3.1.0+
                   45.17       +14.4%        51.70  fat/thresh=1000M/xfs-10dd-1-3.1.0+
                   45.73       +11.4%        50.93  fat/thresh=1000M/xfs-10dd-2-3.1.0+
                   46.04       +15.7%        53.26  fat/thresh=1000M/xfs-10dd-3-3.1.0+
                   51.66       +10.8%        57.22  fat/thresh=1000M/xfs-1dd-1-3.1.0+
                   51.42        +5.6%        54.31  fat/thresh=1000M/xfs-1dd-2-3.1.0+
                   52.51        +5.6%        55.45  fat/thresh=1000M/xfs-1dd-3-3.1.0+
                   38.31       +22.0%        46.75  fat/thresh=1000M:990M/xfs-100dd-1-3.1.0+
                   43.60       +24.3%        54.20  fat/thresh=1000M:990M/xfs-10dd-1-3.1.0+
                   50.14       +10.0%        55.17  fat/thresh=1000M:990M/xfs-1dd-1-3.1.0+
                   38.06       +24.1%        47.24  fat/thresh=1000M:999M/xfs-100dd-1-3.1.0+
                   42.43       +28.4%        54.46  fat/thresh=1000M:999M/xfs-10dd-1-3.1.0+
                   50.30       +10.7%        55.70  fat/thresh=1000M:999M/xfs-1dd-1-3.1.0+
                   28.89        -5.7%        27.24  fat/thresh=100M/xfs-100dd-1-3.1.0+
                   29.19        -4.9%        27.75  fat/thresh=100M/xfs-100dd-3-3.1.0+
                   43.47        +6.4%        46.28  fat/thresh=100M/xfs-10dd-3-3.1.0+
                   55.33        -0.1%        55.28  fat/thresh=100M/xfs-1dd-3-3.1.0+
                   37.05       -17.0%        30.76  fat/thresh=10M/xfs-10dd-1-3.1.0+
                   37.23       -17.5%        30.71  fat/thresh=10M/xfs-10dd-2-3.1.0+
                   38.83       -19.3%        31.33  fat/thresh=10M/xfs-10dd-3-3.1.0+
                   55.42        +1.1%        56.06  fat/thresh=10M/xfs-1dd-1-3.1.0+
                   55.08        -4.9%        52.39  fat/thresh=10M/xfs-1dd-2-3.1.0+
                   54.78        +0.5%        55.07  fat/thresh=10M/xfs-1dd-3-3.1.0+
                   41.64       -32.7%        28.04  fat/thresh=1M/xfs-10dd-1-3.1.0+
                   40.82       -31.0%        28.18  fat/thresh=1M/xfs-10dd-2-3.1.0+
                   40.87       -30.1%        28.59  fat/thresh=1M/xfs-10dd-3-3.1.0+
                   56.68        -6.4%        53.04  fat/thresh=1M/xfs-1dd-1-3.1.0+
                   57.48       -11.8%        50.67  fat/thresh=1M/xfs-1dd-2-3.1.0+
                   56.32        -7.4%        52.15  fat/thresh=1M/xfs-1dd-3-3.1.0+
                 2053.29        +2.7%      2109.30  TOTAL write_bw

wfg@bee /export/writeback% ./compare -g btrfs fat/*/*-{3.1.0+,3.2.0-rc1-ioless-full+}
                  3.1.0+    3.2.0-rc1-ioless-full+
------------------------  ------------------------
                   53.49       +12.6%        60.21  fat/UKEY-HDD/btrfs-100dd-1-3.1.0+
                   55.42        +9.6%        60.75  fat/UKEY-HDD/btrfs-100dd-2-3.1.0+
                   56.54       +10.4%        62.40  fat/UKEY-HDD/btrfs-100dd-3-3.1.0+
                   56.50        +6.2%        60.00  fat/UKEY-HDD/btrfs-10dd-1-3.1.0+
                   56.63        +7.3%        60.76  fat/UKEY-HDD/btrfs-10dd-2-3.1.0+
                   55.64       +11.8%        62.19  fat/UKEY-HDD/btrfs-10dd-3-3.1.0+
                   60.07        +1.5%        60.97  fat/UKEY-HDD/btrfs-1dd-1-3.1.0+
                   60.18        -0.7%        59.73  fat/UKEY-HDD/btrfs-1dd-2-3.1.0+
                   59.36        +5.4%        62.56  fat/UKEY-HDD/btrfs-1dd-3-3.1.0+
                    1.54       +11.3%         1.72  fat/mmap_randwrite_4k/btrfs-fio_fat_mmap_randwrite_4k-1-3.1.0+
                    1.67        +3.0%         1.72  fat/mmap_randwrite_4k/btrfs-fio_fat_mmap_randwrite_4k-2-3.1.0+
                   50.65        +1.8%        51.58  fat/mmap_randwrite_64k/btrfs-fio_fat_mmap_randwrite_64k-1-3.1.0+
                   50.44        +2.3%        51.61  fat/mmap_randwrite_64k/btrfs-fio_fat_mmap_randwrite_64k-2-3.1.0+
                   55.25        +1.3%        55.97  fat/rates/btrfs-fio_fat_rates-1-3.1.0+
                   55.34        +0.7%        55.73  fat/rates/btrfs-fio_fat_rates-2-3.1.0+
                   52.42        +3.5%        54.26  fat/thresh=1000M/btrfs-100dd-1-3.1.0+
                   53.60        +2.3%        54.84  fat/thresh=1000M/btrfs-100dd-2-3.1.0+
                   54.62        +3.9%        56.72  fat/thresh=1000M/btrfs-100dd-3-3.1.0+
                   53.75        +0.5%        54.04  fat/thresh=1000M/btrfs-10dd-1-3.1.0+
                   53.75        +1.8%        54.73  fat/thresh=1000M/btrfs-10dd-2-3.1.0+
                   53.31        +5.6%        56.31  fat/thresh=1000M/btrfs-10dd-3-3.1.0+
                   53.23        +4.7%        55.74  fat/thresh=1000M/btrfs-1dd-1-3.1.0+
                   54.53        -1.3%        53.81  fat/thresh=1000M/btrfs-1dd-2-3.1.0+
                   55.37        +0.4%        55.60  fat/thresh=1000M/btrfs-1dd-3-3.1.0+
                   55.11        +2.9%        56.72  fat/thresh=1000M:990M/btrfs-100dd-1-3.1.0+
                   53.01        +3.1%        54.64  fat/thresh=1000M:990M/btrfs-10dd-1-3.1.0+
                   55.71        +2.1%        56.90  fat/thresh=1000M:990M/btrfs-1dd-1-3.1.0+
                   54.07        +3.3%        55.84  fat/thresh=1000M:999M/btrfs-100dd-1-3.1.0+
                   53.05        +2.6%        54.41  fat/thresh=1000M:999M/btrfs-10dd-1-3.1.0+
                   54.79        +3.1%        56.49  fat/thresh=1000M:999M/btrfs-1dd-1-3.1.0+
                   56.42        -2.9%        54.80  fat/thresh=100M/btrfs-100dd-1-3.1.0+
                   56.43        +1.4%        57.20  fat/thresh=100M/btrfs-100dd-3-3.1.0+
                   57.41        -5.4%        54.33  fat/thresh=100M/btrfs-10dd-1-3.1.0+
                   55.27        +2.4%        56.62  fat/thresh=100M/btrfs-10dd-3-3.1.0+
                   56.88        -1.3%        56.15  fat/thresh=100M/btrfs-1dd-3-3.1.0+
                   44.41       +20.5%        53.50  fat/thresh=10M/btrfs-10dd-1-3.1.0+
                   46.88       +14.7%        53.78  fat/thresh=10M/btrfs-10dd-2-3.1.0+
                   50.11       +11.5%        55.87  fat/thresh=10M/btrfs-10dd-3-3.1.0+
                   54.33        +2.3%        55.59  fat/thresh=10M/btrfs-1dd-1-3.1.0+
                   55.46        -1.3%        54.73  fat/thresh=10M/btrfs-1dd-2-3.1.0+
                   54.15        +3.3%        55.91  fat/thresh=10M/btrfs-1dd-3-3.1.0+
                    5.00       -41.4%         2.93  fat/thresh=1M/btrfs-10dd-1-3.1.0+
                    3.70       -30.3%         2.58  fat/thresh=1M/btrfs-10dd-2-3.1.0+
                    5.22       -43.9%         2.92  fat/thresh=1M/btrfs-10dd-3-3.1.0+
                   15.21       -86.3%         2.08  fat/thresh=1M/btrfs-1dd-1-3.1.0+
                   14.52       -84.7%         2.22  fat/thresh=1M/btrfs-1dd-2-3.1.0+
                   14.53       -85.6%         2.09  fat/thresh=1M/btrfs-1dd-3-3.1.0+
                 2184.97        +1.7%      2222.27  TOTAL write_bw

Thanks,
Fengguang

> The thresh=1M cases see big "regressions", however that's due to much
> more strictly executed global dirty limit. So not real problems.
> 
> The other big regressions happen in the XFS UKEY-thresh=100M cases.
> Need to explore what's going on inside XFS...
> 
> wfg@bee /export/writeback% ./compare -g xfs fat/*/*-3.1.0+ fat/*/*-3.2.0-rc3
>                   3.1.0+                 3.2.0-rc3
> ------------------------  ------------------------
>                    43.24       +11.6%        48.26  fat/UKEY-HDD/xfs-100dd-1-3.1.0+
>                    51.35        +8.3%        55.62  fat/UKEY-HDD/xfs-10dd-1-3.1.0+
>                    58.73        +5.7%        62.09  fat/UKEY-HDD/xfs-1dd-1-3.1.0+
>                     4.17       -37.8%         2.59  fat/UKEY-thresh=100M/xfs-100dd-1-3.1.0+
>                     4.14       -53.3%         1.94  fat/UKEY-thresh=100M/xfs-10dd-1-3.1.0+
>                     6.30        +0.4%         6.33  fat/UKEY-thresh=100M/xfs-1dd-1-3.1.0+
>                     8.88       +18.0%        10.48  fat/fio/xfs-fio_fat_mmap_randwrite_4k-1-3.1.0+
>                    36.01       +25.2%        45.07  fat/fio/xfs-fio_fat_mmap_randwrite_64k-1-3.1.0+
>                    47.04        +9.2%        51.38  fat/fio/xfs-fio_fat_rates-1-3.1.0+
>                    38.23       +22.7%        46.92  fat/thresh=1000M/xfs-100dd-1-3.1.0+
>                    45.17       +22.6%        55.39  fat/thresh=1000M/xfs-10dd-1-3.1.0+
>                    51.66        +9.2%        56.44  fat/thresh=1000M/xfs-1dd-1-3.1.0+
>                    38.31       +23.2%        47.18  fat/thresh=1000M:990M/xfs-100dd-1-3.1.0+
>                    43.60       +26.1%        54.99  fat/thresh=1000M:990M/xfs-10dd-1-3.1.0+
>                    50.14       +14.4%        57.39  fat/thresh=1000M:990M/xfs-1dd-1-3.1.0+
>                    38.06       +26.8%        48.26  fat/thresh=1000M:999M/xfs-100dd-1-3.1.0+
>                    42.43       +28.1%        54.34  fat/thresh=1000M:999M/xfs-10dd-1-3.1.0+
>                    50.30       +10.4%        55.53  fat/thresh=1000M:999M/xfs-1dd-1-3.1.0+
>                    28.89        -3.9%        27.76  fat/thresh=100M/xfs-100dd-1-3.1.0+
>                    44.94        +3.6%        46.54  fat/thresh=100M/xfs-10dd-1-3.1.0+
>                    55.60        -3.0%        53.95  fat/thresh=100M/xfs-1dd-1-3.1.0+
>                    37.05       -15.2%        31.43  fat/thresh=10M/xfs-10dd-1-3.1.0+
>                    55.42        +1.1%        56.03  fat/thresh=10M/xfs-1dd-1-3.1.0+
>                    41.64       -30.3%        29.00  fat/thresh=1M/xfs-10dd-1-3.1.0+
>                    56.68        -4.5%        54.14  fat/thresh=1M/xfs-1dd-1-3.1.0+
>                   977.98        +8.3%      1059.05  TOTAL write_bw
> wfg@bee /export/writeback% ./compare -g btrfs fat/*/*-3.1.0+ fat/*/*-3.2.0-rc3
>                   3.1.0+                 3.2.0-rc3
> ------------------------  ------------------------
>                    53.49       +19.6%        63.98  fat/UKEY-HDD/btrfs-100dd-1-3.1.0+
>                    56.50       +11.8%        63.19  fat/UKEY-HDD/btrfs-10dd-1-3.1.0+
>                    60.07        +6.3%        63.83  fat/UKEY-HDD/btrfs-1dd-1-3.1.0+
>                     4.81       +26.8%         6.10  fat/UKEY-thresh=100M/btrfs-100dd-1-3.1.0+
>                     5.00       +23.2%         6.16  fat/UKEY-thresh=100M/btrfs-10dd-1-3.1.0+
>                     5.99        +1.8%         6.10  fat/UKEY-thresh=100M/btrfs-1dd-1-3.1.0+
>                    15.98       -10.6%        14.29  fat/fio/btrfs-fio_fat_mmap_randwrite_4k-1-3.1.0+
>                    52.02        +5.4%        54.85  fat/fio/btrfs-fio_fat_mmap_randwrite_64k-1-3.1.0+
>                    56.01        +2.6%        57.48  fat/fio/btrfs-fio_fat_rates-1-3.1.0+
>                    52.42       +10.4%        57.85  fat/thresh=1000M/btrfs-100dd-1-3.1.0+
>                    53.75        +7.7%        57.86  fat/thresh=1000M/btrfs-10dd-1-3.1.0+
>                    53.23       +11.2%        59.18  fat/thresh=1000M/btrfs-1dd-1-3.1.0+
>                    55.11        +5.3%        58.02  fat/thresh=1000M:990M/btrfs-100dd-1-3.1.0+
>                    53.01        +5.3%        55.83  fat/thresh=1000M:990M/btrfs-10dd-1-3.1.0+
>                    55.71        +5.9%        58.97  fat/thresh=1000M:990M/btrfs-1dd-1-3.1.0+
>                    54.07        +6.5%        57.61  fat/thresh=1000M:999M/btrfs-100dd-1-3.1.0+
>                    53.05        +4.1%        55.21  fat/thresh=1000M:999M/btrfs-10dd-1-3.1.0+
>                    54.79        +5.6%        57.85  fat/thresh=1000M:999M/btrfs-1dd-1-3.1.0+
>                    56.42        +2.9%        58.06  fat/thresh=100M/btrfs-100dd-1-3.1.0+
>                    57.41        +1.5%        58.26  fat/thresh=100M/btrfs-10dd-1-3.1.0+
>                    58.12        +4.1%        60.50  fat/thresh=100M/btrfs-1dd-1-3.1.0+
>                    44.41       +29.2%        57.37  fat/thresh=10M/btrfs-10dd-1-3.1.0+
>                    54.33        +9.3%        59.37  fat/thresh=10M/btrfs-1dd-1-3.1.0+
>                     5.00       -47.3%         2.64  fat/thresh=1M/btrfs-10dd-1-3.1.0+
>                    15.21       -83.6%         2.50  fat/thresh=1M/btrfs-1dd-1-3.1.0+
>                  1085.90        +6.2%      1153.08  TOTAL write_bw
> 
> It performs roughly the same with the pending writeback changes:
> 
> wfg@bee /export/writeback% ./compare -g xfs fat/*/*-3.1.0+ fat/*/*-3.2.0-rc3-pause6+
>                   3.1.0+         3.2.0-rc3-pause6+
> ------------------------  ------------------------
>                    43.24        +9.2%        47.21  fat/UKEY-HDD/xfs-100dd-1-3.1.0+
>                    51.35        +8.9%        55.90  fat/UKEY-HDD/xfs-10dd-1-3.1.0+
>                    58.73        +5.8%        62.15  fat/UKEY-HDD/xfs-1dd-1-3.1.0+
>                     4.17       -33.1%         2.79  fat/UKEY-thresh=100M/xfs-100dd-1-3.1.0+
>                     4.14       -23.9%         3.15  fat/UKEY-thresh=100M/xfs-10dd-1-3.1.0+
>                     6.30        +0.2%         6.32  fat/UKEY-thresh=100M/xfs-1dd-1-3.1.0+
>                     8.88       +10.2%         9.78  fat/fio/xfs-fio_fat_mmap_randwrite_4k-1-3.1.0+
>                    36.01       +24.4%        44.80  fat/fio/xfs-fio_fat_mmap_randwrite_64k-1-3.1.0+
>                    47.04       +11.9%        52.64  fat/fio/xfs-fio_fat_rates-1-3.1.0+
>                    38.23       +27.9%        48.89  fat/thresh=1000M/xfs-100dd-1-3.1.0+
>                    45.17       +21.0%        54.67  fat/thresh=1000M/xfs-10dd-1-3.1.0+
>                    51.66       +11.2%        57.46  fat/thresh=1000M/xfs-1dd-1-3.1.0+
>                    38.31       +15.1%        44.08  fat/thresh=1000M:990M/xfs-100dd-1-3.1.0+
>                    43.60       +24.8%        54.41  fat/thresh=1000M:990M/xfs-10dd-1-3.1.0+
>                    50.14       +13.4%        56.87  fat/thresh=1000M:990M/xfs-1dd-1-3.1.0+
>                    38.06       +28.9%        49.05  fat/thresh=1000M:999M/xfs-100dd-1-3.1.0+
>                    42.43       +28.3%        54.41  fat/thresh=1000M:999M/xfs-10dd-1-3.1.0+
>                    50.30        +8.1%        54.36  fat/thresh=1000M:999M/xfs-1dd-1-3.1.0+
>                    28.89        -1.2%        28.55  fat/thresh=100M/xfs-100dd-1-3.1.0+
>                    44.94        +5.3%        47.33  fat/thresh=100M/xfs-10dd-1-3.1.0+
>                    55.60        +3.4%        57.48  fat/thresh=100M/xfs-1dd-1-3.1.0+
>                    37.05       -14.5%        31.68  fat/thresh=10M/xfs-10dd-1-3.1.0+
>                    55.42        +0.6%        55.77  fat/thresh=10M/xfs-1dd-1-3.1.0+
>                    41.64       -30.8%        28.82  fat/thresh=1M/xfs-10dd-1-3.1.0+
>                    56.68        -3.0%        54.98  fat/thresh=1M/xfs-1dd-1-3.1.0+
>                   977.98        +8.7%      1063.55  TOTAL write_bw
> 
> wfg@bee /export/writeback% ./compare -g btrfs fat/*/*-{3.1.0+,3.2.0-rc3-pause6+}
>                   3.1.0+         3.2.0-rc3-pause6+
> ------------------------  ------------------------
>                    53.49       +19.2%        63.75  fat/UKEY-HDD/btrfs-100dd-1-3.1.0+
>                    56.50       +14.1%        64.49  fat/UKEY-HDD/btrfs-10dd-1-3.1.0+
>                    60.07        +6.7%        64.11  fat/UKEY-HDD/btrfs-1dd-1-3.1.0+
>                     4.81       +27.4%         6.12  fat/UKEY-thresh=100M/btrfs-100dd-1-3.1.0+
>                     5.00       +21.7%         6.09  fat/UKEY-thresh=100M/btrfs-10dd-1-3.1.0+
>                     5.99        +1.9%         6.11  fat/UKEY-thresh=100M/btrfs-1dd-1-3.1.0+
>                    15.98        -8.5%        14.62  fat/fio/btrfs-fio_fat_mmap_randwrite_4k-1-3.1.0+
>                    52.02        +4.2%        54.20  fat/fio/btrfs-fio_fat_mmap_randwrite_64k-1-3.1.0+
>                    56.01        +1.0%        56.57  fat/fio/btrfs-fio_fat_rates-1-3.1.0+
>                    52.42       +11.4%        58.38  fat/thresh=1000M/btrfs-100dd-1-3.1.0+
>                    53.75        +9.2%        58.67  fat/thresh=1000M/btrfs-10dd-1-3.1.0+
>                    53.23        +9.6%        58.34  fat/thresh=1000M/btrfs-1dd-1-3.1.0+
>                    55.11        +5.8%        58.33  fat/thresh=1000M:990M/btrfs-100dd-1-3.1.0+
>                    53.01        +6.8%        56.62  fat/thresh=1000M:990M/btrfs-10dd-1-3.1.0+
>                    55.71        +3.8%        57.84  fat/thresh=1000M:990M/btrfs-1dd-1-3.1.0+
>                    54.07        +6.9%        57.78  fat/thresh=1000M:999M/btrfs-100dd-1-3.1.0+
>                    53.05        +5.3%        55.87  fat/thresh=1000M:999M/btrfs-10dd-1-3.1.0+
>                    54.79        +4.2%        57.09  fat/thresh=1000M:999M/btrfs-1dd-1-3.1.0+
>                    56.42        +2.7%        57.97  fat/thresh=100M/btrfs-100dd-1-3.1.0+
>                    57.41        +1.9%        58.51  fat/thresh=100M/btrfs-10dd-1-3.1.0+
>                    58.12        +1.0%        58.71  fat/thresh=100M/btrfs-1dd-1-3.1.0+
>                    44.41       +31.0%        58.16  fat/thresh=10M/btrfs-10dd-1-3.1.0+
>                    54.33        +7.9%        58.60  fat/thresh=10M/btrfs-1dd-1-3.1.0+
>                     5.00       -55.3%         2.24  fat/thresh=1M/btrfs-10dd-1-3.1.0+
>                    15.21       -81.0%         2.89  fat/thresh=1M/btrfs-1dd-1-3.1.0+
>                  1085.90        +6.1%      1152.06  TOTAL write_bw
> 
> Thanks,
> Fengguang
