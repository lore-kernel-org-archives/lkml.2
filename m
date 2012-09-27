Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2I0G77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:59:59 -0400
Received: from tee.schottelius.org ([77.109.138.222]:35245 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511Ab2I0G7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:59:50 -0400
Date: Thu, 27 Sep 2012 07:52:08 +0200
From: Nico Schottelius <nico-kernel20120920@schottelius.org>
To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
        David Rientjes <rientjes@google.com>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: Re: Out of memory on 3.5 kernels
Message-ID: <20120927055208.GA25252@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	David Rientjes <rientjes@google.com>,
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
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20120926085708.GA7839@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.6.0-rc7-00039-g6f0f9b6 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Good morning,

Attached are the results of kmemleak at various stages (before, during,
after the backup). I am now running 3.6.0-rc7-00039-g6f0f9b6, which has
the same beheviour as 3.5.

According to slabtop it seems that jfs_ip is again the one consuming > 2
GiB memory in the end stage.

Let me know if you need more data, for me it's reboot time now!

Cheers,

Nico


-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=atop4

ATOP - brief                      2012/09/26  19:31:50                      ---------                      10s elapsed
PRC |  sys    4.73s |  user   0.25s |  #proc    263 |  #tslpi   338  | #tslpu     3  | #zombie    0  | #exit      0  |
CPU |  sys      37% |  user      3% |  irq       5% |  idle    203%  | wait    152%  | curf 1.30GHz  | curscal  72%  |
cpu |  sys      10% |  user      1% |  irq       5% |  idle     83%  | cpu000 w  1%  | curf  800MHz  | curscal  44%  |
cpu |  sys      13% |  user      1% |  irq       0% |  idle     36%  | cpu001 w 50%  | curf 1.80GHz  | curscal 100%  |
cpu |  sys      13% |  user      0% |  irq       0% |  idle     24%  | cpu003 w 63%  | curf 1.80GHz  | curscal 100%  |
cpu |  sys       2% |  user      1% |  irq       0% |  idle     61%  | cpu002 w 36%  | curf  800MHz  | curscal  44%  |
CPL |  avg1    2.22 |  avg5    1.02 |  avg15   0.55 |  csw    69613  | intr   22896  |               | numcpu     4  |
MEM |  tot     3.8G |  free    1.9G |  cache 945.1M |  dirty   0.2M  | buff    0.8M  | slab  211.9M  |               |
SWP |  tot     0.0M |  free    0.0M |               |                |               | vmcom   1.7G  | vmlim   1.9G  |
LVM |         usbhd |  busy    101% |  read     871 |  write   2948  | MBr/s   0.34  | MBw/s   1.15  | avio 2.57 ms  |
DSK |           sdc |  busy    101% |  read     871 |  write   2868  | MBr/s   0.34  | MBw/s   1.15  | avio 2.61 ms  |
NET |  transport    |  tcpi       0 |  tcpo       1 |  udpi       3  | udpo      19  | tcpao      0  | tcppo      0  |
NET |  network      |  ipi       41 |  ipo       41 |  ipfrw      0  | deliv     41  | icmpi     16  | icmpo     22  |
NET |  lo      ---- |  pcki      32 |  pcko      32 |  si    1 Kbps  | so    1 Kbps  | erri       0  | erro       0  |
NET |  wlan0   ---- |  pcki       9 |  pcko       9 |  si    0 Kbps  | so    1 Kbps  | erri       0  | erro       0  |

  PID   TID RUID     EUID       THR  SYSCPU  USRCPU   VGROW  RGROW  RDDSK   WRDSK ST EXC  S CPUNR  CPU  CMD        1/3
10221     - root     root         1   1.54s   0.01s  -5016K -4992K  3384K     60K --   -  D     1  16%  rm
10090     - root     root         1   0.85s   0.00s      0K     0K     0K      0K --   -  D     0   9%  usb-storage
  168     - root     root         1   0.36s   0.00s      0K     0K     0K      0K --   -  S     1   4%  jfsIO
    3     - root     root         1   0.33s   0.00s      0K     0K     0K      0K --   -  S     0   3%  ksoftirqd/0
  113     - root     root         1   0.26s   0.00s      0K     0K     0K      0K --   -  S     0   3%  kworker/0:1H
 6452     - nico     nico        25   0.10s   0.13s     64K   216K     0K      0K --   -  S     2   2%  firefox
  172     - root     root         1   0.23s   0.00s      0K     0K    16K   4204K --   -  S     3   2%  jfsCommit
  453     - nico     root         1   0.10s   0.05s      0K     0K     0K      0K --   -  S     0   2%  X
10071     - root     root         1   0.14s   0.00s      0K     0K     0K      0K --   -  S     3   1%  kworker/3:3
 9424     - root     root         1   0.12s   0.00s      0K     0K     0K      0K --   -  S     1   1%  kworker/1:1
 9385     - root     root         1   0.11s   0.00s      0K     0K     0K      0K --   -  S     3   1%  kworker/3:1
 9962     - root     root         1   0.10s   0.00s      0K     0K     0K      0K --   -  S     1   1%  kworker/1:2
10239     - nico     nico         1   0.07s   0.01s      0K     0K     0K      0K --   -  R     3   1%  atop
 9298     - root     root         1   0.07s   0.00s      0K     0K     0K      0K --   -  S     2   1%  kworker/2:1


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=atop5

PRC |  sys   30.30s |  user   2.83s |  #proc    203 |  #tslpi   292  | #tslpu     1  | #zombie    0  | #exit      2  |
CPU |  sys     100% |  user     29% |  irq      12% |  idle    167%  | wait     91%  | curf 1.30GHz  | curscal  72%  |
cpu |  sys      31% |  user      6% |  irq      11% |  idle     37%  | cpu000 w 15%  | curf 1.80GHz  | curscal 100%  |
cpu |  sys      25% |  user     10% |  irq       1% |  idle     33%  | cpu001 w 32%  | curf  800MHz  | curscal  44%  |
cpu |  sys      24% |  user      6% |  irq       1% |  idle     42%  | cpu003 w 27%  | curf 1.80GHz  | curscal 100%  |
cpu |  sys      21% |  user      6% |  irq       1% |  idle     55%  | cpu002 w 17%  | curf  800MHz  | curscal  44%  |
CPL |  avg1    3.73 |  avg5    4.28 |  avg15   4.23 |  csw   161014  | intr   41478  |               | numcpu     4  |
MEM |  tot     3.8G |  free  280.7M |  cache   1.1G |  dirty  45.4M  | buff    0.1M  | slab    1.2G  |               |
SWP |  tot     0.0M |  free    0.0M |               |                |               | vmcom   2.7G  | vmlim   1.9G  |
PAG |  scan   21820 |  steal  21820 |  stall      0 |                |               | swin       0  | swout      0  |
LVM |         usbhd |  busy     84% |  read      22 |  write   9239  | MBr/s   0.01  | MBw/s   6.77  | avio 0.88 ms  |
LVM |          root |  busy     30% |  read    5473 |  write     10  | MBr/s   6.77  | MBw/s   0.01  | avio 0.53 ms  |
DSK |           sdc |  busy     82% |  read      22 |  write   5375  | MBr/s   0.01  | MBw/s   7.15  | avio 1.47 ms  |
DSK |           sda |  busy     17% |  read    5471 |  write      9  | MBr/s   6.77  | MBw/s   0.01  | avio 0.31 ms  |
NET |  transport    |  tcpi     898 |  tcpo     437 |  udpi      13  | udpo      29  | tcpao      0  | tcppo      0  |
NET |  network      |  ipi      956 |  ipo      494 |  ipfrw      0  | deliv    956  | icmpi     16  | icmpo     26  |
NET |  wlan0   ---- |  pcki     925 |  pcko     463 |  si 1064 Kbps  | so   36 Kbps  | erri       0  | erro       0  |
NET |  lo      ---- |  pcki      32 |  pcko      32 |  si    1 Kbps  | so    1 Kbps  | erri       0  | erro       0  |
                                                                              
  PID   TID RUID     EUID       THR  SYSCPU  USRCPU   VGROW  RGROW  RDDSK   WRDSK ST EXC  S CPUNR  CPU  CMD        1/6
20520     - root     -            0  18.87s   0.00s      0K     0K      -       - NE   0  E     - 100%  <kworker/2:3>
14305     - root     root         1   3.31s   0.24s      0K     0K    48K  68208K --   -  R     1  37%  rsync        
14303     - root     root         1   2.57s   0.23s      0K     0K 68068K      0K --   -  S     3  29%  rsync
20354     - nico     nico         1   0.06s   1.84s      0K     0K     0K      0K --   -  S     3  20%  mplayer
10090     - root     root         1   0.69s   0.00s      0K     0K     0K      0K --   -  R     3   7%  usb-storage
    3     - root     root         1   0.52s   0.00s      0K     0K     0K      0K --   -  R     0   5%  ksoftirqd/0
14304     - root     root         1   0.44s   0.03s      0K     0K    40K    552K --   -  S     3   5%  rsync
  453     - nico     root         1   0.22s   0.19s      0K     8K     0K      0K --   -  S     3   4%  X
10224     - root     root         1   0.38s   0.00s      0K     0K     0K     16K --   -  S     2   4%  flush-254:1
 5281     - root     root         1   0.37s   0.00s      0K     0K     0K      0K --   -  S     0   4%  kworker/0:3
 1996     - root     root         1   0.33s   0.00s      0K     0K     0K      0K --   -  S     0   3%  kworker/0:1


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="atop6-slab1.5g"

ATOP - brief                      2012/09/26  21:27:39                      ---------                      10s elapsed
PRC |  sys   12.57s |  user   1.04s |  #proc    207 |  #tslpi   297  | #tslpu     5  | #zombie    0  | #exit      2  |
CPU |  sys     111% |  user     11% |  irq      19% |  idle    141%  | wait    118%  | curf 1.00GHz  | curscal  55%  |
cpu |  sys      32% |  user      3% |  irq      18% |  idle     32%  | cpu000 w 15%  | curf  800MHz  | curscal  44%  |
cpu |  sys      28% |  user      3% |  irq       1% |  idle     25%  | cpu001 w 42%  | curf  800MHz  | curscal  44%  |
cpu |  sys      26% |  user      3% |  irq       0% |  idle     47%  | cpu003 w 25%  | curf 1.20GHz  | curscal  66%  |
cpu |  sys      25% |  user      2% |  irq       1% |  idle     38%  | cpu002 w 35%  | curf 1.20GHz  | curscal  66%  |
CPL |  avg1    4.88 |  avg5    4.28 |  avg15   4.24 |  csw   113521  | intr   40602  |               | numcpu     4  |
MEM |  tot     3.8G |  free  540.7M |  cache 347.9M |  dirty   0.0M  | buff    0.1M  | slab    1.5G  |               |
SWP |  tot     0.0M |  free    0.0M |               |                |               | vmcom   3.2G  | vmlim   1.9G  |
PAG |  scan   89045 |  steal  69636 |  stall   1629 |                |               | swin       0  | swout      0  |
LVM |         usbhd |  busy     75% |  read     246 |  write   6239  | MBr/s   0.10  | MBw/s   6.79  | avio 1.13 ms  |
LVM |          root |  busy     55% |  read    8100 |  write    527  | MBr/s  15.94  | MBw/s   0.21  | avio 0.62 ms  |
DSK |           sdc |  busy     73% |  read     246 |  write   2893  | MBr/s   0.10  | MBw/s   6.16  | avio 2.27 ms  |
DSK |           sda |  busy     49% |  read    7137 |  write    285  | MBr/s  15.94  | MBw/s   0.21  | avio 0.64 ms  |
NET |  transport    |  tcpi    2363 |  tcpo    1238 |  udpi      31  | udpo      24  | tcpao      0  | tcppo      0  |
NET |  network      |  ipi     2439 |  ipo     1288 |  ipfrw      0  | deliv   2439  | icmpi     16  | icmpo     26  |
NET |  wlan0   ---- |  pcki    2407 |  pcko    1256 |  si 2738 Kbps  | so   93 Kbps  | erri       0  | erro       0  |
NET |  lo      ---- |  pcki      32 |  pcko      32 |  si    1 Kbps  | so    1 Kbps  | erri       0  | erro       0  |
                                                                              
  PID   TID RUID     EUID       THR  SYSCPU  USRCPU   VGROW  RGROW  RDDSK   WRDSK ST EXC  S CPUNR  CPU  CMD        1/8
14303     - root     root         1   2.18s   0.17s      0K   668K 42560K      0K --   -  S     3  24%  rsync
14305     - root     root         1   2.05s   0.18s      0K   160K   500K  40544K --   -  D     2  23%  rsync        
   36     - root     root         1   1.71s   0.00s      0K     0K     0K      0K --   -  S     2  17%  kswapd0
 5281     - root     root         1   1.07s   0.00s      0K     0K     0K      0K --   -  S     0  11%  kworker/0:3
 1896     - root     root         1   0.52s   0.00s      0K     0K     0K      0K --   -  S     0   5%  kworker/0:0
10090     - root     root         1   0.47s   0.00s      0K     0K     0K      0K --   -  D     0   5%  usb-storage
10224     - root     root         1   0.46s   0.00s      0K     0K   184K  22788K --   -  D     3   5%  flush-254:1
 6452     - nico     nico        24   0.32s   0.09s      0K  -964K 48192K      0K --   -  S     2   4%  firefox
 5442     - nico     nico         1   0.09s   0.29s      0K    -8K  8400K      0K --   -  S     0   4%  mplayer
  453     - nico     root         1   0.33s   0.05s      0K   -80K 12180K      0K --   -  S     0   4%  X
    3     - root     root         1   0.38s   0.00s      0K     0K     0K      0K --   -  S     0   4%  ksoftirqd/0

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=atop7

ATOP - brief                      2012/09/26  22:28:19                      ---------                      10s elapsed
PRC |  sys   10.77s |  user   2.24s |  #proc    199 |  #tslpi   277  | #tslpu     1  | #zombie    0  | #exit   1921  |
CPU |  sys     153% |  user     55% |  irq       4% |  idle     91%  | wait     97%  | curf 1.68GHz  | curscal  93%  |
cpu |  sys      43% |  user     11% |  irq       3% |  idle     26%  | cpu000 w 17%  | curf 1.80GHz  | curscal 100%  |
cpu |  sys      38% |  user     16% |  irq       0% |  idle     23%  | cpu003 w 23%  | curf 1.80GHz  | curscal 100%  |
cpu |  sys      37% |  user     14% |  irq       1% |  idle     23%  | cpu002 w 26%  | curf 1.30GHz  | curscal  72%  |
cpu |  sys      36% |  user     14% |  irq       0% |  idle     19%  | cpu001 w 31%  | curf 1.80GHz  | curscal 100%  |
CPL |  avg1    5.77 |  avg5    6.17 |  avg15   6.04 |  csw   108577  | intr   26690  |               | numcpu     4  |
MEM |  tot     3.8G |  free  133.4M |  cache 753.6M |  dirty  16.0M  | buff    0.1M  | slab    1.7G  |               |
SWP |  tot     0.0M |  free    0.0M |               |                |               | vmcom   2.9G  | vmlim   1.9G  |
PAG |  scan  119099 |  steal 119073 |  stall    331 |                |               | swin       0  | swout      0  |
LVM |         usbhd |  busy     98% |  read      11 |  write   2121  | MBr/s   0.00  | MBw/s  22.07  | avio 4.49 ms  |
LVM |          root |  busy     28% |  read    2111 |  write     56  | MBr/s  23.56  | MBw/s   0.02  | avio 1.25 ms  |
DSK |           sdc |  busy     98% |  read      11 |  write   2104  | MBr/s   0.00  | MBw/s  21.94  | avio 4.52 ms  |
DSK |           sda |  busy     18% |  read    2076 |  write     48  | MBr/s  23.55  | MBw/s   0.02  | avio 0.84 ms  |
NET |  transport    |  tcpi       1 |  tcpo       2 |  udpi       6  | udpo      22  | tcpao      0  | tcppo      0  |
NET |  network      |  ipi       46 |  ipo       47 |  ipfrw      0  | deliv     46  | icmpi     16  | icmpo     23  |
NET |  wlan0   ---- |  pcki      14 |  pcko      15 |  si    3 Kbps  | so    3 Kbps  | erri       0  | erro       0  |
NET |  lo      ---- |  pcki      32 |  pcko      32 |  si    1 Kbps  | so    1 Kbps  | erri       0  | erro       0  |
                                                                                                                PAUSED
  PID   TID RUID     EUID       THR  SYSCPU  USRCPU   VGROW  RGROW  RDDSK   WRDSK ST EXC  S CPUNR  CPU  CMD      1/179
14303     - root     root         1   2.53s   0.85s      0K     0K 233.4M      0K --   -  R     3  35%  rsync
14305     - root     root         1   2.37s   0.80s      0K    16K    44K  233.3M --   -  R     0  33%  rsync        
  205     - root     root         1   1.21s   0.10s  20696K -2148K     0K      0K --   -  S     3  13%  systemd-journa
30101     - root     root         1   0.77s   0.00s      0K     0K     0K      0K --   -  S     0   8%  kworker/0:4
 3179     - root     root         1   0.48s   0.00s      0K     0K     0K      0K --   -  S     0   5%  kworker/0:3
  311     - root     root         1   0.27s   0.03s      0K     0K  1408K      0K --   -  S     3   3%  acpid
   36     - root     root         1   0.30s   0.00s      0K     0K     0K      0K --   -  D     0   3%  kswapd0
17639     - root     root         1   0.30s   0.00s      0K     0K     0K      0K --   -  S     2   3%  kworker/2:1
10224     - root     root         1   0.25s   0.00s      0K     0K     0K    132K --   -  S     0   3%  flush-254:1
    3     - root     root         1   0.24s   0.00s      0K     0K     0K      0K --   -  S     0   2%  ksoftirqd/0
  335     - root     root         1   0.22s   0.00s      0K     0K     0K      0K --   -  S     0   2%  kworker/0:0


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=atop8

ATOP - brief                      2012/09/27  07:45:50                      ---------                      10s elapsed
PRC |  sys    0.59s |  user   0.28s |  #proc    161 |  #tslpi   163  | #tslpu     0  | #zombie    0  | #exit      2  |
CPU |  sys       5% |  user      3% |  irq       1% |  idle    392%  | wait      0%  | curf  800MHz  | curscal  44%  |
cpu |  sys       2% |  user      2% |  irq       0% |  idle     96%  | cpu000 w  0%  | curf  800MHz  | curscal  44%  |
cpu |  sys       1% |  user      1% |  irq       0% |  idle     98%  | cpu001 w  0%  | curf  800MHz  | curscal  44%  |
cpu |  sys       1% |  user      0% |  irq       0% |  idle     99%  | cpu003 w  0%  | curf  800MHz  | curscal  44%  |
cpu |  sys       0% |  user      0% |  irq       0% |  idle     99%  | cpu002 w  0%  | curf  800MHz  | curscal  44%  |
CPL |  avg1    0.08 |  avg5    0.14 |  avg15   0.14 |  csw     8051  | intr    5705  |               | numcpu     4  |
MEM |  tot     3.8G |  free    1.1G |  cache 490.2M |  dirty   0.0M  | buff    0.0M  | slab    2.0G  |               |
SWP |  tot     0.0M |  free    0.0M |               |                |               | vmcom 586.1M  | vmlim   1.9G  |
LVM |          root |  busy      0% |  read       9 |  write     25  | MBr/s   0.00  | MBw/s   0.01  | avio 0.88 ms  |
DSK |           sda |  busy      0% |  read       9 |  write     25  | MBr/s   0.00  | MBw/s   0.01  | avio 0.68 ms  |
NET |  transport    |  tcpi       0 |  tcpo       0 |  udpi       6  | udpo      22  | tcpao      0  | tcppo      0  |
NET |  network      |  ipi       44 |  ipo       44 |  ipfrw      0  | deliv     44  | icmpi     16  | icmpo     22  |
NET |  wlan0   ---- |  pcki      13 |  pcko      13 |  si    3 Kbps  | so    2 Kbps  | erri       0  | erro       0  |
NET |  lo      ---- |  pcki      32 |  pcko      32 |  si    1 Kbps  | so    1 Kbps  | erri       0  | erro       0  |
                                                                              
  PID   TID RUID     EUID       THR  SYSCPU  USRCPU   VGROW  RGROW  RDDSK   WRDSK ST EXC  S CPUNR  CPU  CMD        1/2
  453     - nico     root         1   0.10s   0.18s      0K     0K     0K      0K --   -  S     1   3%  X
25142     - root     root         1   0.13s   0.00s      0K     0K     0K      0K --   -  S     0   1%  kworker/u:1
  469     - nico     nico         1   0.04s   0.03s      0K     0K     0K      0K --   -  S     2   1%  urxvtd
  479     - nico     nico         1   0.07s   0.00s      0K     0K     0K      0K --   -  S     0   1%  i3status
25125     - root     root         1   0.05s   0.00s      0K     0K     0K      0K --   -  S     0   1%  kworker/0:2
30887     - nico     nico         1   0.03s   0.01s      0K     0K     0K      0K --   -  R     3   0%  atop
10223     - root     root         1   0.03s   0.01s      0K     0K     0K      0K --   -  S     1   0%  slabtop
  468     - nico     nico         1   0.02s   0.01s      0K     0K     0K      0K --   -  S     0   0%  dispad
 4955     - nico     nico         1   0.00s   0.02s      0K     0K     0K      0K --   -  S     2   0%  mosh-client
  458     - nico     nico         1   0.01s   0.01s      0K     0K     0K      0K --   -  S     2   0%  i3
22923     - root     root         1   0.02s   0.00s      0K     0K     0K      0K --   -  S     2   0%  kworker/2:2
25209     - root     root         1   0.02s   0.00s      0K     0K     0K      0K --   -  S     1   0%  kworker/1:0
10378     - nico     nico         1   0.00s   0.01s      0K     0K     0K      0K --   -  S     0   0%  mosh-client
  491     - root     root         1   0.01s   0.00s      0K    28K    36K     20K --   -  S     1   0%  zsh


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg1

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc7-00039-g6f0f9b6 (nico@brief) (gcc version 4.7.1 20120721 (prerelease) (GCC) ) #130 SMP PREEMPT Wed Sep 26 11:15:57 CEST 2012
[    0.000000] Command line: root=/dev/mapper/root cryptdevice=/dev/sda5:root ro i915.i915_enable_rc6=1 init=/bin/systemd initrd=../initramfs-nico.img BOOT_IMAGE=../vmlinuz-nico 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x000000008ad33fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008ad34000-0x000000008ad5efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008ad5f000-0x000000008afa1fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008afa2000-0x000000008affefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008afff000-0x000000008affffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008b000000-0x000000008f9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed13fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed18000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000016fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Apple Inc. MacBookAir4,2/Mac-742912EFDBEE19B3, BIOS MBA41.88Z.0077.B0E.1110141154 10/14/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x16fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 0A0000000 mask FE0000000 uncachable
[    0.000000]   2 base 090000000 mask FF0000000 uncachable
[    0.000000]   3 base 08C000000 mask FFC000000 uncachable
[    0.000000]   4 base 08B800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x8ad34 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x8ad33fff]
[    0.000000]  [mem 0x00000000-0x8abfffff] page 2M
[    0.000000]  [mem 0x8ac00000-0x8ad33fff] page 4k
[    0.000000] kernel direct mapping tables up to 0x8ad33fff @ [mem 0x1f82f000-0x1fc89fff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x16fdfffff]
[    0.000000]  [mem 0x100000000-0x16fdfffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x16fdfffff @ [mem 0x8ad2d000-0x8ad33fff]
[    0.000000] RAMDISK: [mem 0x1fc8a000-0x1fffefff]
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000008ad8e1c0 000AC (v01 APPLE   Apple00 00000060      01000013)
[    0.000000] ACPI: FACP 000000008ad8c000 000F4 (v04 APPLE   Apple00 00000060 Loki 0000005F)
[    0.000000] ACPI: DSDT 000000008ad81000 05050 (v01 APPLE  MacBookA 00040001 INTL 20100915)
[    0.000000] ACPI: FACS 000000008ad3e000 00040
[    0.000000] ACPI: HPET 000000008ad8b000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000008ad8a000 000BC (v02 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 000000008ad88000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 000000008ad87000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad7d000 00024 (v01 APPLE   SmcDppt 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7b000 006CA (v01 APPLE     UsbSD 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad77000 00159 (v02 APPLE     IGHda 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad73000 015EB (v02 APPLE  SsdtIGPU 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad72000 00569 (v01  PmRef  Cpu0Ist 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad71000 009B1 (v01  PmRef    CpuPm 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad70000 00315 (v01  PmRef  Cpu0Tst 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6f000 0037A (v01  PmRef    ApTst 00003000 INTL 20100915)
[    0.000000] ACPI: MCFG 000000008ad89000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad80000 000FA (v01 SataRe  SataPri 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7f000 000D0 (v01 SataRe  SataSec 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7e000 00032 (v01  Apple   SsdtS3 00001000 INTL 20100915)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000016fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x16fdfffff]
[    0.000000]   NODE_DATA [mem 0x16fdfb000-0x16fdfffff]
[    0.000000]  [ffffea0000000000-ffffea0005bfffff] PMD -> [ffff88016b400000-ffff88016f3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x16fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0008efff]
[    0.000000]   node   0: [mem 0x00090000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0x8ad33fff]
[    0.000000]   node   0: [mem 0x100000000-0x16fdfffff]
[    0.000000] On node 0 totalpages: 1025730
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 547188 pages, LIFO batch:31
[    0.000000]   Normal zone: 7160 pages used for memmap
[    0.000000]   Normal zone: 451080 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000008f000 - 0000000000090000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 000000008ad34000 - 000000008ad5f000
[    0.000000] PM: Registered nosave memory: 000000008ad5f000 - 000000008afa2000
[    0.000000] PM: Registered nosave memory: 000000008afa2000 - 000000008afff000
[    0.000000] PM: Registered nosave memory: 000000008afff000 - 000000008b000000
[    0.000000] PM: Registered nosave memory: 000000008b000000 - 000000008fa00000
[    0.000000] PM: Registered nosave memory: 000000008fa00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed04000
[    0.000000] PM: Registered nosave memory: 00000000fed04000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] e820: [mem 0x8fa00000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88016fa00000 s86336 r8192 d24256 u262144
[    0.000000] pcpu-alloc: s86336 r8192 d24256 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1002180
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/mapper/root cryptdevice=/dev/sda5:root ro i915.i915_enable_rc6=1 init=/bin/systemd initrd=../initramfs-nico.img BOOT_IMAGE=../vmlinuz-nico 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3946620k/6027264k available (4580k kernel code, 1924344k absent, 156300k reserved, 4361k data, 828k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 1799.943 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3601.88 BogoMIPS (lpj=5999810)
[    0.000137] pid_max: default: 32768 minimum: 301
[    0.000825] Security Framework initialized
[    0.000893] AppArmor: AppArmor disabled by boot time parameter
[    0.001464] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002794] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003431] Mount-cache hash table entries: 256
[    0.007366] Initializing cgroup subsys cpuacct
[    0.007433] Initializing cgroup subsys memory
[    0.007634] Initializing cgroup subsys devices
[    0.007707] Initializing cgroup subsys freezer
[    0.007775] Initializing cgroup subsys net_cls
[    0.007845] Initializing cgroup subsys blkio
[    0.008188] CPU: Physical Processor ID: 0
[    0.008251] CPU: Processor Core ID: 0
[    0.008317] mce: CPU supports 7 MCE banks
[    0.008397] CPU0: Thermal monitoring enabled (TM1)
[    0.008476] process: using mwait in idle threads
[    0.008546] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift is 0x5
[    0.010493] ACPI: Core revision 20120711
[    0.122999] ftrace: allocating 17586 entries in 69 pages
[    0.134962] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.167983] smpboot: CPU0: Intel(R) Core(TM) i7-2677M CPU @ 1.80GHz stepping 07
[    0.272176] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.272431] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.272522] ... version:                3
[    0.272584] ... bit width:              48
[    0.272647] ... generic registers:      4
[    0.272709] ... value mask:             0000ffffffffffff
[    0.272775] ... max period:             000000007fffffff
[    0.272841] ... fixed-purpose events:   3
[    0.272903] ... event mask:             000000070000000f
[    0.299228] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.312226] SMP alternatives: lockdep: fixing up alternatives
[    0.312303] smpboot: Booting Node   0, Processors  #1
[    0.338828] SMP alternatives: lockdep: fixing up alternatives
[    0.338953]  #2
[    0.365456] SMP alternatives: lockdep: fixing up alternatives
[    0.365581]  #3
[    0.379027] Brought up 4 CPUs
[    0.379146] smpboot: Total of 4 processors activated (14405.52 BogoMIPS)
[    0.386705] devtmpfs: initialized
[    0.394787] PM: Registering ACPI NVS region [mem 0x8ad34000-0x8ad5efff] (176128 bytes)
[    0.397243] dummy: 
[    0.398158] NET: Registered protocol family 16
[    0.399537] ACPI: bus type pci registered
[    0.400396] PCI: MMCONFIG for domain 0000 [bus 00-97] at [mem 0xe0000000-0xe97fffff] (base 0xe0000000)
[    0.400485] PCI: MMCONFIG at [mem 0xe0000000-0xe97fffff] reserved in E820
[    0.434195] PCI: Using configuration type 1 for base access
[    0.440624] bio: create slab <bio-0> at 0
[    0.441372] ACPI: Added _OSI(Module Device)
[    0.441443] ACPI: Added _OSI(Processor Device)
[    0.441515] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.441587] ACPI: Added _OSI(Processor Aggregator Device)
[    0.448316] ACPI: EC: EC description table is found, configuring boot EC
[    0.561674] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.573170] ACPI: SSDT 000000008ad39190 00781 (v01  PmRef  Cpu0Cst 00003001 INTL 20100915)
[    0.577111] ACPI: Dynamic OEM Table Load:
[    0.577259] ACPI: SSDT           (null) 00781 (v01  PmRef  Cpu0Cst 00003001 INTL 20100915)
[    0.595642] ACPI: SSDT 000000008ad3a710 003A4 (v01  PmRef    ApIst 00003000 INTL 20100915)
[    0.601886] ACPI: Dynamic OEM Table Load:
[    0.602033] ACPI: SSDT           (null) 003A4 (v01  PmRef    ApIst 00003000 INTL 20100915)
[    0.614505] ACPI: SSDT 000000008ad38d90 00119 (v01  PmRef    ApCst 00003000 INTL 20100915)
[    0.617615] ACPI: Dynamic OEM Table Load:
[    0.617762] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20100915)
[    0.639233] ACPI: Interpreter enabled
[    0.639299] ACPI: (supports S0 S3 S4 S5)
[    0.639781] ACPI: Using IOAPIC for interrupt routing
[    0.743232] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.745390] ACPI: No dock devices found.
[    0.745457] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.756320] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.773549] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-97] only partially covers this bridge
[    0.774136] PCI host bridge to bus 0000:00
[    0.774208] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.774210] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.774284] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.774357] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.774430] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.774505] pci_bus 0000:00: root bus resource [mem 0x8fa00000-0xfeafffff]
[    0.774580] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.774704] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.774826] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.774903] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.774988] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
[    0.775012] pci 0000:00:02.0: reg 10: [mem 0xa0000000-0xa03fffff 64bit]
[    0.775024] pci 0000:00:02.0: reg 18: [mem 0x90000000-0x9fffffff 64bit pref]
[    0.775033] pci 0000:00:02.0: reg 20: [io  0x2000-0x203f]
[    0.775167] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.775212] pci 0000:00:16.0: reg 10: [mem 0xa0607100-0xa060710f 64bit]
[    0.775360] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.775432] pci 0000:00:1a.0: [8086:1c2c] type 00 class 0x0c0300
[    0.775522] pci 0000:00:1a.0: reg 20: [io  0x2140-0x215f]
[    0.775666] pci 0000:00:1a.7: [8086:1c2d] type 00 class 0x0c0320
[    0.775706] pci 0000:00:1a.7: reg 10: [mem 0xa0606c00-0xa0606fff]
[    0.775882] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.775945] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.775979] pci 0000:00:1b.0: reg 10: [mem 0xa0600000-0xa0603fff 64bit]
[    0.776141] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.776204] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.776381] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.776446] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.776626] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.776701] pci 0000:00:1d.0: [8086:1c27] type 00 class 0x0c0300
[    0.776792] pci 0000:00:1d.0: reg 20: [io  0x20e0-0x20ff]
[    0.776937] pci 0000:00:1d.7: [8086:1c26] type 00 class 0x0c0320
[    0.776977] pci 0000:00:1d.7: reg 10: [mem 0xa0606800-0xa0606bff]
[    0.777156] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.777213] pci 0000:00:1f.0: [8086:1c4d] type 00 class 0x060100
[    0.777442] pci 0000:00:1f.2: [8086:1c01] type 00 class 0x01018f
[    0.777477] pci 0000:00:1f.2: reg 10: [io  0x2168-0x216f]
[    0.777493] pci 0000:00:1f.2: reg 14: [io  0x217c-0x217f]
[    0.777511] pci 0000:00:1f.2: reg 18: [io  0x2160-0x2167]
[    0.777529] pci 0000:00:1f.2: reg 1c: [io  0x2178-0x217b]
[    0.777547] pci 0000:00:1f.2: reg 20: [io  0x2060-0x206f]
[    0.777565] pci 0000:00:1f.2: reg 24: [io  0xffe0-0xffef]
[    0.777687] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.777721] pci 0000:00:1f.3: reg 10: [mem 0xa0607000-0xa06070ff 64bit]
[    0.777768] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.777886] pci_bus 0000:03: busn_res: [bus 03-97] is inserted under [bus 00-ff]
[    0.777919] pci 0000:03:00.0: [8086:151a] type 01 class 0x060400
[    0.778018] pci 0000:03:00.0: supports D1 D2
[    0.778020] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.784842] pci 0000:00:01.0: PCI bridge to [bus 03-97]
[    0.784911] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.784916] pci 0000:00:01.0:   bridge window [mem 0xa0700000-0xa49fffff]
[    0.784922] pci 0000:00:01.0:   bridge window [mem 0xa4a00000-0xa89fffff 64bit pref]
[    0.784991] pci_bus 0000:04: busn_res: [bus 04-67] is inserted under [bus 03-97]
[    0.785029] pci 0000:04:00.0: [8086:151a] type 01 class 0x060400
[    0.785134] pci 0000:04:00.0: supports D1 D2
[    0.785136] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.785200] pci 0000:04:03.0: [8086:151a] type 01 class 0x060400
[    0.785303] pci 0000:04:03.0: supports D1 D2
[    0.785305] pci 0000:04:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.785362] pci 0000:04:04.0: [8086:151a] type 01 class 0x060400
[    0.785465] pci 0000:04:04.0: supports D1 D2
[    0.785467] pci 0000:04:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.785536] pci 0000:03:00.0: PCI bridge to [bus 04-67]
[    0.785610] pci 0000:03:00.0:   bridge window [mem 0xa0700000-0xa09fffff]
[    0.785683] pci_bus 0000:05: busn_res: [bus 05] is inserted under [bus 04-67]
[    0.785723] pci 0000:05:00.0: [8086:151a] type 00 class 0x088000
[    0.785743] pci 0000:05:00.0: reg 10: [mem 0xa0700000-0xa073ffff]
[    0.785757] pci 0000:05:00.0: reg 14: [mem 0xa0740000-0xa0740fff]
[    0.785899] pci 0000:05:00.0: supports D1 D2
[    0.785901] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.791400] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.791486] pci 0000:04:00.0:   bridge window [mem 0xa0700000-0xa07fffff]
[    0.791562] pci_bus 0000:06: busn_res: [bus 06-36] is inserted under [bus 04-67]
[    0.791567] pci 0000:04:03.0: PCI bridge to [bus 06-36]
[    0.791642] pci 0000:04:03.0:   bridge window [mem 0xa0800000-0xa08fffff]
[    0.791717] pci_bus 0000:37: busn_res: [bus 37-67] is inserted under [bus 04-67]
[    0.791721] pci 0000:04:04.0: PCI bridge to [bus 37-67]
[    0.791796] pci 0000:04:04.0:   bridge window [mem 0xa0900000-0xa09fffff]
[    0.791934] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-ff]
[    0.791939] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.792014] pci 0000:00:1c.0:   bridge window [mem 0xa0500000-0xa05fffff]
[    0.792126] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-ff]
[    0.792234] pci 0000:02:00.0: [14e4:4353] type 00 class 0x028000
[    0.792302] pci 0000:02:00.0: reg 10: [mem 0xa0400000-0xa0403fff 64bit]
[    0.792668] pci 0000:02:00.0: supports D1 D2
[    0.792670] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.798101] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.798177] pci 0000:00:1c.1:   bridge window [mem 0xa0400000-0xa04fffff]
[    0.798230] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.804071] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.806840] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.810225]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.815232]  pci0000:00: ACPI _OSC control (0x19) granted
[    0.925847] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.927417] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.929089] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.930644] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.932162] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.933762] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.935426] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.936991] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.938790] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.938997] vgaarb: loaded
[    0.939057] vgaarb: bridge control possible 0000:00:02.0
[    0.939798] PCI: Using ACPI for IRQ routing
[    0.945021] PCI: pci_cache_line_size set to 64 bytes
[    0.945450] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
[    0.945471] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.945480] e820: reserve RAM buffer [mem 0x8ad34000-0x8bffffff]
[    0.945516] e820: reserve RAM buffer [mem 0x16fe00000-0x16fffffff]
[    0.946742] NetLabel: Initializing
[    0.946805] NetLabel:  domain hash size = 128
[    0.946868] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.947063] NetLabel:  unlabeled traffic allowed by default
[    0.947157] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.947594] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.949900] Switching to clocksource hpet
[    1.029472] pnp: PnP ACPI init
[    1.029648] ACPI: bus type pnp registered
[    1.037535] pnp 00:00: [bus 00-ff]
[    1.037544] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.037552] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.037560] pnp 00:00: [io  0x0d00-0xffff window]
[    1.037567] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.037574] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    1.037581] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    1.037588] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    1.037598] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    1.037605] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    1.037612] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    1.037620] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    1.037627] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    1.037634] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    1.037641] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    1.037648] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    1.037655] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    1.037662] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    1.037669] pnp 00:00: [mem 0x8fa00000-0xfeafffff window]
[    1.037676] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    1.038003] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.039399] pnp 00:01: [io  0x0000-0x001f]
[    1.039407] pnp 00:01: [io  0x0081-0x0091]
[    1.039414] pnp 00:01: [io  0x0093-0x009f]
[    1.039421] pnp 00:01: [io  0x00c0-0x00df]
[    1.039428] pnp 00:01: [dma 4]
[    1.039688] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.039792] pnp 00:02: [mem 0xff000000-0xffffffff]
[    1.040060] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    1.041189] pnp 00:03: [irq 0 disabled]
[    1.041208] pnp 00:03: [irq 8]
[    1.041216] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.041740] system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
[    1.041816] system 00:03: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    1.041948] pnp 00:04: [io  0x00f0]
[    1.041962] pnp 00:04: [irq 13]
[    1.042218] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.042325] pnp 00:05: [io  0x002e-0x002f]
[    1.042332] pnp 00:05: [io  0x004e-0x004f]
[    1.042341] pnp 00:05: [io  0x0061]
[    1.042348] pnp 00:05: [io  0x0063]
[    1.042355] pnp 00:05: [io  0x0065]
[    1.042362] pnp 00:05: [io  0x0067]
[    1.042369] pnp 00:05: [io  0x0080]
[    1.042376] pnp 00:05: [io  0x0092]
[    1.042383] pnp 00:05: [io  0x00b2-0x00b3]
[    1.042390] pnp 00:05: [io  0x1000-0x100f]
[    1.042397] pnp 00:05: [io  0x0400-0x047f]
[    1.042404] pnp 00:05: [io  0x0500-0x057f]
[    1.042903] system 00:05: [io  0x1000-0x100f] has been reserved
[    1.042987] system 00:05: [io  0x0400-0x047f] has been reserved
[    1.043068] system 00:05: [io  0x0500-0x057f] has been reserved
[    1.043139] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.043263] pnp 00:06: [io  0x0070-0x0077]
[    1.043523] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.043670] pnp 00:07: [io  0x0300-0x031f]
[    1.043684] pnp 00:07: [irq 6]
[    1.043944] pnp 00:07: Plug and Play ACPI device, IDs APP0001 (active)
[    1.047462] pnp 00:08: [mem 0xfed1c000-0xfed1ffff]
[    1.047471] pnp 00:08: [mem 0xfed10000-0xfed17fff]
[    1.047478] pnp 00:08: [mem 0xfed18000-0xfed18fff]
[    1.047485] pnp 00:08: [mem 0xfed19000-0xfed19fff]
[    1.047492] pnp 00:08: [mem 0xe0000000-0xefffffff]
[    1.047499] pnp 00:08: [mem 0xfed20000-0xfed3ffff]
[    1.047506] pnp 00:08: [mem 0xfed90000-0xfed93fff]
[    1.047513] pnp 00:08: [mem 0xfed45000-0xfed8ffff]
[    1.047520] pnp 00:08: [mem 0xff000000-0xffffffff]
[    1.047527] pnp 00:08: [mem 0xfee00000-0xfeefffff]
[    1.047537] pnp 00:08: [mem 0x00000000-0xffffffffffffffff disabled]
[    1.048045] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.048140] system 00:08: [mem 0xfed10000-0xfed17fff] could not be reserved
[    1.048224] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.048307] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.048389] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
[    1.048474] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.048557] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    1.048639] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.048727] system 00:08: [mem 0xff000000-0xffffffff] could not be reserved
[    1.048817] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.048890] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.059765] pnp 00:09: [mem 0x20000000-0x201fffff]
[    1.059774] pnp 00:09: [mem 0x40000000-0x401fffff]
[    1.060343] system 00:09: [mem 0x20000000-0x201fffff] has been reserved
[    1.060427] system 00:09: [mem 0x40000000-0x401fffff] has been reserved
[    1.060501] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.060538] pnp: PnP ACPI: found 10 devices
[    1.060601] ACPI: ACPI bus type pnp unregistered
[    1.081725] pci 0000:04:00.0: PCI bridge to [bus 05]
[    1.081800] pci 0000:04:00.0:   bridge window [mem 0xa0700000-0xa07fffff]
[    1.081879] pci 0000:04:03.0: PCI bridge to [bus 06-36]
[    1.081949] pci 0000:04:03.0:   bridge window [mem 0xa0800000-0xa08fffff]
[    1.082026] pci 0000:04:04.0: PCI bridge to [bus 37-67]
[    1.082097] pci 0000:04:04.0:   bridge window [mem 0xa0900000-0xa09fffff]
[    1.082175] pci 0000:03:00.0: PCI bridge to [bus 04-67]
[    1.082244] pci 0000:03:00.0:   bridge window [mem 0xa0700000-0xa09fffff]
[    1.082321] pci 0000:00:01.0: PCI bridge to [bus 03-97]
[    1.082388] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    1.082458] pci 0000:00:01.0:   bridge window [mem 0xa0700000-0xa49fffff]
[    1.082530] pci 0000:00:01.0:   bridge window [mem 0xa4a00000-0xa89fffff 64bit pref]
[    1.082618] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.082691] pci 0000:00:1c.0:   bridge window [mem 0xa0500000-0xa05fffff]
[    1.082775] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    1.082848] pci 0000:00:1c.1:   bridge window [mem 0xa0400000-0xa04fffff]
[    1.083545] pci 0000:04:03.0: enabling device (0000 -> 0002)
[    1.083692] pci 0000:04:04.0: enabling device (0000 -> 0002)
[    1.083769] pci 0000:00:1c.0: enabling device (0000 -> 0002)
[    1.083921] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.083924] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.083926] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.083929] pci_bus 0000:00: resource 7 [mem 0x8fa00000-0xfeafffff]
[    1.083931] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    1.083933] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    1.083936] pci_bus 0000:03: resource 1 [mem 0xa0700000-0xa49fffff]
[    1.083938] pci_bus 0000:03: resource 2 [mem 0xa4a00000-0xa89fffff 64bit pref]
[    1.083941] pci_bus 0000:04: resource 1 [mem 0xa0700000-0xa09fffff]
[    1.083944] pci_bus 0000:05: resource 1 [mem 0xa0700000-0xa07fffff]
[    1.083946] pci_bus 0000:06: resource 1 [mem 0xa0800000-0xa08fffff]
[    1.083949] pci_bus 0000:37: resource 1 [mem 0xa0900000-0xa09fffff]
[    1.083952] pci_bus 0000:01: resource 1 [mem 0xa0500000-0xa05fffff]
[    1.083954] pci_bus 0000:02: resource 1 [mem 0xa0400000-0xa04fffff]
[    1.084249] NET: Registered protocol family 2
[    1.086107] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.088101] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    1.093480] TCP: Hash tables configured (established 524288 bind 65536)
[    1.093605] TCP: reno registered
[    1.093725] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    1.094179] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    1.095327] NET: Registered protocol family 1
[    1.095462] pci 0000:00:02.0: Boot video device
[    1.096280] PCI: CLS 256 bytes, default 64
[    1.096731] Unpacking initramfs...
[    1.209209] Freeing initrd memory: 3540k freed
[    1.209904] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.209978] software IO TLB [mem 0x86d2d000-0x8ad2cfff] (64MB) mapped at [ffff880086d2d000-ffff88008ad2cfff]
[    1.213210] audit: initializing netlink socket (disabled)
[    1.213364] type=2000 audit(1348651425.106:1): initialized
[    1.215553] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.232774] VFS: Disk quotas dquot_6.5.2
[    1.233391] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.234916] msgmni has been set to 7715
[    1.236493] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.236763] io scheduler noop registered
[    1.236827] io scheduler deadline registered
[    1.237459] io scheduler cfq registered (default)
[    1.238080] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
[    1.238145] crc32: self tests passed, processed 225944 bytes in 268191 nsec
[    1.238478] crc32c: CRC_LE_BITS = 64
[    1.238541] crc32c: self tests passed, processed 225944 bytes in 131511 nsec
[    1.239695] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    1.240417] pcieport 0000:03:00.0: irq 41 for MSI/MSI-X
[    1.241046] pcieport 0000:04:00.0: irq 42 for MSI/MSI-X
[    1.241665] pcieport 0000:04:03.0: irq 43 for MSI/MSI-X
[    1.242413] pcieport 0000:04:04.0: irq 44 for MSI/MSI-X
[    1.243928] intel_idle: MWAIT substates: 0x21120
[    1.243931] intel_idle: v0.4 model 0x2A
[    1.243933] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.244213] GHES: HEST is not enabled!
[    1.244611] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.247905] Linux agpgart interface v0.103
[    1.248564] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.249524] i8042: No controller found
[    1.250164] mousedev: PS/2 mouse device common for all mice
[    1.250572] rtc_cmos 00:06: RTC can wake from S4
[    1.251393] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.251530] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.252949] cpuidle: using governor ladder
[    1.255209] cpuidle: using governor menu
[    1.256193] drop_monitor: Initializing network drop monitor service
[    1.256598] TCP: cubic registered
[    1.256662] NET: Registered protocol family 17
[    1.256849] Key type dns_resolver registered
[    1.258881] PM: Hibernation image not present or could not be loaded.
[    1.258913] registered taskstats version 1
[    1.259282] kmemleak: Kernel memory leak detector initialized
[    1.259286] kmemleak: Automatic memory scanning thread started
[    1.266952] rtc_cmos 00:06: setting system clock to 2012-09-26 09:23:45 UTC (1348651425)
[    1.270152] Freeing unused kernel memory: 828k freed
[    1.270349] Write protecting the kernel read-only data: 8192k
[    1.275988] Freeing unused kernel memory: 1552k freed
[    1.276951] Freeing unused kernel memory: 108k freed
[    1.304288] systemd-udevd[54]: starting version 189
[    1.430109] ACPI: bus type usb registered
[    1.430456] usbcore: registered new interface driver usbfs
[    1.430668] usbcore: registered new interface driver hub
[    1.431030] usbcore: registered new device driver usb
[    1.434518] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.434953] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.434961] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.435271] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.439469] ehci_hcd 0000:00:1a.7: debug port 2
[    1.439556] ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
[    1.439805] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xa0606c00
[    1.444755] SCSI subsystem initialized
[    1.447794] ACPI: bus type scsi registered
[    1.448240] libata version 3.00 loaded.
[    1.449656] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.460720] hub 1-0:1.0: USB hub found
[    1.460913] hub 1-0:1.0: 6 ports detected
[    1.464421] ata_piix 0000:00:1f.2: version 2.13
[    1.464443] uhci_hcd: USB Universal Host Controller Interface driver
[    1.464468] ata_piix 0000:00:1f.2: MAP [
[    1.464472]  P0 P2 P1 P3 ]
[    1.615924] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.621684] scsi0 : ata_piix
[    1.627124] scsi1 : ata_piix
[    1.631949] ata1: SATA max UDMA/133 cmd 0x2168 ctl 0x217c bmdma 0x2060 irq 19
[    1.632028] ata2: SATA max UDMA/133 cmd 0x2160 ctl 0x2178 bmdma 0x2068 irq 19
[    1.632424] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.632432] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.632585] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.636692] ehci_hcd 0000:00:1d.7: debug port 2
[    1.636768] ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
[    1.636950] ehci_hcd 0000:00:1d.7: irq 22, io mem 0xa0606800
[    1.645876] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.648776] hub 2-0:1.0: USB hub found
[    1.648939] hub 2-0:1.0: 8 ports detected
[    1.650733] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.650742] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.650923] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.651302] uhci_hcd 0000:00:1a.0: irq 21, io base 0x00002140
[    1.653132] hub 3-0:1.0: USB hub found
[    1.653284] hub 3-0:1.0: 2 ports detected
[    1.654408] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.654413] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.654521] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    1.654672] uhci_hcd 0000:00:1d.0: irq 19, io base 0x000020e0
[    1.656420] hub 4-0:1.0: USB hub found
[    1.656567] hub 4-0:1.0: 2 ports detected
[    1.768950] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.895780] hub 1-1:1.0: USB hub found
[    1.895988] hub 1-1:1.0: 3 ports detected
[    2.001909] usb 1-2: new high-speed USB device number 3 using ehci_hcd
[    2.211613] tsc: Refined TSC clocksource calibration: 1800.012 MHz
[    2.211706] Switching to clocksource tsc
[    2.251521] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    2.377783] hub 2-1:1.0: USB hub found
[    2.378130] hub 2-1:1.0: 2 ports detected
[    2.458089] usb 1-1.1: new full-speed USB device number 4 using ehci_hcd
[    2.560282] hub 1-1.1:1.0: USB hub found
[    2.560550] hub 1-1.1:1.0: 3 ports detected
[    2.641164] usb 1-1.2: new full-speed USB device number 5 using ehci_hcd
[    2.654180] ata2.00: failed to resume link (SControl 0)
[    2.771761] usbcore: registered new interface driver usbhid
[    2.771838] usbhid: USB HID core driver
[    2.787505] input: Apple Inc. Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.0/input/input0
[    2.788576] apple 0003:05AC:024D.0001: input,hidraw0: USB HID v1.11 Keyboard [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input0
[    2.830868] usb 2-1.1: new high-speed USB device number 3 using ehci_hcd
[    2.870585] apple 0003:05AC:024D.0002: hidraw1: USB HID v1.11 Device [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1a.7-1.2/input1
[    2.939618] Initializing USB Mass Storage driver...
[    2.940177] scsi2 : usb-storage 2-1.1:1.0
[    2.941020] usbcore: registered new interface driver usb-storage
[    2.941085] USB Mass Storage support registered.
[    2.973666] ata1.01: failed to resume link (SControl 0)
[    3.003831] usb 1-1.1.1: new full-speed USB device number 6 using ehci_hcd
[    3.095722] input: HID 05ac:820a as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/input/input1
[    3.096456] hid-generic 0003:05AC:820A.0003: input,hidraw2: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:1a.7-1.1.1/input0
[    3.126840] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.126926] ata1.01: SATA link down (SStatus 0 SControl 0)
[    3.135461] ata1.00: ATA-8: APPLE SSD SM256C, AXM09A1Q, max UDMA/133
[    3.135536] ata1.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.142043] ata1.00: configured for UDMA/133
[    3.143836] scsi 0:0:0:0: Direct-Access     ATA      APPLE SSD SM256C AXM0 PQ: 0 ANSI: 5
[    3.160346] usb 1-1.1.2: new full-speed USB device number 7 using ehci_hcd
[    3.251046] input: HID 05ac:820b as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.1/1-1.1.2/1-1.1.2:1.0/input/input2
[    3.253025] hid-generic 0003:05AC:820B.0004: input,hidraw3: USB HID v1.11 Mouse [HID 05ac:820b] on usb-0000:00:1a.7-1.1.2/input0
[    3.320101] usb 1-1.1.3: new full-speed USB device number 8 using ehci_hcd
[    3.675940] ata2.01: failed to resume link (SControl 0)
[    3.687633] ata2.00: SATA link down (SStatus 0 SControl 0)
[    3.687714] ata2.01: SATA link down (SStatus 0 SControl 0)
[    3.705013] sd 0:0:0:0: [sda] 490234752 512-byte logical blocks: (251 GB/233 GiB)
[    3.705979] sd 0:0:0:0: [sda] Write Protect is off
[    3.706049] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.706280] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.714910]  sda: sda1 sda2 sda3 sda4 sda5
[    3.720097] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.893706] device-mapper: uevent: version 1.0.3
[    3.894614] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[    3.965040] scsi 2:0:0:0: Direct-Access     APPLE    SD Card Reader   2.00 PQ: 0 ANSI: 0
[    3.971494] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   11.029169] JFS: nTxBlock = 8192, nTxLock = 65536
[   11.424576] systemd[1]: systemd 189 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ; arch)
[   11.453021] systemd[1]: Inserted module 'autofs4'
[   11.467427] NET: Registered protocol family 10
[   11.469893] systemd[1]: Inserted module 'ipv6'
[   11.472155] systemd[1]: Set hostname to <brief>.
[   11.531169] systemd-fstab-generator[180]: Failed to create unit file: File exists
[   11.531295] systemd-fstab-generator[180]: Failed to create unit file: File exists
[   11.531748] systemd[1]: /usr/lib/systemd/system-generators/systemd-fstab-generator exited with exit status 1.
[   11.634480] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory. See system logs and 'systemctl status display-manager.service' for details.
[   11.895692] FS-Cache: Loaded
[   11.905500] RPC: Registered named UNIX socket transport module.
[   11.905573] RPC: Registered udp transport module.
[   11.905638] RPC: Registered tcp transport module.
[   11.905702] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   11.920992] FS-Cache: Netfs 'nfs' registered for caching
[   12.070249] systemd-udevd[201]: starting version 189
[   12.173851] systemd-journald[205]: Successfully opened /dev/kmsg for logging.
[   12.178882] systemd-journald[205]: Fixed max_use=193.0M max_size=24.1M min_size=64.0K keep_free=96.5M
[   12.179388] systemd-journald[205]: Reserving 43925 entries in hash table.
[   12.181450] systemd-journald[205]: Vacuuming...
[   12.181701] systemd-journald[205]: Flushing /dev/kmsg...
[   12.325176] systemd-journald[205]: systemd-journald running as pid 205
[   12.368603] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input3
[   12.369113] ACPI: Lid Switch [LID0]
[   12.369924] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[   12.370040] ACPI: Power Button [PWRB]
[   12.371312] ACPI: Requesting acpi_cpufreq
[   12.372850] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input5
[   12.372973] ACPI: Sleep Button [SLPB]
[   12.375979] ACPI: AC Adapter [ADP1] (on-line)
[   12.503071] mei 0000:00:16.0: setting latency timer to 64
[   12.503575] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[   12.513354] mei 0000:00:16.0: wd: failed to find the client
[   12.541423] bcma: bus0: Found chip with id 0xA8D8, rev 0x01 and package 0x08
[   12.541550] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
[   12.541801] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
[   12.541959] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
[    3.149578] ACPI: Invalid Power Resource to register!
[   12.557190] ACPI Warning: 
[   12.557248] 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20120711/utaddress-251)
[   12.557398] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   12.557496] ACPI Warning: 0x0000000000000500-0x000000000000057f SystemIO conflicts with Region \GPIO 1 (20120711/utaddress-251)
[   12.557686] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   12.557775] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   12.618689] bcma: bus0: Bus registered
[   12.740462] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
[   12.741025] input: bcm5974 as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1.2/1-1.2:1.2/input/input7
[   12.741160] ACPI: Power Button [PWRF]
[   12.749330] usbcore: registered new interface driver bcm5974
[   12.752895] Linux media interface: v0.10
[   12.784883] Bluetooth: Core ver 2.16
[   12.785222] NET: Registered protocol family 31
[   12.785333] Bluetooth: HCI device and connection manager initialized
[   12.785511] Bluetooth: HCI socket layer initialized
[   12.785625] Bluetooth: L2CAP socket layer initialized
[   12.785791] Bluetooth: SCO socket layer initialized
[   12.784786] ACPI Warning: 0x000000000000efa0-0x000000000000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120711/utaddress-251)
[   12.786395] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   12.796998] input: PC Speaker as /devices/platform/pcspkr/input/input8
[   12.811675] usbcore: registered new interface driver btusb
[   12.816890] usb 1-1.1.1: USB disconnect, device number 6
[   12.855868] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x1a
[   12.961408] ACPI: Battery Slot [BAT0] (battery present)
[   12.974558] Linux video capture interface: v2.00
[   12.997625] [drm] Initialized drm 1.1.0 20060810
[   13.008350] usb 1-1.1.2: USB disconnect, device number 7
[   13.019566] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   13.046137] uvcvideo: Found UVC 1.00 device FaceTime Camera (Built-in) (05ac:850a)
[   13.062324] input: FaceTime Camera (Built-in) as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/input/input9
[   13.065449] usbcore: registered new interface driver uvcvideo
[   13.065523] USB Video Class driver (1.1.1)
[   13.096918] iTCO_vendor_support: vendor-support=0
[   13.109610] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   13.109831] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[   13.141990] applesmc: key=349 fan=1 temp=25 index=24 acc=0 lux=2 kbd=1
[   13.153165] cfg80211: Calling CRDA to update world regulatory domain
[   13.157453] Registered led device: smc::kbd_backlight
[   13.191709] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1a
[   13.250134] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x1a
[   13.255277] brcmsmac bcma0:0: mfg 4bf core 812 rev 23 class 0 irq 17
[   13.266740] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x1a
[   13.270691] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   13.292856] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   13.481559] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: (null)
[   13.984294] systemd-journald[205]: Received SIGUSR1
[   14.587829] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   14.589224] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   14.590575] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   14.592284] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   14.621161] pci 0000:00:00.0: Intel Sandybridge Chipset
[   14.623139] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   14.625083] pci 0000:00:00.0: detected 65536K stolen memory
[   14.626553] i915 0000:00:02.0: setting latency timer to 64
[   14.701603] i915 0000:00:02.0: irq 47 for MSI/MSI-X
[   14.701742] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   14.701800] [drm] Driver supports precise vblank timestamp query.
[   14.703801] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   15.866919] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   16.669013] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[   16.867006] fbcon: inteldrmfb (fb0) is primary device
[   17.875380] Console: switching to colour frame buffer device 180x56
[   17.878902] fb0: inteldrmfb frame buffer device
[   17.878921] drm: registered panic notifier
[   17.963668] acpi device:0d: registered as cooling_device4
[   17.970030] ACPI: Video Device [IGPU] (multi-head: yes  rom: no  post: no)
[   17.970917] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input14
[   17.972492] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   68.140738] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[   68.140791] ieee80211 phy0: brcms_ops_config: change monitor mode: false
[   68.140795] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[   68.142836] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   68.270101] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[   72.197380] wlan0: authenticate with d4:a0:2a:98:a6:af
[   72.203274] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[   72.216991] wlan0: direct probe to d4:a0:2a:98:a6:af (try 1/3)
[   72.418817] wlan0: send auth to d4:a0:2a:98:a6:af (try 2/3)
[   72.419830] wlan0: authenticated
[   72.422140] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[   72.424311] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=38)
[   72.424860] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[   72.424873] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[   72.424879] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[   72.425269] wlan0: associated
[   72.426173] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   78.310550] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[  120.143731] CPU1: Core temperature above threshold, cpu clock throttled (total events = 1)
[  120.143732] CPU3: Core temperature above threshold, cpu clock throttled (total events = 1)
[  120.143735] CPU3: Package temperature above threshold, cpu clock throttled (total events = 1)
[  120.143747] CPU1: Package temperature above threshold, cpu clock throttled (total events = 1)
[  120.143760] CPU2: Package temperature above threshold, cpu clock throttled (total events = 1)
[  120.143762] CPU0: Package temperature above threshold, cpu clock throttled (total events = 1)
[  120.144711] CPU3: Core temperature/speed normal
[  120.144712] CPU1: Core temperature/speed normal
[  120.144714] CPU1: Package temperature/speed normal
[  120.144717] CPU3: Package temperature/speed normal
[  120.144743] CPU2: Package temperature/speed normal
[  120.144744] CPU0: Package temperature/speed normal

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg2

[  299.957737] mce: [Hardware Error]: Machine check events logged
[  682.858804] kmemleak: 6 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[ 4826.635958] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[ 4826.639026] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[ 4826.645375] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[ 4826.646779] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[ 8192.667373] ieee80211 phy0: brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel possibly 44
[ 9850.609296] kmemleak: 11 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg3

[12923.536604] kmemleak: 11 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[13622.313526] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[13622.313553] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[13622.313560] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[13622.333694] cfg80211: Calling CRDA for country: CH
[13622.433615] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13626.318522] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13626.319260] wlan0: authenticate with d4:a0:2a:9a:e7:9f
[13626.319565] wlan0: direct probe to d4:a0:2a:9a:e7:9f (try 1/3)
[13626.519598] wlan0: send auth to d4:a0:2a:9a:e7:9f (try 2/3)
[13626.520455] wlan0: authenticated
[13626.522979] wlan0: associate with d4:a0:2a:9a:e7:9f (try 1/3)
[13626.525098] wlan0: RX AssocResp from d4:a0:2a:9a:e7:9f (capab=0x11 status=0 aid=3)
[13626.525627] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[13626.525640] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[13626.525646] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[13626.525672] wlan0: associated
[13631.731387] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[13651.258075] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[13651.258101] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[13651.258108] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[13651.281426] cfg80211: Calling CRDA to update world regulatory domain
[13651.381830] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13655.266773] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13655.268762] wlan0: authenticate with d4:a0:2a:9a:fa:4f
[13655.270921] wlan0: direct probe to d4:a0:2a:9a:fa:4f (try 1/3)
[13655.471155] wlan0: direct probe to d4:a0:2a:9a:fa:4f (try 2/3)
[13655.674160] wlan0: direct probe to d4:a0:2a:9a:fa:4f (try 3/3)
[13655.877174] wlan0: authentication with d4:a0:2a:9a:fa:4f timed out
[13661.263482] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13665.018206] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13665.019178] wlan0: authenticate with d4:a0:2a:9a:fa:4e
[13665.019434] wlan0: direct probe to d4:a0:2a:9a:fa:4e (try 1/3)
[13665.222682] wlan0: direct probe to d4:a0:2a:9a:fa:4e (try 2/3)
[13665.425629] wlan0: direct probe to d4:a0:2a:9a:fa:4e (try 3/3)
[13665.628605] wlan0: authentication with d4:a0:2a:9a:fa:4e timed out
[13671.016937] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13674.709777] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13679.706817] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13683.402894] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13683.405374] wlan0: authenticate with 00:11:5c:d4:9e:70
[13683.418038] wlan0: send auth to 00:11:5c:d4:9e:70 (try 1/3)
[13683.440569] wlan0: authenticated
[13683.447601] wlan0: associate with 00:11:5c:d4:9e:70 (try 1/3)
[13683.482113] wlan0: RX AssocResp from 00:11:5c:d4:9e:70 (capab=0x401 status=0 aid=4)
[13683.483436] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[13683.483447] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[13683.483453] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[13683.483615] wlan0: associated
[13694.236621] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[13705.234527] wlan0: deauthenticated from 00:11:5c:d4:9e:70 (Reason: 2)
[13705.260417] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[13705.260442] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[13705.260448] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[13705.263406] cfg80211: Calling CRDA to update world regulatory domain
[13705.363774] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13709.246697] wlan0: authenticate with 00:11:5c:d4:95:30
[13709.251427] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13709.253573] wlan0: direct probe to 00:11:5c:d4:95:30 (try 1/3)
[13709.453623] wlan0: direct probe to 00:11:5c:d4:95:30 (try 2/3)
[13709.656702] wlan0: direct probe to 00:11:5c:d4:95:30 (try 3/3)
[13709.859704] wlan0: authentication with 00:11:5c:d4:95:30 timed out
[13715.248066] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13719.057686] wlan0: authenticate with 02:1a:11:ff:13:0a
[13719.065831] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[13719.067947] wlan0: send auth to 02:1a:11:ff:13:0a (try 1/3)
[13719.070668] wlan0: authenticated
[13719.072039] wlan0: associate with 02:1a:11:ff:13:0a (try 1/3)
[13719.075041] wlan0: RX AssocResp from 02:1a:11:ff:13:0a (capab=0x411 status=0 aid=1)
[13719.076468] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[13719.076481] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[13719.076487] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[13719.076639] wlan0: associated
[13731.748203] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg4-before-backup

[14336.211982] tun: Universal TUN/TAP device driver, 1.6
[14336.211996] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[21521.616595] CPU1: Core temperature above threshold, cpu clock throttled (total events = 4451)
[21521.616597] CPU3: Core temperature above threshold, cpu clock throttled (total events = 4451)
[21521.616600] CPU3: Package temperature above threshold, cpu clock throttled (total events = 4886)
[21521.616604] CPU2: Package temperature above threshold, cpu clock throttled (total events = 4886)
[21521.616605] CPU0: Package temperature above threshold, cpu clock throttled (total events = 4886)
[21521.616610] CPU1: Package temperature above threshold, cpu clock throttled (total events = 4886)
[21521.617575] CPU1: Core temperature/speed normal
[21521.617576] CPU3: Core temperature/speed normal
[21521.617577] CPU0: Package temperature/speed normal
[21521.617578] CPU2: Package temperature/speed normal
[21521.617579] CPU3: Package temperature/speed normal
[21521.617585] CPU1: Package temperature/speed normal
[21566.819870] mce: [Hardware Error]: Machine check events logged
[23815.505098] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[23815.505123] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[23815.505130] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[23815.558485] cfg80211: Calling CRDA to update world regulatory domain
[23815.658848] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23819.539019] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23824.523506] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23828.345372] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23833.333314] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23837.151612] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23842.136857] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23845.954533] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23850.942988] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23854.764131] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23859.752064] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23863.570490] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23868.555617] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23872.373405] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23877.360484] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23881.179591] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23886.164950] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23889.986106] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23894.969423] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23898.788891] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23903.772204] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23907.586862] wlan0: authenticate with 00:11:5c:d4:95:30
[23907.595148] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23907.597205] wlan0: direct probe to 00:11:5c:d4:95:30 (try 1/3)
[23907.797708] wlan0: direct probe to 00:11:5c:d4:95:30 (try 2/3)
[23908.000739] wlan0: direct probe to 00:11:5c:d4:95:30 (try 3/3)
[23908.203739] wlan0: authentication with 00:11:5c:d4:95:30 timed out
[23913.594783] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23917.404374] wlan0: authenticate with 00:03:52:df:8d:70
[23917.413220] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23917.413510] wlan0: direct probe to 00:03:52:df:8d:70 (try 1/3)
[23917.615783] wlan0: direct probe to 00:03:52:df:8d:70 (try 2/3)
[23917.818738] wlan0: direct probe to 00:03:52:df:8d:70 (try 3/3)
[23918.021699] wlan0: authentication with 00:03:52:df:8d:70 timed out
[23923.408145] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23927.225747] wlan0: authenticate with 00:11:5c:d4:95:30
[23927.234501] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23927.234778] wlan0: direct probe to 00:11:5c:d4:95:30 (try 1/3)
[23927.436997] wlan0: direct probe to 00:11:5c:d4:95:30 (try 2/3)
[23927.640153] wlan0: direct probe to 00:11:5c:d4:95:30 (try 3/3)
[23927.843050] wlan0: authentication with 00:11:5c:d4:95:30 timed out
[23933.232110] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23937.047815] wlan0: authenticate with 00:11:5c:d4:95:30
[23937.055950] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23937.056235] wlan0: direct probe to 00:11:5c:d4:95:30 (try 1/3)
[23937.258393] wlan0: direct probe to 00:11:5c:d4:95:30 (try 2/3)
[23937.461459] wlan0: direct probe to 00:11:5c:d4:95:30 (try 3/3)
[23937.664530] wlan0: authentication with 00:11:5c:d4:95:30 timed out
[23943.053602] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23946.861550] wlan0: authenticate with 00:03:52:df:6f:10
[23946.870572] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23946.870849] wlan0: direct probe to 00:03:52:df:6f:10 (try 1/3)
[23947.073069] wlan0: direct probe to 00:03:52:df:6f:10 (try 2/3)
[23947.276165] wlan0: direct probe to 00:03:52:df:6f:10 (try 3/3)
[23947.479229] wlan0: authentication with 00:03:52:df:6f:10 timed out
[23952.868273] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23956.676434] wlan0: authenticate with 00:11:5c:d4:95:30
[23956.685263] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23956.685542] wlan0: direct probe to 00:11:5c:d4:95:30 (try 1/3)
[23956.887817] wlan0: direct probe to 00:11:5c:d4:95:30 (try 2/3)
[23957.090827] wlan0: direct probe to 00:11:5c:d4:95:30 (try 3/3)
[23957.293914] wlan0: authentication with 00:11:5c:d4:95:30 timed out
[23962.680150] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23966.492493] wlan0: authenticate with 00:03:52:df:6f:10
[23966.500093] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23966.500375] wlan0: direct probe to 00:03:52:df:6f:10 (try 1/3)
[23966.702505] wlan0: direct probe to 00:03:52:df:6f:10 (try 2/3)
[23966.905554] wlan0: direct probe to 00:03:52:df:6f:10 (try 3/3)
[23967.108621] wlan0: authentication with 00:03:52:df:6f:10 timed out
[23972.494878] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23976.309609] wlan0: authenticate with 00:03:52:df:69:a0
[23976.317965] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23976.320044] wlan0: direct probe to 00:03:52:df:69:a0 (try 1/3)
[23976.520595] wlan0: direct probe to 00:03:52:df:69:a0 (try 2/3)
[23976.723533] wlan0: direct probe to 00:03:52:df:69:a0 (try 3/3)
[23976.926581] wlan0: authentication with 00:03:52:df:69:a0 timed out
[23982.316295] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23986.131384] wlan0: authenticate with 00:0f:7d:a3:91:f1
[23986.139411] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23986.151914] wlan0: direct probe to 00:0f:7d:a3:91:f1 (try 1/3)
[23986.351887] wlan0: direct probe to 00:0f:7d:a3:91:f1 (try 2/3)
[23986.554951] wlan0: direct probe to 00:0f:7d:a3:91:f1 (try 3/3)
[23986.757955] wlan0: authentication with 00:0f:7d:a3:91:f1 timed out
[23986.917746] ------------[ cut here ]------------
[23986.917790] WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:7998 brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]()
[23986.917796] Hardware name: MacBookAir4,2
[23986.917800] Modules linked in: tun cpufreq_ondemand snd_hda_codec_hdmi snd_hda_codec_cirrus ext4 jbd2 mbcache arc4 brcmsmac cordic brcmutil mac80211 cfg80211 joydev iTCO_wdt iTCO_vendor_support i915 uvcvideo acpi_cpufreq intel_agp intel_gtt videobuf2_vmalloc drm_kms_helper videobuf2_memops drm videobuf2_core snd_hda_intel snd_hda_codec applesmc i2c_algo_bit videodev mperf input_polldev coretemp microcode btusb pcspkr i2c_i801 bluetooth rfkill media crc16 bcm5974 lpc_ich evdev snd_hwdep bcma i2c_core mei freq_table battery video ac button apple_bl processor snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd soundcore kvm_intel kvm nfs lockd sunrpc fscache ipv6 autofs4 jfs xts gf128mul dm_crypt dm_mod sd_mod pata_acpi ata_generic hid_generic usb_storage hid_apple usbhid hid aesni_intel
[23986.917993]  aes_x86_64 aes_generic uhci_hcd ablk_helper ghash_clmulni_intel cryptd crc32c_intel ata_piix libata scsi_mod ehci_hcd usbcore usb_common
[23986.918027] Pid: 8886, comm: kworker/u:0 Not tainted 3.6.0-rc7-00039-g6f0f9b6 #130
[23986.918031] Call Trace:
[23986.918048]  [<ffffffff81056faf>] warn_slowpath_common+0x7f/0xc0
[23986.918066]  [<ffffffffa06b5e44>] ? brcms_msleep+0x34/0x40 [brcmsmac]
[23986.918075]  [<ffffffff8105700a>] warn_slowpath_null+0x1a/0x20
[23986.918093]  [<ffffffffa06c2cf9>] brcms_c_wait_for_tx_completion+0x99/0xb0 [brcmsmac]
[23986.918107]  [<ffffffffa06b41eb>] brcms_ops_flush+0x3b/0x60 [brcmsmac]
[23986.918134]  [<ffffffffa06314c1>] __ieee80211_recalc_idle+0x241/0x3d0 [mac80211]
[23986.918156]  [<ffffffffa0631fb5>] ieee80211_recalc_idle+0x35/0x60 [mac80211]
[23986.918187]  [<ffffffffa06620b1>] ieee80211_sta_work+0x191/0xe30 [mac80211]
[23986.918197]  [<ffffffff81474615>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[23986.918220]  [<ffffffffa0631a09>] ieee80211_iface_work+0x2c9/0x360 [mac80211]
[23986.918230]  [<ffffffff810763cb>] process_one_work+0x19b/0x5d0
[23986.918238]  [<ffffffff81076365>] ? process_one_work+0x135/0x5d0
[23986.918259]  [<ffffffffa0631740>] ? ieee80211_teardown_sdata+0xf0/0xf0 [mac80211]
[23986.918269]  [<ffffffff81076bce>] worker_thread+0x15e/0x460
[23986.918277]  [<ffffffff81474615>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[23986.918287]  [<ffffffff810b5a0d>] ? trace_hardirqs_on+0xd/0x10
[23986.918296]  [<ffffffff81076a70>] ? rescuer_thread+0x230/0x230
[23986.918304]  [<ffffffff8107cd8e>] kthread+0xae/0xc0
[23986.918312]  [<ffffffff810b5a0d>] ? trace_hardirqs_on+0xd/0x10
[23986.918322]  [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
[23986.918330]  [<ffffffff81474b74>] ? retint_restore_args+0x13/0x13
[23986.918339]  [<ffffffff8107cce0>] ? __init_kthread_worker+0x70/0x70
[23986.918347]  [<ffffffff81476780>] ? gs_change+0x13/0x13
[23986.918352] ---[ end trace d99646669ce2bd7f ]---
[23986.934203] systemd-journald[205]: Compressed data object 802 -> 568
[23992.147456] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23996.002119] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[23996.002349] wlan0: authenticate with 00:0f:7d:a3:91:e1
[23996.013590] wlan0: direct probe to 00:0f:7d:a3:91:e1 (try 1/3)
[23996.219763] wlan0: direct probe to 00:0f:7d:a3:91:e1 (try 2/3)
[23996.427267] wlan0: direct probe to 00:0f:7d:a3:91:e1 (try 3/3)
[23996.632454] wlan0: authentication with 00:0f:7d:a3:91:e1 timed out
[24002.008604] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24005.923360] wlan0: authenticate with 00:0f:7d:a3:92:11
[24005.931537] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24005.943598] wlan0: direct probe to 00:0f:7d:a3:92:11 (try 1/3)
[24006.144301] wlan0: send auth to 00:0f:7d:a3:92:11 (try 2/3)
[24006.350645] wlan0: send auth to 00:0f:7d:a3:92:11 (try 3/3)
[24006.556995] wlan0: authentication with 00:0f:7d:a3:92:11 timed out
[24011.940919] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24015.761385] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24015.762299] wlan0: authenticate with 00:03:52:df:8d:70
[24015.774003] wlan0: direct probe to 00:03:52:df:8d:70 (try 1/3)
[24015.975739] wlan0: direct probe to 00:03:52:df:8d:70 (try 2/3)
[24016.178716] wlan0: direct probe to 00:03:52:df:8d:70 (try 3/3)
[24016.381836] wlan0: authentication with 00:03:52:df:8d:70 timed out
[24021.771434] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24025.583488] wlan0: authenticate with 2c:3f:38:59:1d:80
[24025.591240] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24025.591516] wlan0: direct probe to 2c:3f:38:59:1d:80 (try 1/3)
[24025.793761] wlan0: direct probe to 2c:3f:38:59:1d:80 (try 2/3)
[24025.996810] wlan0: direct probe to 2c:3f:38:59:1d:80 (try 3/3)
[24026.199752] wlan0: authentication with 2c:3f:38:59:1d:80 timed out
[24031.588928] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24035.398758] wlan0: authenticate with 00:0f:7d:a3:91:f1
[24035.405923] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24035.418437] wlan0: direct probe to 00:0f:7d:a3:91:f1 (try 1/3)
[24035.618489] wlan0: direct probe to 00:0f:7d:a3:91:f1 (try 2/3)
[24035.821425] wlan0: direct probe to 00:0f:7d:a3:91:f1 (try 3/3)
[24036.024465] wlan0: authentication with 00:0f:7d:a3:91:f1 timed out
[24041.415714] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24045.238663] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24045.239701] wlan0: authenticate with 2c:3f:38:59:1d:85
[24045.251423] wlan0: direct probe to 2c:3f:38:59:1d:85 (try 1/3)
[24045.453101] wlan0: direct probe to 2c:3f:38:59:1d:85 (try 2/3)
[24045.656135] wlan0: direct probe to 2c:3f:38:59:1d:85 (try 3/3)
[24045.859116] wlan0: authentication with 2c:3f:38:59:1d:85 timed out
[24051.248963] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24055.071863] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24061.061648] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24064.879943] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24070.869444] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24074.680087] wlan0: authenticate with f0:7d:68:8e:12:2a
[24074.688022] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24074.690136] wlan0: direct probe to f0:7d:68:8e:12:2a (try 1/3)
[24074.890639] wlan0: direct probe to f0:7d:68:8e:12:2a (try 2/3)
[24075.093561] wlan0: direct probe to f0:7d:68:8e:12:2a (try 3/3)
[24075.296622] wlan0: authentication with f0:7d:68:8e:12:2a timed out
[24080.681777] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24084.494150] wlan0: authenticate with 2c:3f:38:59:1d:85
[24084.502646] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24084.504756] wlan0: direct probe to 2c:3f:38:59:1d:85 (try 1/3)
[24084.705298] wlan0: direct probe to 2c:3f:38:59:1d:85 (try 2/3)
[24084.908246] wlan0: direct probe to 2c:3f:38:59:1d:85 (try 3/3)
[24085.111256] wlan0: authentication with 2c:3f:38:59:1d:85 timed out
[24090.500964] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24094.324140] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24099.312600] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24103.130410] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24108.115624] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24111.936568] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24116.923040] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24120.742918] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24125.728276] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24129.549153] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24134.533870] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24138.352195] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24143.335274] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24147.154967] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24152.143021] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24155.964584] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24160.949890] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24164.767611] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24169.754280] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24173.565556] wlan0: authenticate with 00:0c:85:88:b7:e5
[24173.573897] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24173.574176] wlan0: send auth to 00:0c:85:88:b7:e5 (try 1/3)
[24173.776449] wlan0: send auth to 00:0c:85:88:b7:e5 (try 2/3)
[24173.979433] wlan0: send auth to 00:0c:85:88:b7:e5 (try 3/3)
[24174.182462] wlan0: authentication with 00:0c:85:88:b7:e5 timed out
[24179.571487] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24183.380108] wlan0: authenticate with 00:0b:fd:81:f3:6b
[24183.388633] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24183.390747] wlan0: send auth to 00:0b:fd:81:f3:6b (try 1/3)
[24183.591200] wlan0: send auth to 00:0b:fd:81:f3:6b (try 2/3)
[24183.794203] wlan0: send auth to 00:0b:fd:81:f3:6b (try 3/3)
[24183.997185] wlan0: authentication with 00:0b:fd:81:f3:6b timed out
[24189.388134] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24193.196319] wlan0: authenticate with d4:a0:2a:9a:e7:9f
[24193.203273] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24193.215840] wlan0: direct probe to d4:a0:2a:9a:e7:9f (try 1/3)
[24193.415772] wlan0: direct probe to d4:a0:2a:9a:e7:9f (try 2/3)
[24193.618841] wlan0: send auth to d4:a0:2a:9a:e7:9f (try 3/3)
[24193.619735] wlan0: authenticated
[24193.622190] wlan0: associate with d4:a0:2a:9a:e7:9f (try 1/3)
[24193.624202] wlan0: RX AssocResp from d4:a0:2a:9a:e7:9f (capab=0x11 status=0 aid=2)
[24193.624724] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[24193.624736] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[24193.624743] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[24193.624766] wlan0: associated
[24200.081938] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[24257.742442] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[24257.742467] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[24257.742473] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[24257.769191] cfg80211: Calling CRDA to update world regulatory domain
[24257.869538] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24261.754618] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24261.756755] wlan0: authenticate with d4:a0:2a:9a:c1:ef
[24261.758918] wlan0: direct probe to d4:a0:2a:9a:c1:ef (try 1/3)
[24261.958958] wlan0: direct probe to d4:a0:2a:9a:c1:ef (try 2/3)
[24262.161946] wlan0: send auth to d4:a0:2a:9a:c1:ef (try 3/3)
[24262.162752] wlan0: authenticated
[24262.165285] wlan0: associate with d4:a0:2a:9a:c1:ef (try 1/3)
[24262.167273] wlan0: RX AssocResp from d4:a0:2a:9a:c1:ef (capab=0x11 status=0 aid=29)
[24262.167794] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[24262.167807] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[24262.167813] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[24262.167833] wlan0: associated
[24267.935605] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[24415.489954] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[24415.489978] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[24415.489985] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[24415.506647] cfg80211: Calling CRDA for country: CH
[24415.607047] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24419.495347] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24419.496557] wlan0: authenticate with d4:a0:2a:98:ab:7f
[24419.498696] wlan0: direct probe to d4:a0:2a:98:ab:7f (try 1/3)
[24419.699720] wlan0: send auth to d4:a0:2a:98:ab:7f (try 2/3)
[24419.700569] wlan0: authenticated
[24419.703123] wlan0: associate with d4:a0:2a:98:ab:7f (try 1/3)
[24419.705026] wlan0: RX AssocResp from d4:a0:2a:98:ab:7f (capab=0x11 status=0 aid=13)
[24419.705597] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[24419.705617] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[24419.705627] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[24419.705656] wlan0: associated
[24424.801153] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[24427.451302] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[24427.451329] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[24427.451335] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[24427.467795] cfg80211: Calling CRDA to update world regulatory domain
[24427.568019] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24431.456667] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[24431.458455] wlan0: authenticate with d4:a0:2a:98:a6:af
[24431.458726] wlan0: direct probe to d4:a0:2a:98:a6:af (try 1/3)
[24431.661159] wlan0: send auth to d4:a0:2a:98:a6:af (try 2/3)
[24431.662038] wlan0: authenticated
[24431.664492] wlan0: associate with d4:a0:2a:98:a6:af (try 1/3)
[24431.666409] wlan0: RX AssocResp from d4:a0:2a:98:a6:af (capab=0x11 status=0 aid=44)
[24431.666943] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[24431.666955] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[24431.666961] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[24431.666982] wlan0: associated
[24437.068307] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[25821.351359] EXT4-fs (sda4): re-mounted. Opts: commit=0
[25822.015835] PM: Syncing filesystems ... done.
[25822.028488] PM: Preparing system for mem sleep
[25824.790571] Freezing user space processes ... (elapsed 0.01 seconds) done.
[25824.803115] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[25824.816486] PM: Entering mem sleep
[25824.816565] Suspending console(s) (use no_console_suspend to debug)
[25824.905528] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[25824.907194] sd 0:0:0:0: [sda] Stopping disk
[25824.908843] brcmsmac: brcms_suspend ok
[25826.939712] PM: suspend of devices complete after 2046.177 msecs
[25826.940135] PM: late suspend of devices complete after 0.421 msecs
[25826.953481] ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
[25826.966527] ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
[25826.993034] PM: noirq suspend of devices complete after 52.979 msecs
[25826.993305] ACPI: Preparing to enter system sleep state S3
[25827.020224] PM: Saving platform NVS memory
[25827.021363] Disabling non-boot CPUs ...
[25827.025173] smpboot: CPU 1 is now offline
[25827.030270] smpboot: CPU 2 is now offline
[25827.033284] smpboot: CPU 3 is now offline
[25827.033286] SMP alternatives: lockdep: fixing up alternatives
[25827.034173] Extended CMOS year: 2000
[25827.036254] ACPI: Low-level resume complete
[25827.036396] PM: Restoring platform NVS memory
[25827.036778] Extended CMOS year: 2000
[25827.036937] Enabling non-boot CPUs ...
[25827.044035] SMP alternatives: lockdep: fixing up alternatives
[25827.044043] smpboot: Booting Node 0 Processor 1 APIC 0x2
[25827.073520] CPU1 is up
[25827.089354] SMP alternatives: lockdep: fixing up alternatives
[25827.089357] smpboot: Booting Node 0 Processor 2 APIC 0x1
[25827.115280] CPU2 is up
[25827.123849] SMP alternatives: lockdep: fixing up alternatives
[25827.123852] smpboot: Booting Node 0 Processor 3 APIC 0x3
[25827.153917] CPU3 is up
[25827.159190] ACPI: Waking up from system sleep state S3
[25827.704578] ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
[25827.718804] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[25827.731189] ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
[25827.758057] PM: noirq resume of devices complete after 92.915 msecs
[25827.758337] PM: early resume of devices complete after 0.243 msecs
[25827.758531] i915 0000:00:02.0: setting latency timer to 64
[25827.758719] mei 0000:00:16.0: irq 45 for MSI/MSI-X
[25827.758843] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[25827.758861] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[25827.758876] usb usb3: root hub lost power or was reset
[25827.759040] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[25827.759275] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[25827.759307] usb usb4: root hub lost power or was reset
[25827.759335] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[25827.759347] ata_piix 0000:00:1f.2: setting latency timer to 64
[25827.761470] brcmsmac: brcms_resume ok
[25827.761954] mei 0000:00:16.0: wd: failed to find the client
[25827.804172] [drm:__gen6_gt_force_wake_get] *ERROR* Force wake wait timed out
[25827.806580] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[25827.835861] bcm5974: bad trackpad package, length: 8
[25827.853844] bcm5974: bad trackpad package, length: 8
[25827.854841] bcm5974: bad trackpad package, length: 8
[25827.855833] bcm5974: bad trackpad package, length: 8
[25827.856870] bcm5974: bad trackpad package, length: 8
[25827.858834] bcm5974: bad trackpad package, length: 8
[25827.859826] bcm5974: bad trackpad package, length: 8
[25827.860833] bcm5974: bad trackpad package, length: 8
[25828.796033] ata2.00: failed to resume link (SControl 0)
[25829.108939] ata1.01: failed to resume link (SControl 0)
[25829.262083] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[25829.262095] ata1.01: SATA link down (SStatus 0 SControl 0)
[25829.271788] ata1.00: ACPI cmd ef/03:46:00:00:00:a0 (SET FEATURES) filtered out
[25829.282147] ata1.00: configured for UDMA/133
[25829.316468] sd 0:0:0:0: [sda] Starting disk
[25829.817842] ata2.01: failed to resume link (SControl 0)
[25829.829340] ata2.00: SATA link down (SStatus 4 SControl 0)
[25829.829362] ata2.01: SATA link down (SStatus 0 SControl 0)
[25829.846259] ieee80211 phy0: brcms_ops_config: change monitor mode: false
[25829.846261] ieee80211 phy0: brcms_ops_config: change power-save mode: false (implement)
[25829.847317] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[25829.847324] ieee80211 phy0: changing basic rates failed: -22
[25829.847326] ieee80211 phy0: brcms_ops_bss_info_changed: cqm change: threshold 0, hys 0  (implement)
[25829.847327] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[25829.847328] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[25829.850062] PM: resume of devices complete after 2094.981 msecs
[25829.862104] PM: Finishing wakeup.
[25829.862105] Restarting tasks ... done.
[25829.914358] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[25829.914863] video LNXVIDEO:00: Restoring backlight state
[25829.916313] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[25829.917335] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[25829.942452] cfg80211: Calling CRDA for country: CH
[25830.042723] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25830.641264] hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
[25832.052075] EXT4-fs (sda4): re-mounted. Opts: commit=0
[25833.923258] wlan0: authenticate with 0c:b0:5d:9c:37:12
[25833.923336] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25833.934996] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[25833.937099] wlan0: authenticated
[25833.938044] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[25833.944000] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[25833.944546] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[25833.944558] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[25833.944564] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[25833.944809] wlan0: associated
[25837.048690] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[25837.079998] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[25837.080023] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[25837.080029] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[25837.081172] cfg80211: Calling CRDA to update world regulatory domain
[25837.181688] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25838.697625] usb 2-1.2: new high-speed USB device number 4 using ehci_hcd
[25838.813071] usb-storage 2-1.2:1.0: Quirks match for vid 1058 pid 0704: 8000
[25838.813369] scsi3 : usb-storage 2-1.2:1.0
[25839.825714] scsi 3:0:0:0: Direct-Access     WD       5000BMV External 1.75 PQ: 0 ANSI: 4
[25839.830628] sd 3:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[25839.831432] sd 3:0:0:0: [sdc] Write Protect is off
[25839.831437] sd 3:0:0:0: [sdc] Mode Sense: 23 00 00 00
[25839.832262] sd 3:0:0:0: [sdc] No Caching mode page present
[25839.832266] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[25839.835974] sd 3:0:0:0: [sdc] No Caching mode page present
[25839.835978] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[25839.867731]  sdc: unknown partition table
[25839.870833] sd 3:0:0:0: [sdc] No Caching mode page present
[25839.870837] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[25839.870844] sd 3:0:0:0: [sdc] Attached SCSI disk
[25841.054776] wlan0: authenticate with 0c:b0:5d:9c:37:12
[25841.063671] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25841.063758] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[25841.066764] wlan0: authenticated
[25841.070179] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[25841.073971] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[25841.074535] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[25841.074538] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[25841.074540] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[25841.074670] wlan0: associated
[25844.178598] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[25844.208684] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[25844.208692] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[25844.208694] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[25844.209365] cfg80211: Calling CRDA to update world regulatory domain
[25844.709220] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25848.642632] wlan0: authenticate with c8:6c:87:a9:df:a9
[25848.651864] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25848.653728] wlan0: send auth to c8:6c:87:a9:df:a9 (try 1/3)
[25848.858034] wlan0: send auth to c8:6c:87:a9:df:a9 (try 2/3)
[25849.057743] wlan0: send auth to c8:6c:87:a9:df:a9 (try 3/3)
[25849.260866] wlan0: authentication with c8:6c:87:a9:df:a9 timed out
[25854.646070] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg5-during-backup

[25858.593243] wlan0: authenticate with c8:6c:87:a9:df:a9
[25858.600106] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25858.600387] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 1/3)
[25858.805985] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 2/3)
[25859.008944] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 3/3)
[25859.211973] wlan0: authentication with c8:6c:87:a9:df:a9 timed out
[25864.593349] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25868.470983] wlan0: authenticate with 0c:b0:5d:9c:37:12
[25868.478175] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25868.480302] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[25868.482301] wlan0: authenticated
[25868.484186] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[25868.489268] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[25868.489823] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[25868.489835] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[25868.489841] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[25868.490010] wlan0: associated
[25871.592674] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[25871.609554] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[25871.609580] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[25871.609587] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[25871.610630] cfg80211: Calling CRDA for country: CH
[25871.711101] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25875.584853] wlan0: authenticate with 0c:b0:5d:9c:37:12
[25875.593585] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25875.593868] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[25875.597018] wlan0: authenticated
[25875.599813] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[25875.603379] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[25875.603946] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[25875.603960] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[25875.603966] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[25875.604129] wlan0: associated
[25878.706525] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[25878.728467] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[25878.728493] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[25878.728500] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[25878.729546] cfg80211: Calling CRDA to update world regulatory domain
[25879.229616] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25883.103213] wlan0: authenticate with c8:6c:87:a9:df:a9
[25883.111815] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25883.113938] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 1/3)
[25883.314522] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 2/3)
[25883.517388] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 3/3)
[25883.720469] wlan0: authentication with c8:6c:87:a9:df:a9 timed out
[25889.105425] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25892.980389] wlan0: authenticate with 0c:b0:5d:9c:37:12
[25892.989527] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25892.991592] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[25892.993588] wlan0: authenticated
[25892.995919] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[25893.198971] wlan0: associate with 0c:b0:5d:9c:37:12 (try 2/3)
[25893.276040] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[25893.276543] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[25893.276553] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[25893.276557] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[25893.276578] wlan0: associated
[25896.380610] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[25896.407488] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[25896.407513] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[25896.407519] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[25896.408285] cfg80211: Calling CRDA to update world regulatory domain
[25896.508595] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25900.392036] wlan0: authenticate with 0c:b0:5d:9c:37:12
[25900.401337] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25900.401572] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[25900.405274] wlan0: authenticated
[25900.407809] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[25900.449541] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[25900.450050] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[25900.450062] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[25900.450069] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[25900.450226] wlan0: associated
[25903.553138] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[25903.592817] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[25903.592826] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[25903.592828] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[25903.593812] cfg80211: Calling CRDA for country: CH
[25904.093346] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25907.967424] wlan0: authenticate with c8:6c:87:a9:df:a9
[25907.976216] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25907.978205] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 1/3)
[25908.178923] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 2/3)
[25908.381939] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 3/3)
[25908.585088] wlan0: authentication with c8:6c:87:a9:df:a9 timed out
[25913.969673] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25917.844642] wlan0: authenticate with c8:6c:87:a9:df:a9
[25917.854989] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25917.855147] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 1/3)
[25918.056855] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 2/3)
[25918.259902] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 3/3)
[25918.462902] wlan0: authentication with c8:6c:87:a9:df:a9 timed out
[25923.848072] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25927.735173] wlan0: authenticate with 0c:b0:5d:9c:37:12
[25927.742427] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25927.744476] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[25927.746679] wlan0: authenticated
[25927.748518] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[25927.753670] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[25927.754204] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[25927.754217] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[25927.754223] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[25927.754389] wlan0: associated
[25930.859314] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[25930.890477] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[25930.890502] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[25930.890508] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[25930.891545] cfg80211: Calling CRDA to update world regulatory domain
[25930.991815] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25934.871490] wlan0: authenticate with 0c:b0:5d:9c:37:12
[25934.881372] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25934.881552] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[25934.884520] wlan0: authenticated
[25934.887344] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[25935.090404] wlan0: associate with 0c:b0:5d:9c:37:12 (try 2/3)
[25935.142116] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[25935.142702] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[25935.142709] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[25935.142712] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[25935.142892] wlan0: associated
[25938.247515] wlan0: deauthenticated from 0c:b0:5d:9c:37:12 (Reason: 2)
[25938.275646] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[25938.275668] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 0 (implement)
[25938.275675] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[25938.276676] cfg80211: Calling CRDA for country: CH
[25938.776596] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25942.658244] wlan0: authenticate with c8:6c:87:a9:df:a9
[25942.665888] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25942.667960] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 1/3)
[25942.868283] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 2/3)
[25943.071285] wlan0: direct probe to c8:6c:87:a9:df:a9 (try 3/3)
[25943.274214] wlan0: authentication with c8:6c:87:a9:df:a9 timed out
[25948.660862] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25952.537708] wlan0: authenticate with 0c:b0:5d:9c:37:12
[25952.546830] ieee80211 phy0: FIF_BCN_PRBRESP_PROMISC
[25952.548702] wlan0: send auth to 0c:b0:5d:9c:37:12 (try 1/3)
[25952.550631] wlan0: authenticated
[25952.553115] wlan0: associate with 0c:b0:5d:9c:37:12 (try 1/3)
[25952.557908] wlan0: RX AssocResp from 0c:b0:5d:9c:37:12 (capab=0x411 status=0 aid=1)
[25952.558530] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[25952.558534] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[25952.558536] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[25952.558606] wlan0: associated
[25958.289477] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
[26087.708989] fuse init (API version 7.20)
[26482.550162] kmemleak: 15 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[27099.639319] CPU3: Core temperature above threshold, cpu clock throttled (total events = 9037)
[27099.639320] CPU1: Core temperature above threshold, cpu clock throttled (total events = 9037)
[27099.639323] CPU1: Package temperature above threshold, cpu clock throttled (total events = 9621)
[27099.639335] CPU3: Package temperature above threshold, cpu clock throttled (total events = 9621)
[27099.639347] CPU2: Package temperature above threshold, cpu clock throttled (total events = 9620)
[27099.639349] CPU0: Package temperature above threshold, cpu clock throttled (total events = 9621)
[27099.640298] CPU1: Core temperature/speed normal
[27099.640301] CPU1: Package temperature/speed normal
[27099.640305] CPU3: Core temperature/speed normal
[27099.640315] CPU3: Package temperature/speed normal
[27099.640319] CPU2: Package temperature/speed normal
[27099.640319] CPU0: Package temperature/speed normal
[27257.971632] mce: [Hardware Error]: Machine check events logged
[27559.547551] CPU1: Core temperature above threshold, cpu clock throttled (total events = 10326)
[27559.547552] CPU3: Core temperature above threshold, cpu clock throttled (total events = 10326)
[27559.547555] CPU3: Package temperature above threshold, cpu clock throttled (total events = 10991)
[27559.547567] CPU1: Package temperature above threshold, cpu clock throttled (total events = 10991)
[27559.547580] CPU2: Package temperature above threshold, cpu clock throttled (total events = 10990)
[27559.547582] CPU0: Package temperature above threshold, cpu clock throttled (total events = 10991)
[27559.548589] CPU1: Core temperature/speed normal
[27559.548590] CPU3: Core temperature/speed normal
[27559.548592] CPU3: Package temperature/speed normal
[27559.548594] CPU0: Package temperature/speed normal
[27559.548595] CPU2: Package temperature/speed normal
[27559.548598] CPU1: Package temperature/speed normal
[27624.370494] mce: [Hardware Error]: Machine check events logged
[28361.660309] CPU1: Core temperature above threshold, cpu clock throttled (total events = 17032)
[28361.660312] CPU3: Core temperature above threshold, cpu clock throttled (total events = 17032)
[28361.660315] CPU3: Package temperature above threshold, cpu clock throttled (total events = 18957)
[28361.660318] CPU0: Package temperature above threshold, cpu clock throttled (total events = 18957)
[28361.660323] CPU1: Package temperature above threshold, cpu clock throttled (total events = 18957)
[28361.660446] CPU2: Package temperature above threshold, cpu clock throttled (total events = 18956)
[28361.663313] CPU0: Package temperature/speed normal
[28361.663315] CPU3: Core temperature/speed normal
[28361.663316] CPU1: Core temperature/speed normal
[28361.663319] CPU1: Package temperature/speed normal
[28361.663320] CPU3: Package temperature/speed normal
[28361.663329] CPU2: Package temperature/speed normal
[28373.203273] mce: [Hardware Error]: Machine check events logged
[29663.404134] CPU3: Core temperature above threshold, cpu clock throttled (total events = 18719)
[29663.404137] CPU0: Package temperature above threshold, cpu clock throttled (total events = 20699)
[29663.404138] CPU2: Package temperature above threshold, cpu clock throttled (total events = 20698)
[29663.404146] CPU3: Package temperature above threshold, cpu clock throttled (total events = 20699)
[29663.404195] CPU1: Core temperature above threshold, cpu clock throttled (total events = 18719)
[29663.404199] CPU1: Package temperature above threshold, cpu clock throttled (total events = 20699)
[29663.405161] CPU3: Core temperature/speed normal
[29663.405163] CPU2: Package temperature/speed normal
[29663.405164] CPU0: Package temperature/speed normal
[29663.405169] CPU3: Package temperature/speed normal
[29663.405312] CPU1: Core temperature/speed normal
[29663.405316] CPU1: Package temperature/speed normal
[29721.102271] mce: [Hardware Error]: Machine check events logged
[30314.512184] CPU3: Core temperature above threshold, cpu clock throttled (total events = 19267)
[30314.512186] CPU1: Core temperature above threshold, cpu clock throttled (total events = 19267)
[30314.512190] CPU1: Package temperature above threshold, cpu clock throttled (total events = 21673)
[30314.512193] CPU0: Package temperature above threshold, cpu clock throttled (total events = 21673)
[30314.512194] CPU2: Package temperature above threshold, cpu clock throttled (total events = 21672)
[30314.512198] CPU3: Package temperature above threshold, cpu clock throttled (total events = 21673)
[30314.513194] CPU3: Core temperature/speed normal
[30314.513195] CPU1: Core temperature/speed normal
[30314.513197] CPU0: Package temperature/speed normal
[30314.513198] CPU1: Package temperature/speed normal
[30314.513200] CPU2: Package temperature/speed normal
[30314.513204] CPU3: Package temperature/speed normal
[30320.181808] mce: [Hardware Error]: Machine check events logged
[31046.750271] CPU3: Core temperature above threshold, cpu clock throttled (total events = 22965)
[31046.750274] CPU2: Package temperature above threshold, cpu clock throttled (total events = 25462)
[31046.750282] CPU3: Package temperature above threshold, cpu clock throttled (total events = 25463)
[31046.750332] CPU0: Package temperature above threshold, cpu clock throttled (total events = 25463)
[31046.750338] CPU1: Core temperature above threshold, cpu clock throttled (total events = 22965)
[31046.750342] CPU1: Package temperature above threshold, cpu clock throttled (total events = 25463)
[31046.751294] CPU3: Core temperature/speed normal
[31046.751296] CPU0: Package temperature/speed normal
[31046.751297] CPU2: Package temperature/speed normal
[31046.751303] CPU3: Package temperature/speed normal
[31046.751399] CPU1: Core temperature/speed normal
[31046.751403] CPU1: Package temperature/speed normal
[31069.001275] mce: [Hardware Error]: Machine check events logged
[31713.683584] CPU1: Core temperature above threshold, cpu clock throttled (total events = 24979)
[31713.683587] CPU0: Package temperature above threshold, cpu clock throttled (total events = 28500)
[31713.683588] CPU2: Package temperature above threshold, cpu clock throttled (total events = 28500)
[31713.683590] CPU3: Core temperature above threshold, cpu clock throttled (total events = 24979)
[31713.683593] CPU3: Package temperature above threshold, cpu clock throttled (total events = 28501)
[31713.683599] CPU1: Package temperature above threshold, cpu clock throttled (total events = 28501)
[31713.684588] CPU1: Core temperature/speed normal
[31713.684590] CPU0: Package temperature/speed normal
[31713.684595] CPU1: Package temperature/speed normal
[31713.684631] CPU3: Core temperature/speed normal
[31713.684635] CPU3: Package temperature/speed normal
[31713.684663] CPU2: Package temperature/speed normal

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg6


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg7-during-backup

[33104.184527] CPU1: Core temperature above threshold, cpu clock throttled (total events = 26854)
[33104.184530] CPU0: Package temperature above threshold, cpu clock throttled (total events = 30825)
[33104.184532] CPU2: Package temperature above threshold, cpu clock throttled (total events = 30825)
[33104.184540] CPU1: Package temperature above threshold, cpu clock throttled (total events = 30827)
[33104.184684] CPU3: Core temperature above threshold, cpu clock throttled (total events = 26854)
[33104.184688] CPU3: Package temperature above threshold, cpu clock throttled (total events = 30827)
[33104.185498] CPU1: Core temperature/speed normal
[33104.185500] CPU2: Package temperature/speed normal
[33104.185502] CPU0: Package temperature/speed normal
[33104.185507] CPU1: Package temperature/speed normal
[33104.185680] CPU3: Core temperature/speed normal
[33104.185683] CPU3: Package temperature/speed normal
[33828.139567] CPU1: Core temperature above threshold, cpu clock throttled (total events = 29408)
[33828.139570] CPU0: Package temperature above threshold, cpu clock throttled (total events = 33487)
[33828.139571] CPU3: Core temperature above threshold, cpu clock throttled (total events = 29408)
[33828.139575] CPU3: Package temperature above threshold, cpu clock throttled (total events = 33489)
[33828.139580] CPU1: Package temperature above threshold, cpu clock throttled (total events = 33489)
[33828.139747] CPU2: Package temperature above threshold, cpu clock throttled (total events = 33487)
[33828.140571] CPU3: Core temperature/speed normal
[33828.140572] CPU1: Core temperature/speed normal
[33828.140574] CPU0: Package temperature/speed normal
[33828.140576] CPU2: Package temperature/speed normal
[33828.140577] CPU1: Package temperature/speed normal
[33828.140581] CPU3: Package temperature/speed normal
[33909.570017] systemd-journald[205]: Data hash table of /run/log/journal/430f5d56a9288edc7eca1b05000004e3/system.journal has a fill level at 75.0 (32944 of 43925 items, 16019456 file size, 486 bytes per hash table item), suggesting rotation.
[33909.570039] systemd-journald[205]: Journal header limits reached or header out-of-date, rotating.
[33909.570057] systemd-journald[205]: Rotating...
[33909.570834] systemd-journald[205]: Reserving 43925 entries in hash table.
[33909.578453] systemd-journald[205]: Vacuuming...
[34127.762691] CPU1: Core temperature above threshold, cpu clock throttled (total events = 33952)
[34127.762694] CPU2: Package temperature above threshold, cpu clock throttled (total events = 38716)
[34127.762696] CPU3: Core temperature above threshold, cpu clock throttled (total events = 33952)
[34127.762698] CPU3: Package temperature above threshold, cpu clock throttled (total events = 38718)
[34127.762700] CPU0: Package temperature above threshold, cpu clock throttled (total events = 38716)
[34127.762707] CPU1: Package temperature above threshold, cpu clock throttled (total events = 38718)
[34127.763664] CPU1: Core temperature/speed normal
[34127.763666] CPU3: Core temperature/speed normal
[34127.763668] CPU2: Package temperature/speed normal
[34127.763669] CPU0: Package temperature/speed normal
[34127.763670] CPU3: Package temperature/speed normal
[34127.763676] CPU1: Package temperature/speed normal
[34429.311749] CPU1: Core temperature above threshold, cpu clock throttled (total events = 35522)
[34429.311751] CPU3: Core temperature above threshold, cpu clock throttled (total events = 35522)
[34429.311753] CPU3: Package temperature above threshold, cpu clock throttled (total events = 40454)
[34429.311765] CPU1: Package temperature above threshold, cpu clock throttled (total events = 40454)
[34429.311779] CPU2: Package temperature above threshold, cpu clock throttled (total events = 40452)
[34429.311781] CPU0: Package temperature above threshold, cpu clock throttled (total events = 40453)
[34429.314783] CPU3: Core temperature/speed normal
[34429.314785] CPU2: Package temperature/speed normal
[34429.314786] CPU0: Package temperature/speed normal
[34429.314788] CPU1: Core temperature/speed normal
[34429.314791] CPU1: Package temperature/speed normal
[34429.314796] CPU3: Package temperature/speed normal
[34578.806661] systemd-journald[205]: Data hash table of /run/log/journal/430f5d56a9288edc7eca1b05000004e3/system.journal has a fill level at 75.0 (32944 of 43925 items, 16887808 file size, 512 bytes per hash table item), suggesting rotation.
[34578.806679] systemd-journald[205]: Journal header limits reached or header out-of-date, rotating.
[34578.806693] systemd-journald[205]: Rotating...
[34578.807501] systemd-journald[205]: Reserving 43925 entries in hash table.
[34578.811883] systemd-journald[205]: Vacuuming...
[34729.100593] CPU1: Core temperature above threshold, cpu clock throttled (total events = 36893)
[34729.100595] CPU0: Package temperature above threshold, cpu clock throttled (total events = 41829)
[34729.100597] CPU2: Package temperature above threshold, cpu clock throttled (total events = 41828)
[34729.100605] CPU1: Package temperature above threshold, cpu clock throttled (total events = 41830)
[34729.100742] CPU3: Core temperature above threshold, cpu clock throttled (total events = 36893)
[34729.100747] CPU3: Package temperature above threshold, cpu clock throttled (total events = 41830)
[34729.101627] CPU1: Core temperature/speed normal
[34729.101629] CPU0: Package temperature/speed normal
[34729.101630] CPU2: Package temperature/speed normal
[34729.101636] CPU1: Package temperature/speed normal
[34729.101796] CPU3: Core temperature/speed normal
[34729.101800] CPU3: Package temperature/speed normal

[35028.238252] =========================================================
[35028.238254] [ INFO: possible irq lock inversion dependency detected ]
[35028.238257] 3.6.0-rc7-00039-g6f0f9b6 #130 Tainted: G        W   
[35028.238258] ---------------------------------------------------------
[35028.238260] kswapd0/36 just changed the state of lock:
[35028.238263]  (&jfs_ip->rdwrlock#2){++++-.}, at: [<ffffffffa01b1897>] jfs_get_block+0x57/0x220 [jfs]
[35028.238277] but this lock took another, RECLAIM_FS-unsafe lock in the past:
[35028.238278]  (&jfs_ip->commit_mutex){+.+.+.}

and interrupts could create inverse lock ordering between them.

[35028.238282] 
other info that might help us debug this:
[35028.238284]  Possible interrupt unsafe locking scenario:

[35028.238286]        CPU0                    CPU1
[35028.238287]        ----                    ----
[35028.238288]   lock(&jfs_ip->commit_mutex);
[35028.238291]                                local_irq_disable();
[35028.238293]                                lock(&jfs_ip->rdwrlock#2);
[35028.238296]                                lock(&jfs_ip->commit_mutex);
[35028.238299]   <Interrupt>
[35028.238300]     lock(&jfs_ip->rdwrlock#2);
[35028.238303] 
 *** DEADLOCK ***

[35028.238306] no locks held by kswapd0/36.
[35028.238307] 
the shortest dependencies between 2nd lock and 1st lock:
[35028.238322]  -> (&jfs_ip->commit_mutex){+.+.+.} ops: 26664348 {
[35028.238326]     HARDIRQ-ON-W at:
[35028.238327]                       [<ffffffff810b3507>] __lock_acquire+0x737/0x1b70
[35028.238333]                       [<ffffffff810b4ef6>] lock_acquire+0x96/0x150
[35028.238335]                       [<ffffffff81471710>] mutex_lock_nested+0x50/0x3c0
[35028.238340]                       [<ffffffffa01b2719>] jfs_mkdir+0xa9/0x350 [jfs]
[35028.238344]                       [<ffffffff81193d3c>] vfs_mkdir+0xbc/0x130
[35028.238348]                       [<ffffffff81197863>] sys_mkdirat+0xa3/0xb0
[35028.238350]                       [<ffffffff81197889>] sys_mkdir+0x19/0x20
[35028.238352]                       [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
[35028.238355]     SOFTIRQ-ON-W at:
[35028.238357]                       [<ffffffff810b3354>] __lock_acquire+0x584/0x1b70
[35028.238359]                       [<ffffffff810b4ef6>] lock_acquire+0x96/0x150
[35028.238361]                       [<ffffffff81471710>] mutex_lock_nested+0x50/0x3c0
[35028.238364]                       [<ffffffffa01b2719>] jfs_mkdir+0xa9/0x350 [jfs]
[35028.238368]                       [<ffffffff81193d3c>] vfs_mkdir+0xbc/0x130
[35028.238370]                       [<ffffffff81197863>] sys_mkdirat+0xa3/0xb0
[35028.238372]                       [<ffffffff81197889>] sys_mkdir+0x19/0x20
[35028.238374]                       [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
[35028.238376]     RECLAIM_FS-ON-W at:
[35028.238378]                          [<ffffffff810b57ec>] mark_held_locks+0x8c/0x110
[35028.238380]                          [<ffffffff810b5f29>] lockdep_trace_alloc+0x79/0xd0
[35028.238383]                          [<ffffffff8116f851>] kmem_cache_alloc_trace+0x31/0x190
[35028.238386]                          [<ffffffffa01c56a3>] dtSplitUp+0xc63/0x1790 [jfs]
[35028.238391]                          [<ffffffffa01c6c65>] dtInsert+0xd5/0x240 [jfs]
[35028.238395]                          [<ffffffffa01b3eec>] jfs_rename+0x74c/0x830 [jfs]
[35028.238399]                          [<ffffffff8119589c>] vfs_rename+0x13c/0x4f0
[35028.238401]                          [<ffffffff81197df6>] sys_renameat+0x1f6/0x230
[35028.238404]                          [<ffffffff81197e4b>] sys_rename+0x1b/0x20
[35028.238405]                          [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
[35028.238408]     INITIAL USE at:
[35028.238409]                      [<ffffffff810b30ae>] __lock_acquire+0x2de/0x1b70
[35028.238412]                      [<ffffffff810b4ef6>] lock_acquire+0x96/0x150
[35028.238414]                      [<ffffffff81471710>] mutex_lock_nested+0x50/0x3c0
[35028.238416]                      [<ffffffffa01b2719>] jfs_mkdir+0xa9/0x350 [jfs]
[35028.238420]                      [<ffffffff81193d3c>] vfs_mkdir+0xbc/0x130
[35028.238422]                      [<ffffffff81197863>] sys_mkdirat+0xa3/0xb0
[35028.238424]                      [<ffffffff81197889>] sys_mkdir+0x19/0x20
[35028.238426]                      [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
[35028.238428]   }
[35028.238429]   ... key      at: [<ffffffffa01d83a8>] __key.27657+0x0/0xffffffffffffba06 [jfs]
[35028.238434]   ... acquired at:
[35028.238435]    [<ffffffff810b4ef6>] lock_acquire+0x96/0x150
[35028.238437]    [<ffffffff81471710>] mutex_lock_nested+0x50/0x3c0
[35028.238439]    [<ffffffffa01b4078>] jfs_unlink+0xa8/0x390 [jfs]
[35028.238443]    [<ffffffff811952ae>] vfs_unlink+0x9e/0x110
[35028.238445]    [<ffffffff811954bb>] do_unlinkat+0x19b/0x1d0
[35028.238447]    [<ffffffff81197916>] sys_unlink+0x16/0x20
[35028.238449]    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b

[35028.238452] -> (&jfs_ip->rdwrlock#2){++++-.} ops: 41421459 {
[35028.238456]    HARDIRQ-ON-W at:
[35028.238457]                     [<ffffffff810b3507>] __lock_acquire+0x737/0x1b70
[35028.238460]                     [<ffffffff810b4ef6>] lock_acquire+0x96/0x150
[35028.238462]                     [<ffffffff810823df>] down_write_nested+0x2f/0x60
[35028.238465]                     [<ffffffffa01b4054>] jfs_unlink+0x84/0x390 [jfs]
[35028.238469]                     [<ffffffff811952ae>] vfs_unlink+0x9e/0x110
[35028.238471]                     [<ffffffff811954bb>] do_unlinkat+0x19b/0x1d0
[35028.238473]                     [<ffffffff81197916>] sys_unlink+0x16/0x20
[35028.238475]                     [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
[35028.238478]    HARDIRQ-ON-R at:
[35028.238479]                     [<ffffffff810b331e>] __lock_acquire+0x54e/0x1b70
[35028.238481]                     [<ffffffff810b4ef6>] lock_acquire+0x96/0x150
[35028.238483]                     [<ffffffff81082442>] down_read_nested+0x32/0x50
[35028.238486]                     [<ffffffffa01b18e5>] jfs_get_block+0xa5/0x220 [jfs]
[35028.238490]                     [<ffffffff811c5eee>] do_mpage_readpage+0x3ce/0x6d0
[35028.238492]                     [<ffffffff811c62dc>] mpage_readpages+0xec/0x140
[35028.238495]                     [<ffffffffa01b17dd>] jfs_readpages+0x1d/0x20 [jfs]
[35028.238498]                     [<ffffffff8112d80a>] __do_page_cache_readahead+0x22a/0x2e0
[35028.238501]                     [<ffffffff8112dc31>] ra_submit+0x21/0x30
[35028.238503]                     [<ffffffff8112dd56>] ondemand_readahead+0x116/0x2c0
[35028.238505]                     [<ffffffff8112dfe1>] page_cache_sync_readahead+0x31/0x50
[35028.238507]                     [<ffffffff81122f30>] generic_file_aio_read+0x4d0/0x720
[35028.238510]                     [<ffffffff81185f27>] do_sync_read+0xa7/0xe0
[35028.238512]                     [<ffffffff81186865>] vfs_read+0xa5/0x180
[35028.238514]                     [<ffffffff8118c506>] kernel_read+0x46/0x60
[35028.238516]                     [<ffffffff8118c643>] prepare_binprm+0x123/0x1e0
[35028.238519]                     [<ffffffff8118e23a>] do_execve_common.isra.32+0x36a/0x4a0
[35028.238521]                     [<ffffffff8118e38b>] do_execve+0x1b/0x20
[35028.238524]                     [<ffffffff8101fee7>] sys_execve+0x47/0x70
[35028.238527]                     [<ffffffff81475a6c>] stub_execve+0x6c/0xc0
[35028.238529]    SOFTIRQ-ON-W at:
[35028.238530]                     [<ffffffff810b3354>] __lock_acquire+0x584/0x1b70
[35028.238533]                     [<ffffffff810b4ef6>] lock_acquire+0x96/0x150
[35028.238535]                     [<ffffffff810823df>] down_write_nested+0x2f/0x60
[35028.238538]                     [<ffffffffa01b4054>] jfs_unlink+0x84/0x390 [jfs]
[35028.238541]                     [<ffffffff811952ae>] vfs_unlink+0x9e/0x110
[35028.238543]                     [<ffffffff811954bb>] do_unlinkat+0x19b/0x1d0
[35028.238545]                     [<ffffffff81197916>] sys_unlink+0x16/0x20
[35028.238547]                     [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
[35028.238550]    SOFTIRQ-ON-R at:
[35028.238551]                     [<ffffffff810b3354>] __lock_acquire+0x584/0x1b70
[35028.238553]                     [<ffffffff810b4ef6>] lock_acquire+0x96/0x150
[35028.238556]                     [<ffffffff81082442>] down_read_nested+0x32/0x50
[35028.238558]                     [<ffffffffa01b18e5>] jfs_get_block+0xa5/0x220 [jfs]
[35028.238562]                     [<ffffffff811c5eee>] do_mpage_readpage+0x3ce/0x6d0
[35028.238564]                     [<ffffffff811c62dc>] mpage_readpages+0xec/0x140
[35028.238566]                     [<ffffffffa01b17dd>] jfs_readpages+0x1d/0x20 [jfs]
[35028.238570]                     [<ffffffff8112d80a>] __do_page_cache_readahead+0x22a/0x2e0
[35028.238572]                     [<ffffffff8112dc31>] ra_submit+0x21/0x30
[35028.238574]                     [<ffffffff8112dd56>] ondemand_readahead+0x116/0x2c0
[35028.238576]                     [<ffffffff8112dfe1>] page_cache_sync_readahead+0x31/0x50
[35028.238578]                     [<ffffffff81122f30>] generic_file_aio_read+0x4d0/0x720
[35028.238581]                     [<ffffffff81185f27>] do_sync_read+0xa7/0xe0
[35028.238583]                     [<ffffffff81186865>] vfs_read+0xa5/0x180
[35028.238584]                     [<ffffffff8118c506>] kernel_read+0x46/0x60
[35028.238587]                     [<ffffffff8118c643>] prepare_binprm+0x123/0x1e0
[35028.238589]                     [<ffffffff8118e23a>] do_execve_common.isra.32+0x36a/0x4a0
[35028.238592]                     [<ffffffff8118e38b>] do_execve+0x1b/0x20
[35028.238594]                     [<ffffffff8101fee7>] sys_execve+0x47/0x70
[35028.238596]                     [<ffffffff81475a6c>] stub_execve+0x6c/0xc0
[35028.238599]    IN-RECLAIM_FS-W at:
[35028.238600]                        [<ffffffff810b3280>] __lock_acquire+0x4b0/0x1b70
[35028.238603]                        [<ffffffff810b4ef6>] lock_acquire+0x96/0x150
[35028.238605]                        [<ffffffff810823df>] down_write_nested+0x2f/0x60
[35028.238607]                        [<ffffffffa01b1897>] jfs_get_block+0x57/0x220 [jfs]
[35028.238611]                        [<ffffffff811bb824>] __block_write_full_page+0x104/0x3a0
[35028.238614]                        [<ffffffff811bbba6>] block_write_full_page_endio+0xe6/0x130
[35028.238617]                        [<ffffffff811bbc05>] block_write_full_page+0x15/0x20
[35028.238620]                        [<ffffffffa01b1838>] jfs_writepage+0x18/0x20 [jfs]
[35028.238623]                        [<ffffffff811348d4>] shrink_page_list+0x764/0x980
[35028.238627]                        [<ffffffff81134f16>] shrink_inactive_list+0x146/0x410
[35028.238629]                        [<ffffffff81135911>] shrink_lruvec+0x391/0x5b0
[35028.238632]                        [<ffffffff81135ba5>] shrink_zone+0x75/0xa0
[35028.238634]                        [<ffffffff81136f5c>] balance_pgdat+0x5fc/0x7f0
[35028.238637]                        [<ffffffff811372c8>] kswapd+0x178/0x520
[35028.238639]                        [<ffffffff8107cd8e>] kthread+0xae/0xc0
[35028.238641]                        [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
[35028.238644]    INITIAL USE at:
[35028.238645]                    [<ffffffff810b30ae>] __lock_acquire+0x2de/0x1b70
[35028.238648]                    [<ffffffff810b4ef6>] lock_acquire+0x96/0x150
[35028.238650]                    [<ffffffff81082442>] down_read_nested+0x32/0x50
[35028.238652]                    [<ffffffffa01b18e5>] jfs_get_block+0xa5/0x220 [jfs]
[35028.238656]                    [<ffffffff811c5eee>] do_mpage_readpage+0x3ce/0x6d0
[35028.238658]                    [<ffffffff811c62dc>] mpage_readpages+0xec/0x140
[35028.238660]                    [<ffffffffa01b17dd>] jfs_readpages+0x1d/0x20 [jfs]
[35028.238664]                    [<ffffffff8112d80a>] __do_page_cache_readahead+0x22a/0x2e0
[35028.238666]                    [<ffffffff8112dc31>] ra_submit+0x21/0x30
[35028.238668]                    [<ffffffff8112dd56>] ondemand_readahead+0x116/0x2c0
[35028.238670]                    [<ffffffff8112dfe1>] page_cache_sync_readahead+0x31/0x50
[35028.238672]                    [<ffffffff81122f30>] generic_file_aio_read+0x4d0/0x720
[35028.238674]                    [<ffffffff81185f27>] do_sync_read+0xa7/0xe0
[35028.238676]                    [<ffffffff81186865>] vfs_read+0xa5/0x180
[35028.238678]                    [<ffffffff8118c506>] kernel_read+0x46/0x60
[35028.238680]                    [<ffffffff8118c643>] prepare_binprm+0x123/0x1e0
[35028.238683]                    [<ffffffff8118e23a>] do_execve_common.isra.32+0x36a/0x4a0
[35028.238685]                    [<ffffffff8118e38b>] do_execve+0x1b/0x20
[35028.238687]                    [<ffffffff8101fee7>] sys_execve+0x47/0x70
[35028.238689]                    [<ffffffff81475a6c>] stub_execve+0x6c/0xc0
[35028.238692]  }
[35028.238692]  ... key      at: [<ffffffffa01d83a0>] __key.27656+0x0/0xffffffffffffba0e [jfs]
[35028.238697]  ... acquired at:
[35028.238697]    [<ffffffff810b1f9e>] check_usage_forwards+0x13e/0x150
[35028.238700]    [<ffffffff810b29d6>] mark_lock+0x1d6/0x5d0
[35028.238702]    [<ffffffff810b3280>] __lock_acquire+0x4b0/0x1b70
[35028.238704]    [<ffffffff810b4ef6>] lock_acquire+0x96/0x150
[35028.238706]    [<ffffffff810823df>] down_write_nested+0x2f/0x60
[35028.238709]    [<ffffffffa01b1897>] jfs_get_block+0x57/0x220 [jfs]
[35028.238712]    [<ffffffff811bb824>] __block_write_full_page+0x104/0x3a0
[35028.238715]    [<ffffffff811bbba6>] block_write_full_page_endio+0xe6/0x130
[35028.238717]    [<ffffffff811bbc05>] block_write_full_page+0x15/0x20
[35028.238720]    [<ffffffffa01b1838>] jfs_writepage+0x18/0x20 [jfs]
[35028.238723]    [<ffffffff811348d4>] shrink_page_list+0x764/0x980
[35028.238726]    [<ffffffff81134f16>] shrink_inactive_list+0x146/0x410
[35028.238728]    [<ffffffff81135911>] shrink_lruvec+0x391/0x5b0
[35028.238730]    [<ffffffff81135ba5>] shrink_zone+0x75/0xa0
[35028.238732]    [<ffffffff81136f5c>] balance_pgdat+0x5fc/0x7f0
[35028.238735]    [<ffffffff811372c8>] kswapd+0x178/0x520
[35028.238737]    [<ffffffff8107cd8e>] kthread+0xae/0xc0
[35028.238739]    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10

[35028.238742] 
stack backtrace:
[35028.238744] Pid: 36, comm: kswapd0 Tainted: G        W    3.6.0-rc7-00039-g6f0f9b6 #130
[35028.238746] Call Trace:
[35028.238750]  [<ffffffff8146ba1d>] print_irq_inversion_bug.part.31+0x1b0/0x1bf
[35028.238752]  [<ffffffff810b1f9e>] check_usage_forwards+0x13e/0x150
[35028.238755]  [<ffffffff810b1e60>] ? check_usage_backwards+0x150/0x150
[35028.238758]  [<ffffffff810b29d6>] mark_lock+0x1d6/0x5d0
[35028.238760]  [<ffffffff810b3280>] __lock_acquire+0x4b0/0x1b70
[35028.238762]  [<ffffffff81473fb5>] ? _raw_write_unlock_irqrestore+0x65/0x80
[35028.238765]  [<ffffffff810b5a0d>] ? trace_hardirqs_on+0xd/0x10
[35028.238769]  [<ffffffff8118386d>] ? create_object+0x1ed/0x2f0
[35028.238771]  [<ffffffff810b4ef6>] lock_acquire+0x96/0x150
[35028.238776]  [<ffffffffa01b1897>] ? jfs_get_block+0x57/0x220 [jfs]
[35028.238779]  [<ffffffff810823df>] down_write_nested+0x2f/0x60
[35028.238783]  [<ffffffffa01b1897>] ? jfs_get_block+0x57/0x220 [jfs]
[35028.238786]  [<ffffffff810b5aac>] ? debug_check_no_locks_freed+0x9c/0x180
[35028.238790]  [<ffffffffa01b1897>] jfs_get_block+0x57/0x220 [jfs]
[35028.238792]  [<ffffffff8147457b>] ? _raw_spin_unlock+0x2b/0x60
[35028.238795]  [<ffffffff811bb824>] __block_write_full_page+0x104/0x3a0
[35028.238798]  [<ffffffff811b9070>] ? end_buffer_async_read+0x260/0x260
[35028.238803]  [<ffffffffa01b1840>] ? jfs_writepage+0x20/0x20 [jfs]
[35028.238807]  [<ffffffffa01b1840>] ? jfs_writepage+0x20/0x20 [jfs]
[35028.238810]  [<ffffffff811b9070>] ? end_buffer_async_read+0x260/0x260
[35028.238812]  [<ffffffff811bbba6>] block_write_full_page_endio+0xe6/0x130
[35028.238815]  [<ffffffff811bbc05>] block_write_full_page+0x15/0x20
[35028.238820]  [<ffffffffa01b1838>] jfs_writepage+0x18/0x20 [jfs]
[35028.238822]  [<ffffffff811348d4>] shrink_page_list+0x764/0x980
[35028.238825]  [<ffffffff81134f16>] shrink_inactive_list+0x146/0x410
[35028.238828]  [<ffffffff81135911>] shrink_lruvec+0x391/0x5b0
[35028.238831]  [<ffffffff8117a3dd>] ? mem_cgroup_iter+0x15d/0x260
[35028.238833]  [<ffffffff81135ba5>] shrink_zone+0x75/0xa0
[35028.238836]  [<ffffffff81136f5c>] balance_pgdat+0x5fc/0x7f0
[35028.238839]  [<ffffffff811372c8>] kswapd+0x178/0x520
[35028.238841]  [<ffffffff8107d790>] ? __init_waitqueue_head+0x60/0x60
[35028.238844]  [<ffffffff81137150>] ? balance_pgdat+0x7f0/0x7f0
[35028.238846]  [<ffffffff8107cd8e>] kthread+0xae/0xc0
[35028.238848]  [<ffffffff810b5a0d>] ? trace_hardirqs_on+0xd/0x10
[35028.238851]  [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
[35028.238853]  [<ffffffff81474b74>] ? retint_restore_args+0x13/0x13
[35028.238856]  [<ffffffff8107cce0>] ? __init_kthread_worker+0x70/0x70
[35028.238858]  [<ffffffff81476780>] ? gs_change+0x13/0x13
[35183.643263] CPU3: Core temperature above threshold, cpu clock throttled (total events = 37959)
[35183.643265] CPU1: Core temperature above threshold, cpu clock throttled (total events = 37959)
[35183.643268] CPU1: Package temperature above threshold, cpu clock throttled (total events = 42940)
[35183.643271] CPU0: Package temperature above threshold, cpu clock throttled (total events = 42939)
[35183.643273] CPU2: Package temperature above threshold, cpu clock throttled (total events = 42938)
[35183.643278] CPU3: Package temperature above threshold, cpu clock throttled (total events = 42940)
[35183.644258] CPU1: Core temperature/speed normal
[35183.644259] CPU3: Core temperature/speed normal
[35183.644261] CPU0: Package temperature/speed normal
[35183.644262] CPU2: Package temperature/speed normal
[35183.644263] CPU3: Package temperature/speed normal
[35183.644268] CPU1: Package temperature/speed normal
[35207.787992] systemd-journald[205]: Data hash table of /run/log/journal/430f5d56a9288edc7eca1b05000004e3/system.journal has a fill level at 75.0 (32944 of 43925 items, 16678912 file size, 506 bytes per hash table item), suggesting rotation.
[35207.788006] systemd-journald[205]: Journal header limits reached or header out-of-date, rotating.
[35207.788015] systemd-journald[205]: Rotating...
[35207.788564] systemd-journald[205]: Reserving 43925 entries in hash table.
[35207.790684] systemd-journald[205]: Vacuuming...
[35483.625834] CPU1: Core temperature above threshold, cpu clock throttled (total events = 38091)
[35483.625837] CPU2: Package temperature above threshold, cpu clock throttled (total events = 43070)
[35483.625838] CPU0: Package temperature above threshold, cpu clock throttled (total events = 43071)
[35483.625845] CPU1: Package temperature above threshold, cpu clock throttled (total events = 43072)
[35483.625950] CPU3: Core temperature above threshold, cpu clock throttled (total events = 38091)
[35483.625954] CPU3: Package temperature above threshold, cpu clock throttled (total events = 43072)
[35483.626822] CPU1: Core temperature/speed normal
[35483.626824] CPU0: Package temperature/speed normal
[35483.626825] CPU2: Package temperature/speed normal
[35483.626831] CPU1: Package temperature/speed normal
[35483.626960] CPU3: Core temperature/speed normal
[35483.626963] CPU3: Package temperature/speed normal
[35779.523880] systemd-journald[205]: Data hash table of /run/log/journal/430f5d56a9288edc7eca1b05000004e3/system.journal has a fill level at 75.0 (32945 of 43925 items, 16281600 file size, 494 bytes per hash table item), suggesting rotation.
[35779.523893] systemd-journald[205]: Journal header limits reached or header out-of-date, rotating.
[35779.523901] systemd-journald[205]: Rotating...
[35779.524479] systemd-journald[205]: Reserving 43925 entries in hash table.
[35779.526341] systemd-journald[205]: Vacuuming...
[35787.130847] CPU3: Core temperature above threshold, cpu clock throttled (total events = 38469)
[35787.130849] CPU1: Core temperature above threshold, cpu clock throttled (total events = 38469)
[35787.130851] CPU2: Package temperature above threshold, cpu clock throttled (total events = 43476)
[35787.130853] CPU0: Package temperature above threshold, cpu clock throttled (total events = 43477)
[35787.130856] CPU1: Package temperature above threshold, cpu clock throttled (total events = 43478)
[35787.130862] CPU3: Package temperature above threshold, cpu clock throttled (total events = 43478)
[35787.131833] CPU3: Core temperature/speed normal
[35787.131834] CPU1: Core temperature/speed normal
[35787.131837] CPU2: Package temperature/speed normal
[35787.131838] CPU0: Package temperature/speed normal
[35787.131839] CPU1: Package temperature/speed normal
[35787.131843] CPU3: Package temperature/speed normal
[36151.860057] CPU1: Core temperature above threshold, cpu clock throttled (total events = 38477)
[36151.860059] CPU3: Core temperature above threshold, cpu clock throttled (total events = 38477)
[36151.860062] CPU3: Package temperature above threshold, cpu clock throttled (total events = 43486)
[36151.860064] CPU2: Package temperature above threshold, cpu clock throttled (total events = 43484)
[36151.860066] CPU0: Package temperature above threshold, cpu clock throttled (total events = 43485)
[36151.860071] CPU1: Package temperature above threshold, cpu clock throttled (total events = 43486)
[36151.861060] CPU3: Core temperature/speed normal
[36151.861061] CPU1: Core temperature/speed normal
[36151.861064] CPU2: Package temperature/speed normal
[36151.861065] CPU0: Package temperature/speed normal
[36151.861066] CPU1: Package temperature/speed normal
[36151.861071] CPU3: Package temperature/speed normal
[36328.948352] kmemleak: 5 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[36427.166335] systemd-journald[205]: Data hash table of /run/log/journal/430f5d56a9288edc7eca1b05000004e3/system.journal has a fill level at 75.0 (32944 of 43925 items, 16281600 file size, 494 bytes per hash table item), suggesting rotation.
[36427.166352] systemd-journald[205]: Journal header limits reached or header out-of-date, rotating.
[36427.166367] systemd-journald[205]: Rotating...
[36427.166846] systemd-journald[205]: Reserving 43925 entries in hash table.
[36427.169462] systemd-journald[205]: Vacuuming...
[36455.677610] CPU3: Core temperature above threshold, cpu clock throttled (total events = 38591)
[36455.677612] CPU0: Package temperature above threshold, cpu clock throttled (total events = 43601)
[36455.677614] CPU2: Package temperature above threshold, cpu clock throttled (total events = 43600)
[36455.677616] CPU1: Core temperature above threshold, cpu clock throttled (total events = 38591)
[36455.677619] CPU1: Package temperature above threshold, cpu clock throttled (total events = 43602)
[36455.677624] CPU3: Package temperature above threshold, cpu clock throttled (total events = 43602)
[36455.678632] CPU3: Core temperature/speed normal
[36455.678633] CPU1: Core temperature/speed normal
[36455.678636] CPU1: Package temperature/speed normal
[36455.678638] CPU2: Package temperature/speed normal
[36455.678639] CPU0: Package temperature/speed normal
[36455.678643] CPU3: Package temperature/speed normal

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg8-post-backup

[36936.314439] CPU1: Core temperature above threshold, cpu clock throttled (total events = 38719)
[36936.314442] CPU0: Package temperature above threshold, cpu clock throttled (total events = 43732)
[36936.314443] CPU2: Package temperature above threshold, cpu clock throttled (total events = 43731)
[36936.314451] CPU1: Package temperature above threshold, cpu clock throttled (total events = 43733)
[36936.314521] CPU3: Core temperature above threshold, cpu clock throttled (total events = 38719)
[36936.314525] CPU3: Package temperature above threshold, cpu clock throttled (total events = 43733)
[36936.315422] CPU1: Core temperature/speed normal
[36936.315423] CPU3: Core temperature/speed normal
[36936.315425] CPU3: Package temperature/speed normal
[36936.315427] CPU0: Package temperature/speed normal
[36936.315428] CPU2: Package temperature/speed normal
[36936.315433] CPU1: Package temperature/speed normal
[37077.510179] systemd-journald[205]: Data hash table of /run/log/journal/430f5d56a9288edc7eca1b05000004e3/system.journal has a fill level at 75.0 (32944 of 43925 items, 16232448 file size, 492 bytes per hash table item), suggesting rotation.
[37077.510197] systemd-journald[205]: Journal header limits reached or header out-of-date, rotating.
[37077.510209] systemd-journald[205]: Rotating...
[37077.510984] systemd-journald[205]: Reserving 43925 entries in hash table.
[37077.515009] systemd-journald[205]: Vacuuming...
[37636.982921] CPU1: Core temperature above threshold, cpu clock throttled (total events = 38788)
[37636.982923] CPU3: Core temperature above threshold, cpu clock throttled (total events = 38788)
[37636.982926] CPU3: Package temperature above threshold, cpu clock throttled (total events = 43802)
[37636.982928] CPU0: Package temperature above threshold, cpu clock throttled (total events = 43801)
[37636.982930] CPU2: Package temperature above threshold, cpu clock throttled (total events = 43800)
[37636.982936] CPU1: Package temperature above threshold, cpu clock throttled (total events = 43802)
[37636.983931] CPU1: Core temperature/speed normal
[37636.983932] CPU3: Core temperature/speed normal
[37636.983934] CPU3: Package temperature/speed normal
[37636.983936] CPU2: Package temperature/speed normal
[37636.983938] CPU0: Package temperature/speed normal
[37636.983942] CPU1: Package temperature/speed normal
[37719.053235] systemd-journald[205]: Data hash table of /run/log/journal/430f5d56a9288edc7eca1b05000004e3/system.journal has a fill level at 75.0 (32945 of 43925 items, 16138240 file size, 489 bytes per hash table item), suggesting rotation.
[37719.053251] systemd-journald[205]: Journal header limits reached or header out-of-date, rotating.
[37719.053265] systemd-journald[205]: Rotating...
[37719.054399] systemd-journald[205]: Reserving 43925 entries in hash table.
[37719.056963] systemd-journald[205]: Vacuuming...
[37950.739923] CPU3: Core temperature above threshold, cpu clock throttled (total events = 39137)
[37950.739925] CPU1: Core temperature above threshold, cpu clock throttled (total events = 39137)
[37950.739928] CPU1: Package temperature above threshold, cpu clock throttled (total events = 44159)
[37950.739930] CPU0: Package temperature above threshold, cpu clock throttled (total events = 44158)
[37950.739932] CPU2: Package temperature above threshold, cpu clock throttled (total events = 44157)
[37950.739938] CPU3: Package temperature above threshold, cpu clock throttled (total events = 44159)
[37950.740944] CPU3: Core temperature/speed normal
[37950.740946] CPU1: Core temperature/speed normal
[37950.740948] CPU0: Package temperature/speed normal
[37950.740950] CPU2: Package temperature/speed normal
[37950.740951] CPU1: Package temperature/speed normal
[37950.740956] CPU3: Package temperature/speed normal
[38380.686759] systemd-journald[205]: Data hash table of /run/log/journal/430f5d56a9288edc7eca1b05000004e3/system.journal has a fill level at 75.0 (32944 of 43925 items, 16293888 file size, 494 bytes per hash table item), suggesting rotation.
[38380.686777] systemd-journald[205]: Journal header limits reached or header out-of-date, rotating.
[38380.686790] systemd-journald[205]: Rotating...
[38380.687068] systemd-journald[205]: Reserving 43925 entries in hash table.
[38380.689189] systemd-journald[205]: Vacuuming...
[38565.608682] CPU3: Core temperature above threshold, cpu clock throttled (total events = 39443)
[38565.608684] CPU1: Core temperature above threshold, cpu clock throttled (total events = 39443)
[38565.608687] CPU1: Package temperature above threshold, cpu clock throttled (total events = 44483)
[38565.608690] CPU0: Package temperature above threshold, cpu clock throttled (total events = 44482)
[38565.608692] CPU2: Package temperature above threshold, cpu clock throttled (total events = 44481)
[38565.608695] CPU3: Package temperature above threshold, cpu clock throttled (total events = 44483)
[38565.609708] CPU3: Core temperature/speed normal
[38565.609709] CPU1: Core temperature/speed normal
[38565.609711] CPU1: Package temperature/speed normal
[38565.609713] CPU0: Package temperature/speed normal
[38565.609717] CPU3: Package temperature/speed normal
[38565.609793] CPU2: Package temperature/speed normal
[39209.432151] CPU0: Core temperature above threshold, cpu clock throttled (total events = 5567)
[39209.432154] CPU3: Package temperature above threshold, cpu clock throttled (total events = 44558)
[39209.432155] CPU1: Package temperature above threshold, cpu clock throttled (total events = 44558)
[39209.432163] CPU0: Package temperature above threshold, cpu clock throttled (total events = 44557)
[39209.432203] CPU2: Core temperature above threshold, cpu clock throttled (total events = 5568)
[39209.432207] CPU2: Package temperature above threshold, cpu clock throttled (total events = 44556)
[39209.433157] CPU1: Package temperature/speed normal
[39209.433158] CPU3: Package temperature/speed normal
[39209.433166] CPU0: Core temperature/speed normal
[39209.433170] CPU0: Package temperature/speed normal
[39209.433176] CPU2: Core temperature/speed normal
[39209.433179] CPU2: Package temperature/speed normal
[39940.469090] CPU1: Core temperature above threshold, cpu clock throttled (total events = 41000)
[39940.469103] CPU1: Package temperature above threshold, cpu clock throttled (total events = 46607)
[39940.469118] CPU0: Package temperature above threshold, cpu clock throttled (total events = 46606)
[39940.469120] CPU2: Package temperature above threshold, cpu clock throttled (total events = 46605)
[39940.469159] CPU3: Core temperature above threshold, cpu clock throttled (total events = 41000)
[39940.469161] CPU3: Package temperature above threshold, cpu clock throttled (total events = 46607)
[39940.470087] CPU0: Package temperature/speed normal
[39940.470089] CPU1: Core temperature/speed normal
[39940.470091] CPU2: Package temperature/speed normal
[39940.470092] CPU1: Package temperature/speed normal
[39940.470111] CPU3: Core temperature/speed normal
[39940.470114] CPU3: Package temperature/speed normal
[40665.667216] CPU0: Core temperature above threshold, cpu clock throttled (total events = 6362)
[40665.667229] CPU0: Package temperature above threshold, cpu clock throttled (total events = 54626)
[40665.667244] CPU3: Package temperature above threshold, cpu clock throttled (total events = 54627)
[40665.667246] CPU1: Package temperature above threshold, cpu clock throttled (total events = 54627)
[40665.667258] CPU2: Core temperature above threshold, cpu clock throttled (total events = 6363)
[40665.667260] CPU2: Package temperature above threshold, cpu clock throttled (total events = 54624)
[40665.668226] CPU0: Core temperature/speed normal
[40665.668228] CPU1: Package temperature/speed normal
[40665.668229] CPU3: Package temperature/speed normal
[40665.668232] CPU0: Package temperature/speed normal
[40665.668271] CPU2: Core temperature/speed normal
[40665.668273] CPU2: Package temperature/speed normal
[41409.550090] CPU1: Core temperature above threshold, cpu clock throttled (total events = 55521)
[41409.550092] CPU3: Core temperature above threshold, cpu clock throttled (total events = 55521)
[41409.550095] CPU3: Package temperature above threshold, cpu clock throttled (total events = 62990)
[41409.550098] CPU2: Package temperature above threshold, cpu clock throttled (total events = 62986)
[41409.550100] CPU0: Package temperature above threshold, cpu clock throttled (total events = 62989)
[41409.550105] CPU1: Package temperature above threshold, cpu clock throttled (total events = 62990)
[41409.551094] CPU2: Package temperature/speed normal
[41409.551095] CPU0: Package temperature/speed normal
[41409.551098] CPU3: Core temperature/speed normal
[41409.551101] CPU3: Package temperature/speed normal
[41409.551191] CPU1: Core temperature/speed normal
[41409.551194] CPU1: Package temperature/speed normal
[42141.057296] CPU0: Package temperature above threshold, cpu clock throttled (total events = 72057)
[42141.057299] CPU1: Core temperature above threshold, cpu clock throttled (total events = 63649)
[42141.057300] CPU3: Core temperature above threshold, cpu clock throttled (total events = 63649)
[42141.057301] CPU1: Package temperature above threshold, cpu clock throttled (total events = 72058)
[42141.057304] CPU3: Package temperature above threshold, cpu clock throttled (total events = 72058)
[42141.057400] CPU2: Package temperature above threshold, cpu clock throttled (total events = 72054)
[42141.058313] CPU0: Package temperature/speed normal
[42141.058316] CPU3: Core temperature/speed normal
[42141.058316] CPU1: Core temperature/speed normal
[42141.058318] CPU1: Package temperature/speed normal
[42141.058319] CPU3: Package temperature/speed normal
[42141.058447] CPU2: Package temperature/speed normal
[42899.382556] CPU2: Package temperature above threshold, cpu clock throttled (total events = 81599)
[42899.382558] CPU0: Package temperature above threshold, cpu clock throttled (total events = 81602)
[42899.382562] CPU1: Core temperature above threshold, cpu clock throttled (total events = 70926)
[42899.382565] CPU1: Package temperature above threshold, cpu clock throttled (total events = 81602)
[42899.382574] CPU3: Core temperature above threshold, cpu clock throttled (total events = 70926)
[42899.382577] CPU3: Package temperature above threshold, cpu clock throttled (total events = 81603)
[42899.383587] CPU1: Core temperature/speed normal
[42899.383590] CPU2: Package temperature/speed normal
[42899.383591] CPU0: Package temperature/speed normal
[42899.383595] CPU1: Package temperature/speed normal
[42899.383596] CPU3: Core temperature/speed normal
[42899.383598] CPU3: Package temperature/speed normal
[43126.162589] systemd-journald[205]: Data hash table of /run/log/journal/430f5d56a9288edc7eca1b05000004e3/system.journal has a fill level at 75.0 (32944 of 43925 items, 16420864 file size, 498 bytes per hash table item), suggesting rotation.
[43126.162607] systemd-journald[205]: Journal header limits reached or header out-of-date, rotating.
[43126.162621] systemd-journald[205]: Rotating...
[43126.163574] systemd-journald[205]: Reserving 43925 entries in hash table.
[43126.168123] systemd-journald[205]: Vacuuming...
[60374.467004] kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kmemleak2

unreferenced object 0xffff8801676e8520 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 10122.246s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 d8 1b 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8540 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 10122.246s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 50 1c 3a a0 ff ff ff ff  ........P.:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8560 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 10122.246s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 b0 1c 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8580 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 10122.246s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 e0 1c 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e85a0 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 10122.246s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 f8 1c 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88016515da00 (size 256):
  comm "systemd-udevd", pid 248, jiffies 4294881104 (age 10121.416s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff b4 4e 2e 82 ff ff ff ff  .........N......
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8133a4fc>] device_private_init+0x2c/0x90
    [<ffffffff8133ce69>] dev_set_drvdata+0x39/0x50
    [<ffffffffa019b1ee>] i801_probe+0x5c/0x460 [i2c_i801]
    [<ffffffff8128dc89>] local_pci_probe+0x79/0x100
    [<ffffffff8128e541>] pci_device_probe+0x111/0x120
    [<ffffffff8133d4cb>] driver_probe_device+0x7b/0x240
    [<ffffffff8133d73b>] __driver_attach+0xab/0xb0
    [<ffffffff8133b675>] bus_for_each_dev+0x55/0x90
    [<ffffffff8133d00e>] driver_attach+0x1e/0x20
    [<ffffffff8133cb88>] bus_add_driver+0x1a8/0x280
    [<ffffffff8133de17>] driver_register+0x77/0x170
    [<ffffffff8128e7df>] __pci_register_driver+0x6f/0xf0
    [<ffffffffa019e0af>] 0xffffffffa019e0af
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
unreferenced object 0xffff880161e98220 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 10109.336s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e98440 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 10109.336s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 20 82 e9 61 01 88 ff ff  ........ ..a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e98660 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 10109.336s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 40 84 e9 61 01 88 ff ff  ........@..a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e98880 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 10109.343s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 60 86 e9 61 01 88 ff ff  ........`..a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e98aa0 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 10109.343s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 80 88 e9 61 01 88 ff ff  ...........a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e98cc0 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 10109.343s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 a0 8a e9 61 01 88 ff ff  ...........a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e98ee0 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 10109.343s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 8c e9 61 01 88 ff ff  ...........a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e99100 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 10109.350s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 e0 8e e9 61 01 88 ff ff  ...........a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e99320 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 10109.350s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 91 e9 61 01 88 ff ff  ...........a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e99540 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 10109.350s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 20 93 e9 61 01 88 ff ff  ........ ..a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e99dc0 (size 544):
  comm "X", pid 453, jiffies 4294884884 (age 10108.846s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 40 95 e9 61 01 88 ff ff  ........@..a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kmemleak3

unreferenced object 0xffff8801676e8520 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 13832.993s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 d8 1b 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8540 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 13832.993s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 50 1c 3a a0 ff ff ff ff  ........P.:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8560 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 13832.993s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 b0 1c 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8580 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 13832.993s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 e0 1c 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e85a0 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 13832.993s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 f8 1c 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88016515da00 (size 256):
  comm "systemd-udevd", pid 248, jiffies 4294881104 (age 13832.163s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff b4 4e 2e 82 ff ff ff ff  .........N......
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8133a4fc>] device_private_init+0x2c/0x90
    [<ffffffff8133ce69>] dev_set_drvdata+0x39/0x50
    [<ffffffffa019b1ee>] i801_probe+0x5c/0x460 [i2c_i801]
    [<ffffffff8128dc89>] local_pci_probe+0x79/0x100
    [<ffffffff8128e541>] pci_device_probe+0x111/0x120
    [<ffffffff8133d4cb>] driver_probe_device+0x7b/0x240
    [<ffffffff8133d73b>] __driver_attach+0xab/0xb0
    [<ffffffff8133b675>] bus_for_each_dev+0x55/0x90
    [<ffffffff8133d00e>] driver_attach+0x1e/0x20
    [<ffffffff8133cb88>] bus_add_driver+0x1a8/0x280
    [<ffffffff8133de17>] driver_register+0x77/0x170
    [<ffffffff8128e7df>] __pci_register_driver+0x6f/0xf0
    [<ffffffffa019e0af>] 0xffffffffa019e0af
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
unreferenced object 0xffff880161e98220 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 13820.080s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e98440 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 13820.080s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 20 82 e9 61 01 88 ff ff  ........ ..a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e98660 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 13820.080s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 40 84 e9 61 01 88 ff ff  ........@..a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e98880 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 13820.083s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 60 86 e9 61 01 88 ff ff  ........`..a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e98aa0 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 13820.083s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 80 88 e9 61 01 88 ff ff  ...........a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e98cc0 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 13820.083s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 a0 8a e9 61 01 88 ff ff  ...........a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e98ee0 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 13820.083s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 c0 8c e9 61 01 88 ff ff  ...........a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e99100 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 13820.090s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 e0 8e e9 61 01 88 ff ff  ...........a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e99320 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 13820.090s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 91 e9 61 01 88 ff ff  ...........a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e99540 (size 544):
  comm "X", pid 453, jiffies 4294884733 (age 13820.090s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 20 93 e9 61 01 88 ff ff  ........ ..a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880161e99dc0 (size 544):
  comm "X", pid 453, jiffies 4294884884 (age 13819.586s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 40 95 e9 61 01 88 ff ff  ........@..a....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff812653c1>] idr_pre_get+0x61/0x90
    [<ffffffffa053015d>] drm_gem_handle_create+0x4d/0x120 [drm]
    [<ffffffffa0581883>] i915_gem_create+0x63/0x160 [i915]
    [<ffffffffa058199e>] i915_gem_create_ioctl+0x1e/0x20 [i915]
    [<ffffffffa052e443>] drm_ioctl+0x4d3/0x580 [drm]
    [<ffffffff811997f9>] do_vfs_ioctl+0x99/0x580
    [<ffffffff81199d79>] sys_ioctl+0x99/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kmemleak4

unreferenced object 0xffff8801676e8520 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 25895.503s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 d8 1b 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8540 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 25895.503s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 50 1c 3a a0 ff ff ff ff  ........P.:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8560 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 25895.503s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 b0 1c 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8580 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 25895.503s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 e0 1c 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e85a0 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 25895.503s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 f8 1c 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88016515da00 (size 256):
  comm "systemd-udevd", pid 248, jiffies 4294881104 (age 25894.673s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff b4 4e 2e 82 ff ff ff ff  .........N......
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8133a4fc>] device_private_init+0x2c/0x90
    [<ffffffff8133ce69>] dev_set_drvdata+0x39/0x50
    [<ffffffffa019b1ee>] i801_probe+0x5c/0x460 [i2c_i801]
    [<ffffffff8128dc89>] local_pci_probe+0x79/0x100
    [<ffffffff8128e541>] pci_device_probe+0x111/0x120
    [<ffffffff8133d4cb>] driver_probe_device+0x7b/0x240
    [<ffffffff8133d73b>] __driver_attach+0xab/0xb0
    [<ffffffff8133b675>] bus_for_each_dev+0x55/0x90
    [<ffffffff8133d00e>] driver_attach+0x1e/0x20
    [<ffffffff8133cb88>] bus_add_driver+0x1a8/0x280
    [<ffffffff8133de17>] driver_register+0x77/0x170
    [<ffffffff8128e7df>] __pci_register_driver+0x6f/0xf0
    [<ffffffffa019e0af>] 0xffffffffa019e0af
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kmemleak5

unreferenced object 0xffff8801684e6020 (size 32):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.966s)
  hex dump (first 32 bytes):
    74 68 65 72 6d 61 6c 5f 74 68 72 6f 74 74 6c 65  thermal_throttle
    00 10 50 68 01 88 ff ff 12 c9 62 50 00 00 00 00  ..Ph......bP....
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff81171e70>] __kmalloc_track_caller+0x150/0x1c0
    [<ffffffff8113e70a>] kstrdup+0x3a/0x70
    [<ffffffff811fa46e>] sysfs_new_dirent+0x2e/0x130
    [<ffffffff811fa923>] create_dir+0x43/0xd0
    [<ffffffff811fac1c>] sysfs_create_subdir+0x1c/0x20
    [<ffffffff811fc785>] internal_create_group+0x65/0x230
    [<ffffffff811fc983>] sysfs_create_group+0x13/0x20
    [<ffffffff814614c1>] thermal_throttle_add_dev+0x2e/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880166e32090 (size 144):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.966s)
  hex dump (first 32 bytes):
    03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff811fa499>] sysfs_new_dirent+0x59/0x130
    [<ffffffff811fa923>] create_dir+0x43/0xd0
    [<ffffffff811fac1c>] sysfs_create_subdir+0x1c/0x20
    [<ffffffff811fc785>] internal_create_group+0x65/0x230
    [<ffffffff811fc983>] sysfs_create_group+0x13/0x20
    [<ffffffff814614c1>] thermal_throttle_add_dev+0x2e/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880166e321b0 (size 144):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.966s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 f8 00 82 81 ff ff ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff811fa499>] sysfs_new_dirent+0x59/0x130
    [<ffffffff811f96eb>] sysfs_add_file_mode+0x6b/0x110
    [<ffffffff811f97a2>] sysfs_add_file+0x12/0x20
    [<ffffffff811f97eb>] sysfs_add_file_to_group+0x3b/0xa0
    [<ffffffff814614eb>] thermal_throttle_add_dev+0x58/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880166e32240 (size 144):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.966s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 38 01 82 81 ff ff ff ff  ........8.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff811fa499>] sysfs_new_dirent+0x59/0x130
    [<ffffffff811f96eb>] sysfs_add_file_mode+0x6b/0x110
    [<ffffffff811f97a2>] sysfs_add_file+0x12/0x20
    [<ffffffff811f97eb>] sysfs_add_file_to_group+0x3b/0xa0
    [<ffffffff8146150e>] thermal_throttle_add_dev+0x7b/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880166e322d0 (size 144):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.970s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 78 01 82 81 ff ff ff ff  ........x.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff811fa499>] sysfs_new_dirent+0x59/0x130
    [<ffffffff811f96eb>] sysfs_add_file_mode+0x6b/0x110
    [<ffffffff811f97a2>] sysfs_add_file+0x12/0x20
    [<ffffffff811f97eb>] sysfs_add_file_to_group+0x3b/0xa0
    [<ffffffff81461531>] thermal_throttle_add_dev+0x9e/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801684e6040 (size 32):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.970s)
  hex dump (first 32 bytes):
    74 68 65 72 6d 61 6c 5f 74 68 72 6f 74 74 6c 65  thermal_throttle
    00 60 4e 68 01 88 ff ff 13 c9 62 50 00 00 00 00  .`Nh......bP....
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff81171e70>] __kmalloc_track_caller+0x150/0x1c0
    [<ffffffff8113e70a>] kstrdup+0x3a/0x70
    [<ffffffff811fa46e>] sysfs_new_dirent+0x2e/0x130
    [<ffffffff811fa923>] create_dir+0x43/0xd0
    [<ffffffff811fac1c>] sysfs_create_subdir+0x1c/0x20
    [<ffffffff811fc785>] internal_create_group+0x65/0x230
    [<ffffffff811fc983>] sysfs_create_group+0x13/0x20
    [<ffffffff814614c1>] thermal_throttle_add_dev+0x2e/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880166e32360 (size 144):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.970s)
  hex dump (first 32 bytes):
    03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff811fa499>] sysfs_new_dirent+0x59/0x130
    [<ffffffff811fa923>] create_dir+0x43/0xd0
    [<ffffffff811fac1c>] sysfs_create_subdir+0x1c/0x20
    [<ffffffff811fc785>] internal_create_group+0x65/0x230
    [<ffffffff811fc983>] sysfs_create_group+0x13/0x20
    [<ffffffff814614c1>] thermal_throttle_add_dev+0x2e/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880166e32480 (size 144):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.970s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 f8 00 82 81 ff ff ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff811fa499>] sysfs_new_dirent+0x59/0x130
    [<ffffffff811f96eb>] sysfs_add_file_mode+0x6b/0x110
    [<ffffffff811f97a2>] sysfs_add_file+0x12/0x20
    [<ffffffff811f97eb>] sysfs_add_file_to_group+0x3b/0xa0
    [<ffffffff814614eb>] thermal_throttle_add_dev+0x58/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880166e32510 (size 144):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.970s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 38 01 82 81 ff ff ff ff  ........8.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff811fa499>] sysfs_new_dirent+0x59/0x130
    [<ffffffff811f96eb>] sysfs_add_file_mode+0x6b/0x110
    [<ffffffff811f97a2>] sysfs_add_file+0x12/0x20
    [<ffffffff811f97eb>] sysfs_add_file_to_group+0x3b/0xa0
    [<ffffffff8146150e>] thermal_throttle_add_dev+0x7b/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880166e325a0 (size 144):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.970s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 78 01 82 81 ff ff ff ff  ........x.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff811fa499>] sysfs_new_dirent+0x59/0x130
    [<ffffffff811f96eb>] sysfs_add_file_mode+0x6b/0x110
    [<ffffffff811f97a2>] sysfs_add_file+0x12/0x20
    [<ffffffff811f97eb>] sysfs_add_file_to_group+0x3b/0xa0
    [<ffffffff81461531>] thermal_throttle_add_dev+0x9e/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801684e6060 (size 32):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.970s)
  hex dump (first 32 bytes):
    74 68 65 72 6d 61 6c 5f 74 68 72 6f 74 74 6c 65  thermal_throttle
    00 6c 65 73 2e 64 00 ff a0 3e 0e 69 01 88 ff ff  .les.d...>.i....
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff81171e70>] __kmalloc_track_caller+0x150/0x1c0
    [<ffffffff8113e70a>] kstrdup+0x3a/0x70
    [<ffffffff811fa46e>] sysfs_new_dirent+0x2e/0x130
    [<ffffffff811fa923>] create_dir+0x43/0xd0
    [<ffffffff811fac1c>] sysfs_create_subdir+0x1c/0x20
    [<ffffffff811fc785>] internal_create_group+0x65/0x230
    [<ffffffff811fc983>] sysfs_create_group+0x13/0x20
    [<ffffffff814614c1>] thermal_throttle_add_dev+0x2e/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880166e32630 (size 144):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.970s)
  hex dump (first 32 bytes):
    03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff811fa499>] sysfs_new_dirent+0x59/0x130
    [<ffffffff811fa923>] create_dir+0x43/0xd0
    [<ffffffff811fac1c>] sysfs_create_subdir+0x1c/0x20
    [<ffffffff811fc785>] internal_create_group+0x65/0x230
    [<ffffffff811fc983>] sysfs_create_group+0x13/0x20
    [<ffffffff814614c1>] thermal_throttle_add_dev+0x2e/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880166e32750 (size 144):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.973s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 f8 00 82 81 ff ff ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff811fa499>] sysfs_new_dirent+0x59/0x130
    [<ffffffff811f96eb>] sysfs_add_file_mode+0x6b/0x110
    [<ffffffff811f97a2>] sysfs_add_file+0x12/0x20
    [<ffffffff811f97eb>] sysfs_add_file_to_group+0x3b/0xa0
    [<ffffffff814614eb>] thermal_throttle_add_dev+0x58/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880166e327e0 (size 144):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.973s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 38 01 82 81 ff ff ff ff  ........8.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff811fa499>] sysfs_new_dirent+0x59/0x130
    [<ffffffff811f96eb>] sysfs_add_file_mode+0x6b/0x110
    [<ffffffff811f97a2>] sysfs_add_file+0x12/0x20
    [<ffffffff811f97eb>] sysfs_add_file_to_group+0x3b/0xa0
    [<ffffffff8146150e>] thermal_throttle_add_dev+0x7b/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff880166e32870 (size 144):
  comm "swapper/0", pid 1, jiffies 4294877627 (age 32154.973s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 78 01 82 81 ff ff ff ff  ........x.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116fb93>] kmem_cache_alloc+0x133/0x180
    [<ffffffff811fa499>] sysfs_new_dirent+0x59/0x130
    [<ffffffff811f96eb>] sysfs_add_file_mode+0x6b/0x110
    [<ffffffff811f97a2>] sysfs_add_file+0x12/0x20
    [<ffffffff811f97eb>] sysfs_add_file_to_group+0x3b/0xa0
    [<ffffffff81461531>] thermal_throttle_add_dev+0x9e/0xa6
    [<ffffffff818de55c>] thermal_throttle_init_device+0x47/0x95
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
    [<ffffffff818d3d9f>] kernel_init+0x13e/0x1c2
    [<ffffffff81476784>] kernel_thread_helper+0x4/0x10
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8520 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 32144.226s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 d8 1b 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8540 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 32144.230s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 50 1c 3a a0 ff ff ff ff  ........P.:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8560 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 32144.230s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 b0 1c 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e8580 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 32144.230s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 e0 1c 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801676e85a0 (size 32):
  comm "systemd-modules", pid 194, jiffies 4294880853 (age 32144.230s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 f8 1c 3a a0 ff ff ff ff  ..........:.....
    20 1d 3a a0 ff ff ff ff 00 00 00 00 00 00 00 00   .:.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8111feb3>] jump_label_module_notify+0x163/0x200
    [<ffffffff8108368d>] notifier_call_chain+0x4d/0x70
    [<ffffffff810838b8>] __blocking_notifier_call_chain+0x58/0x80
    [<ffffffff810838f6>] blocking_notifier_call_chain+0x16/0x20
    [<ffffffff810c1343>] sys_init_module+0x1053/0x1ed0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88016515da00 (size 256):
  comm "systemd-udevd", pid 248, jiffies 4294881104 (age 32143.400s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff b4 4e 2e 82 ff ff ff ff  .........N......
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f960>] kmem_cache_alloc_trace+0x140/0x190
    [<ffffffff8133a4fc>] device_private_init+0x2c/0x90
    [<ffffffff8133ce69>] dev_set_drvdata+0x39/0x50
    [<ffffffffa019b1ee>] i801_probe+0x5c/0x460 [i2c_i801]
    [<ffffffff8128dc89>] local_pci_probe+0x79/0x100
    [<ffffffff8128e541>] pci_device_probe+0x111/0x120
    [<ffffffff8133d4cb>] driver_probe_device+0x7b/0x240
    [<ffffffff8133d73b>] __driver_attach+0xab/0xb0
    [<ffffffff8133b675>] bus_for_each_dev+0x55/0x90
    [<ffffffff8133d00e>] driver_attach+0x1e/0x20
    [<ffffffff8133cb88>] bus_add_driver+0x1a8/0x280
    [<ffffffff8133de17>] driver_register+0x77/0x170
    [<ffffffff8128e7df>] __pci_register_driver+0x6f/0xf0
    [<ffffffffa019e0af>] 0xffffffffa019e0af
    [<ffffffff8100212a>] do_one_initcall+0x12a/0x180

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kmemleak6-slab1.5g"


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kmemleak7

unreferenced object 0xffff8801146d6000 (size 1024):
  comm "cat", pid 28451, jiffies 4299182814 (age 22472.980s)
  hex dump (first 32 bytes):
    00 80 2a 60 01 88 ff ff 28 60 6d 14 01 88 ff ff  ..*`....(`m.....
    28 61 6d 14 01 88 ff ff ed 00 00 00 00 01 00 00  (am.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f400>] __kmalloc+0x160/0x1d0
    [<ffffffff8130f7d8>] __tty_buffer_request_room+0xd8/0x1a0
    [<ffffffff8130fbbe>] tty_insert_flip_string_fixed_flag+0x6e/0x100
    [<ffffffff8131107b>] pty_write+0x3b/0x70
    [<ffffffff81309aa7>] do_output_char+0x187/0x230
    [<ffffffff81309b96>] process_output+0x46/0x70
    [<ffffffff8130ac70>] n_tty_write+0x200/0x490
    [<ffffffff81306fa9>] tty_write+0x159/0x2c0
    [<ffffffff811866e8>] vfs_write+0xa8/0x180
    [<ffffffff81186a2a>] sys_write+0x4a/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801145c7000 (size 1024):
  comm "zsh", pid 28446, jiffies 4299182829 (age 22472.930s)
  hex dump (first 32 bytes):
    00 74 48 5d 01 88 ff ff 28 70 5c 14 01 88 ff ff  .tH]....(p\.....
    28 71 5c 14 01 88 ff ff c3 00 00 00 00 01 00 00  (q\.............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f400>] __kmalloc+0x160/0x1d0
    [<ffffffff8130f7d8>] __tty_buffer_request_room+0xd8/0x1a0
    [<ffffffff8130fbbe>] tty_insert_flip_string_fixed_flag+0x6e/0x100
    [<ffffffff8131107b>] pty_write+0x3b/0x70
    [<ffffffff8130ac3d>] n_tty_write+0x1cd/0x490
    [<ffffffff81306fa9>] tty_write+0x159/0x2c0
    [<ffffffff811866e8>] vfs_write+0xa8/0x180
    [<ffffffff81186a2a>] sys_write+0x4a/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88013bcf9400 (size 1024):
  comm "vpnc", pid 28461, jiffies 4299185359 (age 22464.496s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 28 94 cf 3b 01 88 ff ff  ........(..;....
    28 95 cf 3b 01 88 ff ff ed 00 00 00 00 01 00 00  (..;............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f400>] __kmalloc+0x160/0x1d0
    [<ffffffff8130f7d8>] __tty_buffer_request_room+0xd8/0x1a0
    [<ffffffff8130fbbe>] tty_insert_flip_string_fixed_flag+0x6e/0x100
    [<ffffffff8131107b>] pty_write+0x3b/0x70
    [<ffffffff8130ac3d>] n_tty_write+0x1cd/0x490
    [<ffffffff81306fa9>] tty_write+0x159/0x2c0
    [<ffffffff811866e8>] vfs_write+0xa8/0x180
    [<ffffffff81186a2a>] sys_write+0x4a/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff88015d487400 (size 1024):
  comm "vpnc", pid 28461, jiffies 4299210874 (age 22379.446s)
  hex dump (first 32 bytes):
    00 60 6d 14 01 88 ff ff 28 74 48 5d 01 88 ff ff  .`m.....(tH]....
    28 75 48 5d 01 88 ff ff ed 00 00 00 00 01 00 00  (uH]............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f400>] __kmalloc+0x160/0x1d0
    [<ffffffff8130f7d8>] __tty_buffer_request_room+0xd8/0x1a0
    [<ffffffff8130fbbe>] tty_insert_flip_string_fixed_flag+0x6e/0x100
    [<ffffffff8131107b>] pty_write+0x3b/0x70
    [<ffffffff8130ac3d>] n_tty_write+0x1cd/0x490
    [<ffffffff81306fa9>] tty_write+0x159/0x2c0
    [<ffffffff811866e8>] vfs_write+0xa8/0x180
    [<ffffffff81186a2a>] sys_write+0x4a/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff8801602a8000 (size 1024):
  comm "vpnc", pid 28461, jiffies 4299242028 (age 22275.603s)
  hex dump (first 32 bytes):
    00 94 cf 3b 01 88 ff ff 28 80 2a 60 01 88 ff ff  ...;....(.*`....
    28 81 2a 60 01 88 ff ff ed 00 00 00 00 01 00 00  (.*`............
  backtrace:
    [<ffffffff81451506>] kmemleak_alloc+0x26/0x50
    [<ffffffff8116f400>] __kmalloc+0x160/0x1d0
    [<ffffffff8130f7d8>] __tty_buffer_request_room+0xd8/0x1a0
    [<ffffffff8130fbbe>] tty_insert_flip_string_fixed_flag+0x6e/0x100
    [<ffffffff8131107b>] pty_write+0x3b/0x70
    [<ffffffff8130ac3d>] n_tty_write+0x1cd/0x490
    [<ffffffff81306fa9>] tty_write+0x159/0x2c0
    [<ffffffff811866e8>] vfs_write+0xa8/0x180
    [<ffffffff81186a2a>] sys_write+0x4a/0xa0
    [<ffffffff814755a9>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kmemleak8


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabtop4

 Active / Total Objects (% used)    : 437358 / 448011 (97.6%)
 Active / Total Slabs (% used)      : 17518 / 17518 (100.0%)
 Active / Total Caches (% used)     : 71 / 111 (64.0%)
 Active / Total Size (% used)       : 189486.99K / 193128.03K (98.1%)
 Minimum / Average / Maximum Object : 0.01K / 0.43K / 15.42K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
215864 215153  99%    0.36K   9812       22     78496K kmemleak_object
 55044  55044 100%    0.24K   1668       33     13344K dentry
 30379  30379 100%    1.84K   1787       17     57184K jfs_ip
 20132  20132 100%    0.14K    719       28      2876K sysfs_dir_cache
 13552  13552 100%    0.55K    484       28      7744K radix_tree_node
 13409  12305  91%    0.17K    583       23      2332K vm_area_struct
 12665  10602  83%    0.05K    149       85       596K shared_policy_node
  9835   9835 100%    0.91K    281       35      8992K inode_cache
  8704   8668  99%    0.01K     17      512        68K kmalloc-8
  6848   6779  98%    0.06K    107       64       428K kmalloc-64
  5543   4933  88%    0.17K    241       23       964K anon_vma
  5120   5112  99%    0.02K     20      256        80K kmalloc-16
  5014   5014 100%    0.17K    218       23       872K jfs_mp
  4250   3184  74%    0.31K    170       25      1360K filp
  3976   3820  96%    0.07K     71       56       284K Acpi-ParseExt
  3630   3009  82%    0.97K    110       33      3520K proc_inode_cache
  3318   2604  78%    0.09K     79       42       316K kmalloc-96
  3136   2757  87%    0.12K     98       32       392K kmalloc-128
  3072   2796  91%    0.03K     24      128        96K kmalloc-32
  2877   2264  78%    0.19K    137       21       548K kmalloc-192
  2208   2208 100%    0.25K     69       32       552K kmalloc-256
  1836   1836 100%    0.04K     18      102        72K Acpi-Namespace
  1682   1451  86%    1.08K     58       29      1856K shmem_inode_cache
  1530   1530 100%    0.02K      9      170        36K numa_policy


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabtop5

 Active / Total Objects (% used)    : 1371302 / 1512383 (90.7%)
 Active / Total Slabs (% used)      : 74950 / 74950 (100.0%)
 Active / Total Caches (% used)     : 76 / 113 (67.3%)
 Active / Total Size (% used)       : 1141263.96K / 1193833.00K (95.6%)
 Minimum / Average / Maximum Object : 0.01K / 0.79K / 15.42K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
750376 677261  90%    0.36K  34108       22    272864K kmemleak_object
447506 447326  99%    1.84K  30718       17    982976K jfs_ip
 79009  48678  61%    0.55K   2842       28     45472K radix_tree_node
 46138  21969  47%    0.17K   2006       23      8024K jfs_mp
 35673  34844  97%    0.24K   1081       33      8648K dentry
 20356  20356 100%    0.14K    727       28      2908K sysfs_dir_cache
 17411  16810  96%    0.17K    757       23      3028K vm_area_struct
 16405  15828  96%    0.05K    193       85       772K shared_policy_node
 10368   8870  85%    0.06K    162       64       648K kmalloc-64
  9450   8655  91%    0.91K    270       35      8640K inode_cache
  8704   8668  99%    0.01K     17      512        68K kmalloc-8 
  7636   7281  95%    0.17K    332       23      1328K anon_vma
  5586   3861  69%    0.09K    133       42       532K kmalloc-96
  5440   5440 100%    0.02K     32      170       128K numa_policy
  5120   5112  99%    0.02K     20      256        80K kmalloc-16
  4640   4184  90%    0.12K    145       32       580K kmalloc-128
  4375   3625  82%    0.31K    175       25      1400K filp
  4032   4032 100%    0.07K     72       56       288K Acpi-ParseExt
  3828   2353  61%    0.97K    116       33      3712K proc_inode_cache
  3591   2521  70%    0.19K    171       21       684K kmalloc-192
  3200   3200 100%    0.03K     25      128       100K kmalloc-32      
  2272   2114  93%    0.25K     71       32       568K kmalloc-256
  1938   1938 100%    0.04K     19      102        76K Acpi-Namespace
  1792   1376  76%    1.00K     56       32      1792K kmalloc-1024



--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="slabtop6-slab1.5g"

 Active / Total Objects (% used)    : 1579895 / 1671078 (94.5%)
 Active / Total Slabs (% used)      : 95363 / 95363 (100.0%)
 Active / Total Caches (% used)     : 76 / 113 (67.3%)
 Active / Total Size (% used)       : 1498989.21K / 1532536.44K (97.8%)
 Minimum / Average / Maximum Object : 0.01K / 0.92K / 15.42K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
838530 780770  93%    0.36K  38115       22    304920K kmemleak_object
640986 640986 100%    1.84K  51813       17   1658016K jfs_ip
 28710  14393  50%    0.24K    870       33      6960K dentry
 20356  20356 100%    0.14K    727       28      2908K sysfs_dir_cache
 17411  16930  97%    0.17K    757       23      3028K vm_area_struct
 16405  15463  94%    0.05K    193       85       772K shared_policy_node
 10367   2995  28%    0.55K    371       28      5936K radix_tree_node
  9345   7691  82%    0.91K    267       35      8544K inode_cache
  8704   8662  99%    0.01K     17      512        68K kmalloc-8
  8064   7120  88%    0.06K    126       64       504K kmalloc-64
  7636   7362  96%    0.17K    332       23      1328K anon_vma
  6120   6120 100%    0.02K     36      170       144K numa_policy
  5460   3729  68%    0.09K    130       42       520K kmalloc-96
  5120   5112  99%    0.02K     20      256        80K kmalloc-16
  4640   4202  90%    0.12K    145       32       580K kmalloc-128
  4375   3689  84%    0.31K    175       25      1400K filp
  4088   4088 100%    0.07K     73       56       292K Acpi-ParseExt
  3762   2295  61%    0.97K    114       33      3648K proc_inode_cache
  3402   2468  72%    0.19K    162       21       648K kmalloc-192
  3200   3200 100%    0.03K     25      128       100K kmalloc-32
  2208   2132  96%    0.25K     69       32       552K kmalloc-256
  1938   1938 100%    0.04K     19      102        76K Acpi-Namespace
  1840   1840 100%    0.09K     40       46       160K dm_io
  1682   1635  97%    1.08K     58       29      1856K shmem_inode

--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabtop7

 Active / Total Objects (% used)    : 1790221 / 1874456 (95.5%)
 Active / Total Slabs (% used)      : 109669 / 109669 (100.0%)
 Active / Total Caches (% used)     : 76 / 113 (67.3%)
 Active / Total Size (% used)       : 1672043.76K / 1713457.55K (97.6%)
 Minimum / Average / Maximum Object : 0.01K / 0.91K / 15.42K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
936914 886302  94%    0.36K  42587       22    340696K kmemleak_object
719405 711206  98%    1.84K  60910       17   1949120K jfs_ip
 39488  37147  94%    0.06K    617       64      2468K kmalloc-64
 23100  13526  58%    0.24K    700       33      5600K dentry
 20356  20356 100%    0.14K    727       28      2908K sysfs_dir_cache
 17087  13465  78%    0.55K    752       28     12032K radix_tree_node
 15594  14687  94%    0.17K    678       23      2712K vm_area_struct
 15300  13540  88%    0.05K    180       85       720K shared_policy_node
  8704   8662  99%    0.01K     17      512        68K kmalloc-8
  8120   7043  86%    0.91K    232       35      7424K inode_cache
  6630   6630 100%    0.02K     39      170       156K numa_policy
  6601   6120  92%    0.17K    287       23      1148K anon_vma
  5418   3651  67%    0.09K    129       42       516K kmalloc-96
  5120   5112  99%    0.02K     20      256        80K kmalloc-16
  4576   4369  95%    0.12K    143       32       572K kmalloc-128
  4375   3555  81%    0.31K    175       25      1400K filp
  4088   4088 100%    0.07K     73       56       292K Acpi-ParseExt
  3200   3200 100%    0.03K     25      128       100K kmalloc-32
  3150   2369  75%    0.19K    150       21       600K kmalloc-192
  2432   2312  95%    0.25K     76       32       608K kmalloc-256
  2270   2226  98%    0.97K    263       33      8416K proc_inode_cache
  1938   1938 100%    0.04K     19      102        76K Acpi-Namespace
  1855   1108  59%    0.23K     53       35       424K cfq_queue
  1682   1533  91%    1.08K     58       29      1856K shmem_inode_cache


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabtop8

 Active / Total Objects (% used)    : 1703655 / 2233647 (76.3%)
 Active / Total Slabs (% used)      : 146784 / 146784 (100.0%)
 Active / Total Caches (% used)     : 76 / 113 (67.3%)
 Active / Total Size (% used)       : 1638524.75K / 2009296.36K (81.5%)
 Minimum / Average / Maximum Object : 0.01K / 0.90K / 15.42K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
1227226 840256  68%    0.36K  55783       22    446264K kmemleak_object
826605 704690  85%    1.84K  85770       17   2744640K jfs_ip
 39270  39270 100%    0.24K   1190       33      9520K dentry
 20356  20356 100%    0.14K    727       28      2908K sysfs_dir_cache
 11277   6156  54%    0.55K    414       28      6624K radix_tree_node
 10880   9732  89%    0.06K    170       64       680K kmalloc-64
  9821   6811  69%    0.17K    427       23      1708K vm_area_struct
  8704   8662  99%    0.01K     17      512        68K kmalloc-8
  8670   5279  60%    0.05K    102       85       408K shared_policy_node
  8120   7016  86%    0.91K    232       35      7424K inode_cache
  5610   5610 100%    0.02K     33      170       132K numa_policy
  5120   5112  99%    0.02K     20      256        80K kmalloc-16
  5120   4487  87%    0.12K    160       32       640K kmalloc-128
  4088   4088 100%    0.07K     73       56       292K Acpi-ParseExt
  4000   2172  54%    0.31K    160       25      1280K filp
  3864   2781  71%    0.17K    168       23       672K anon_vma
  3486   2454  70%    0.09K     83       42       332K kmalloc-96
  3200   3200 100%    0.03K     25      128       100K kmalloc-32
  2856   2017  70%    0.19K    136       21       544K kmalloc-192
  2336   2230  95%    0.25K     73       32       584K kmalloc-256
  1938   1938 100%    0.04K     19      102        76K Acpi-Namespace
  1840   1840 100%    0.09K     40       46       160K dm_io
  1653   1396  84%    1.08K     57       29      1824K shmem_inode_cache
  1376   1240  90%    0.50K     43       32       688K kmalloc-512


--VbJkn9YxBvnuCH5J--
