Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2DNTeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 15:34:23 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:64697 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756063Ab2DNTeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 15:34:19 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1
 sticks-and-crashs)
To: David Rientjes <rientjes@google.com>, Colin Cross <ccross@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sat, 14 Apr 2012 15:38:16 -0400
Message-ID: <web-725985845@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps someone could check this

Ocasionally it still happens that the computer slows down 
very, during appr. 1 minute  (but it dont crash, nor is 
nothing visible in syslog).

I think this wasn't before approx. the 3.2 kernel, at 
least I didn't perceive it, but this happens at 3.3 and 
3.4-rc2-inclusive all patchs.

Below, ps alx   and   top   i printed in a file at an 
ocasion as this happened
I observed that then always kmemleak is almost at the 
beginning of top


wl



================= ps alx
F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY 
       TIME COMMAND
4     0     1     0  20   0    824   320 poll_s Ss   ? 
         0:35 init [4]
1     0     2     0  20   0      0     0 kthrea S    ? 
         0:01 [kthreadd]
1     0     3     2  20   0      0     0 run_ks S    ? 
         6:12 [ksoftirqd/0]
1     0     6     2 -100  -      0     0 cpu_st S    ? 
         0:00 [migration/0]
1     0     7     2 -100  -      0     0 watchd S    ? 
         0:05 [watchdog/0]
1     0     8     2   0 -20      0     0 rescue S<   ? 
         0:00 [khelper]
5     0     9     2  20   0      0     0 devtmp S    ? 
         0:00 [kdevtmpfs]
1     0    10     2   0 -20      0     0 rescue S<   ? 
         0:00 [netns]
1     0  1086     2  20   0      0     0 bdi_sy S    ? 
         0:00 [sync_supers]
1     0  1088     2  20   0      0     0 bdi_fo S    ? 
         0:00 [bdi-default]
1     0  1089     2   0 -20      0     0 rescue S<   ? 
         0:00 [kintegrityd]
1     0  1090     2   0 -20      0     0 rescue S<   ? 
         0:00 [kblockd]
5     0  1108     2 -51   -      0     0 irq_wa S    ? 
         0:00 [irq/9-acpi]
1     0  1236     2   0 -20      0     0 rescue S<   ? 
         0:00 [tifm]
1     0  1268     2   0 -20      0     0 rescue S<   ? 
         0:00 [ata_sff]
1     0  1280     2  20   0      0     0 hub_th S    ? 
         0:00 [khubd]
1     0  1295     2   0 -20      0     0 rescue S<   ? 
         0:00 [md]
1     0  1420     2   0 -20      0     0 rescue S<   ? 
         0:00 [rpciod]
1     0  1450     2  20   0      0     0 watchd S    ? 
         0:00 [khungtaskd]
1     0  1456     2  20   0      0     0 kswapd S    ? 
         0:02 [kswapd0]
1     0  1457     2  25   5      0     0 ksm_sc SN   ? 
         0:00 [ksmd]
1     0  1532     2  39  19      0     0 khugep SN   ? 
         0:06 [khugepaged]
1     0  1533     2  20   0      0     0 fsnoti S    ? 
         0:00 [fsnotify_mark]
1     0  1572     2  20   0      0     0 ecrypt S    ? 
         0:00 [ecryptfs-kthrea]
1     0  1575     2   0 -20      0     0 rescue S<   ? 
         0:00 [nfsiod]
1     0  1580     2   0 -20      0     0 rescue S<   ? 
         0:00 [cifsiod]
1     0  1606     2  20   0      0     0 jfsIOW S    ? 
         0:00 [jfsIO]
1     0  1607     2  20   0      0     0 jfs_la S    ? 
         0:00 [jfsCommit]
1     0  1608     2  20   0      0     0 jfs_sy S    ? 
         0:00 [jfsSync]
1     0  1615     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfsalloc]
1     0  1616     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfs_mru_cache]
1     0  1617     2   0 -20      0     0 rescue S<   ? 
         0:00 [xfslogd]
1     0  1624     2   0 -20      0     0 rescue S<   ? 
         0:00 [ocfs2_wq]
1     0  1627     2   0 -20      0     0 rescue S<   ? 
         0:00 [user_dlm]
1     0  1633     2   0 -20      0     0 rescue S<   ? 
         0:00 [glock_workqueue]
1     0  1634     2   0 -20      0     0 rescue S<   ? 
         0:00 [delete_workqueu]
1     0  1638     2   0 -20      0     0 rescue S<   ? 
         0:00 [gfs_recovery]
1     0  1642     2   0 -20      0     0 rescue S<   ? 
         0:00 [crypto]
1     0  1780     2  20   0      0     0 worker S    ? 
         0:00 [kworker/u:2]
1     0  2408     2  20   0      0     0 scan_t S    ? 
         0:00 [cciss_scan]
1     0  2542     2   0 -20      0     0 rescue S<   ? 
         0:00 [iscsi_eh]
1     0  2551     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpath_rdacd]
1     0  2552     2   0 -20      0     0 rescue S<   ? 
         0:00 [fc_exch_workque]
1     0  2553     2   0 -20      0     0 rescue S<   ? 
         0:00 [fc_rport_eq]
1     0  2554     2   0 -20      0     0 fcoe_p S<   ? 
         0:00 [fcoethread/0]
1     0  2556     2   0 -20      0     0 rescue S<   ? 
         0:00 [fnic_event_wq]
1     0  2558     2   0 -20      0     0 bnx2fc S<   ? 
         0:00 [bnx2fc_l2_threa]
1     0  2559     2   0 -20      0     0 bnx2fc S<   ? 
         0:00 [bnx2fc_thread/0]
1     0  2636     2   0 -20      0     0 bnx2i_ S<   ? 
         0:00 [bnx2i_thread/0]
1     0  2675     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_2]
1     0  2678     2  20   0      0     0 scsi_e S    ? 
         0:25 [scsi_eh_3]
1     0  2688     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_4]
1     0  2691     2  20   0      0     0 scsi_e S    ? 
         0:00 [scsi_eh_5]
1     0  2756     2   0 -20      0     0 rescue S<   ? 
         0:00 [smflush]
1     0  2771     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock0]
1     0  2784     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock1]
1     0  2793     2  20   0      0     0 mtd_bl S    ? 
         0:00 [mtdblock2]
1     0  2863     2   0 -20      0     0 rescue S<   ? 
         0:00 [cnic_wq]
1     0  2874     2   0 -20      0     0 rescue S<   ? 
         0:00 [sfc_vfdi]
1     0  2875     2   0 -20      0     0 rescue S<   ? 
         0:00 [sfc_reset]
1     0  2890     2   0 -20      0     0 rescue S<   ? 
         0:00 [exec-osm]
1     0  2897     2   0 -20      0     0 rescue S<   ? 
         0:00 [block-osm]
1     0  2905     2   0 -20      0     0 rescue S<   ? 
         0:00 [firewire]
1     0  2982     2   0 -20      0     0 rescue S<   ? 
         0:00 [wusbd]
1     0  3045     2   0 -20      0     0 rescue S<   ? 
         0:00 [kpsmoused]
1     0  3171     2   0 -20      0     0 rescue S<   ? 
         0:00 [dm_bufio_cache]
1     0  3172     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpathd]
1     0  3173     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmpath_handlerd]
1     0  3176     2   0 -20      0     0 rescue S<   ? 
         0:00 [edac-poller]
1     0  3188     2   0 -20      0     0 rescue S<   ? 
         0:00 [kvub300c]
1     0  3189     2   0 -20      0     0 rescue S<   ? 
         0:00 [kvub300p]
1     0  3190     2   0 -20      0     0 rescue S<   ? 
         0:00 [kvub300d]
1     0  3193     2   0 -20      0     0 rescue S<   ? 
         0:00 [kmemstick]
1     0  3260     2   0 -20      0     0 rescue S<   ? 
         0:00 [binder]
5     2  3416 11795  20   0  55952 12448 inet_c S    ? 
         0:00 /usr/local/apache2/bin/httpd -k restart
1     0  5534     2  30  10      0     0 -      RN   ? 
        90:25 [kmemleak]
1     0  5536     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafs_vlupdated]
1     0  5537     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafs_callbackd]
1     0  5538     2   0 -20      0     0 rescue S<   ? 
         0:00 [kafsd]
1     0  5541     2   0 -20      0     0 rescue S<   ? 
         0:00 [deferwq]
1     0  5546     2   0 -20      0     0 rescue S<   ? 
         0:00 [devfreq_wq]
1     0  5549     2  20   0      0     0 kjourn S    ? 
         0:54 [kjournald]
5     0  5577     1  16  -4   3124  1752 poll_s S<s  ? 
         0:04 /sbin/udevd --daemon
5     2  5950 11795  20   0  55908 12208 inet_c S    ? 
         0:07 /usr/local/apache2/bin/httpd -k restart
1     0  8011     2   0 -20      0     0 rescue S<   ? 
         0:00 [hd-audio0]
1     0  9620     2  20   0      0     0 bdi_wr S    ? 
         0:16 [flush-8:0]
1     0  9686     1  20   0   1928   664 poll_s Ss   ? 
         0:00 /usr/sbin/syslogd
5     0  9690     1  20   0   1880   428 syslog Ss   ? 
         0:00 /usr/sbin/klogd -c 3 -x
5     0  9904     1  20   0   1920   568 poll_s Ss   ? 
         0:00 /usr/sbin/inetd
1     0  9911     1  20   0   1876   560 poll_s Ss   ? 
         0:00 /usr/sbin/acpid
5    81  9922     1  20   0   2664   860 poll_s Ss   ? 
         0:00 /usr/bin/dbus-daemon --system
5    82  9927     1  20   0  15432  4544 poll_s Ssl  ? 
         0:01 /usr/sbin/hald --daemon=yes
0     0  9928  9927  20   0  11872  1256 poll_s Sl   ? 
         0:00 hald-runner
0     0  9950  9928  20   0   3800  1256 poll_s S    ? 
         0:02 hald-addon-input: Listening on 
/dev/input/event4 /dev/input/event0 /dev/input/event1 
/dev/input/event10 /dev/input/event2
0     0  9958  9928  20   0   3812  1076 poll_s S    ? 
         0:00 /usr/libexec/hald-addon-cpufreq
4    82  9959  9928  20   0   2572  1100 unix_s S    ? 
         0:00 hald-addon-acpi: listening on acpid socket 
/var/run/acpid.socket
0     0  9961  9928  20   0   3800  1076 poll_s S    ? 
         1:46 hald-addon-storage: polling /dev/hda (every 
2 sec)
0     0  9970  9928  20   0   3800  1076 poll_s S    ? 
         0:57 hald-addon-storage: polling /dev/sr0 (every 
2 sec)
5     0  9987     1  20   0   2536   932 poll_s Ss   ? 
         0:00 /usr/sbin/hcid -f /etc/bluetooth/hcid.conf
5     0  9991     1  20   0   1976   384 poll_s Ss   ? 
         0:00 /usr/sbin/sdpd
1     0 10003     1  20   0   2132   388 poll_s Ss   ? 
         0:00 /usr/bin/hidd --server
5     0 10008     2  10 -10      0     0 rfcomm S<   ? 
         0:00 [krfcommd]
4     0 10023     1  20   0   5832  2568 ep_pol Ss   ? 
         0:00 /usr/sbin/cupsd -C /etc/cups/cupsd.conf
1     0 10070     1  20   0   2096   712 hrtime S    ? 
         0:01 /usr/sbin/crond -l10
1     2 10072     1  20   0   2100   332 hrtime Ss   ? 
         0:00 /usr/sbin/atd -b 15 -l 1
1     0 10122     1  20   0   1864   304 hrtime Ss   ? 
         0:08 rkdet 1451
4     0 10131     1  20   0   3456  1960 wait   Ss   tty1 
      0:00 -bash
4     0 10132     1  20   0   3448  1952 wait   Ss   tty2 
      0:00 -bash
0     0 10133     1  20   0   1880   568 n_tty_ Ss+  tty3 
      0:00 /sbin/agetty 38400 tty3 linux
0     0 10134     1  20   0   1880   564 n_tty_ Ss+  tty4 
      0:00 /sbin/agetty 38400 tty4 linux
0     0 10135     1  20   0   1880   564 n_tty_ Ss+  tty5 
      0:00 /sbin/agetty 38400 tty5 linux
0     0 10136     1  20   0   1880   572 n_tty_ Ss+  tty6 
      0:00 /sbin/agetty 38400 tty6 linux
4     0 10137     1  20   0   3408   868 poll_s Ss   ? 
         0:00 /opt/kde/bin/kdm -nodaemon
4     0 10153 10137  20   0  54108 47384 poll_s Ss+  tty7 
     42:16 /usr/bin/X -br -nolisten tcp :0 vt7 -auth 
/var/run/xauth/A:0-EArqAj
1     0 10157 10137  20   0   3728  1196 wait   S    ? 
         0:00 -:0
4     0 10165 10157  20   0   3060  1500 wait   Ss   ? 
         0:00 /bin/sh /usr/bin/startkde
0     0 10183 10165  20   0  12404  1640 hrtime Sl   ? 
         8:54 /usr/bin/tpb
1     0 10219     1  20   0   1856    72 pipe_w S    ? 
         0:00 start_kdeinit --new-startup +kcminit_startup
1     0 10220     1  20   0  25160  7996 poll_s Ss   ? 
         0:01 kdeinit Running...
1     0 10223     1  20   0  24352  3216 poll_s S    ? 
         0:02 dcopserver [kdeinit] --nosid
5     0 10225 10220  20   0  29040  8412 poll_s S    ? 
         0:01 klauncher [kdeinit] --new-startup
1     0 10227     1  20   0  57396 32724 poll_s S    ? 
       256:52 kded [kdeinit] --new-startup
0     0 10234 10165  20   0   1860   272 hrtime S    ? 
         0:08 kwrapper ksmserver
1     0 10236     1  20   0  38976 22408 poll_s S    ? 
         0:00 ksmserver [kdeinit]
1     0 10237 10220  20   0  51880 27704 poll_s S    ? 
         0:42 kwin [kdeinit]
1     0 10239     1  20   0  48132 32020 poll_s S    ? 
         1:16 kdesktop [kdeinit]
1     0 10241     1  20   0  67968 44644 poll_s S    ? 
         1:25 kicker [kdeinit]
1     0 10248     1  20   0  38984 22168 poll_s S    ? 
         0:02 kaccess [kdeinit]
4     0 10256 10220  20   0 110796 43104 -      RLl  ? 
        31:15 artsd -F 9 -S 4096 -a alsa -b 8 -s 333 -m 
artsmessage -c drkonqi -l 3 -f
0     0 10260 10220  20   0  22420 10552 poll_s S    ? 
         0:00 nm-applet --sm-disable
1     0 10263     1  20   0  50312 25616 poll_s S    ? 
         0:10 knotify [kdeinit]
1     0 10271     1  20   0  26708  8832 poll_s S    ? 
         0:00 kalarmd --autostart
1     0 10275     1  20   0   3492   612 poll_s S    ? 
         0:00 dbus-launch --autolaunch 
9b9f86fbd8163bb39486a000475487ec --binary-syntax 
--close-stderr
1     0 10276     1  20   0   2520   748 poll_s Ss   ? 
         0:00 /usr/bin/dbus-daemon --fork --print-pid 5 
--print-address 7 --session
0     0 10278     1  20   0  31868 20800 poll_s S    ? 
         0:00 /usr/libexec/xfce4-notifyd
0     0 10280     1  20   0   4008  1788 poll_s S    ? 
         0:00 /usr/libexec/xfconfd
0     0 10286     1  20   0   5196  2824 poll_s S    ? 
         0:16 /usr/libexec/gconfd-2
5     2 10564 11795  20   0  56168 12740 inet_c S    ? 
         0:08 /usr/local/apache2/bin/httpd -k restart
5     0 10767     1  20   0  41376 12284 rt_sig Ssl  ? 
         0:00 named -d 5
0     0 11707     1  20   0   3072  1508 wait   S    ? 
         0:00 /bin/sh /usr/bin/mysqld_safe --user=root
4     0 11755 11707  20   0 103672 21484 poll_s Sl   ? 
         0:59 /usr/sbin/mysqld --basedir=/ --datadir=//var 
--user=root --pid-file=//var/werner.pid 
--log-error=//var/werner.err
5     0 11785     1  20   0   6904  2112 poll_s Ss   ? 
         0:12 sendmail: accepting connections
1     0 11786     1  20   0   6292  2768 poll_s S    ? 
         0:09 /usr/local/src/Unreal3.2/src/ircd
1     0 11795     1  20   0  53056  8876 poll_s Ss   ? 
         0:06 /usr/local/apache2/bin/httpd -k restart
5     2 11802 11795  20   0  55716 12324 inet_c S    ? 
         0:11 /usr/local/apache2/bin/httpd -k restart
5     0 11812     1  20   0   5900   980 poll_s Ss   ? 
         0:00 pure-ftpd (SERVER)
5     0 11825     1  20   0   3428   640 poll_s Ss   ? 
         0:00 rsync -v --daemon
1     0 11835     1  20   0   7608  5348 poll_s Ss   ? 
         0:05 /usr/local/bin/perl 
/usr/local/src/webmin/miniserv.pl 
/etc/webmin/miniserv.conf
1     0 11843     1  20   0   7216  5136 poll_s Ss   ? 
         0:06 /usr/local/bin/perl 
/usr/local/src/usermin/miniserv.pl 
/etc/usermin/miniserv.conf
5     2 17040 11795  20   0  55924 12480 inet_c S    ? 
         0:06 /usr/local/apache2/bin/httpd -k restart
1     0 20831     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:0]
1     0 21950 10220  20   0  26424  8332 poll_s S    ? 
         0:00 kio_file [kdeinit] file 
/tmp/ksocket-root/klauncherEGAF1a.
1     0 22463     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:2]
0     0 22802 10131  20   0   2624  1132 poll_s S+   tty1 
      0:05 top
4     0 24935 10220  20   0   6088  2676 poll_s S    ? 
         0:00 mrxvt
0     0 24936 24935  20   0   3396  1776 wait   Ss   pts/2 
     0:00 bash
0     0 24974 24936  20   0   2620  1196 poll_s S+   pts/2 
     0:02 top
1     0 25574     2  20   0      0     0 worker S    ? 
         0:00 [kworker/0:1]
0     0 26483 10132  20   0   2528   584 -      R+   tty2 
      0:00 ps alx
1     0 29868     2  20   0      0     0 worker S    ? 
         0:00 [kworker/u:0]
5     0 30236 10220  20   0  54416 38756 poll_s S    ? 
         0:04 konqueror [kdeinit] /
5     2 30420 11795  20   0  55664 12216 inet_c S    ? 
         0:05 /usr/local/apache2/bin/httpd -k restart
5     2 30590 11795  20   0  55672 12160 inet_c S    ? 
         0:04 /usr/local/apache2/bin/httpd -k restart
5     2 30596 11795  20   0  56228 12584 inet_c S    ? 
         0:05 /usr/local/apache2/bin/httpd -k restart
5     2 30597 11795  20   0  56404 12960 inet_c S    ? 
         0:05 /usr/local/apache2/bin/httpd -k restart
1     0 31140     1  20   0  41172 25692 poll_s S    ? 
         0:01 kio_uiserver [kdeinit]
5     2 31540 11795  20   0  55372 11884 inet_c S    ? 
         0:06 /usr/local/apache2/bin/httpd -k restart
4     0 31801 10220  20   0 591224 345664 -     Rl   ? 
       158:02 /usr/lib/firefox/firefox-bin

================= top

[H[J[0;10mtop - 16:20:01 up 2 days, 16:51,  5 users, 
 load average: 2.18, 1.54, 1.11[0;10m[39;49m[K
Tasks:[0;10m[39;49m[0;10m 168 
[0;10m[39;49mtotal,[0;10m[39;49m[0;10m   3 
[0;10m[39;49mrunning,[0;10m[39;49m[0;10m 165 
[0;10m[39;49msleeping,[0;10m[39;49m[0;10m   0 
[0;10m[39;49mstopped,[0;10m[39;49m[0;10m   0 
[0;10m[39;49mzombie[0;10m[39;49m[K
Cpu(s):[0;10m[39;49m[0;10m 
 9.7%[0;10m[39;49mus,[0;10m[39;49m[0;10m 
12.5%[0;10m[39;49msy,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mni,[0;10m[39;49m[0;10m 
76.7%[0;10m[39;49mid,[0;10m[39;49m[0;10m 
 1.0%[0;10m[39;49mwa,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mhi,[0;10m[39;49m[0;10m 
 0.1%[0;10m[39;49msi,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mst[0;10m[39;49m[K
Mem: [0;10m[39;49m[0;10m  3088984k 
[0;10m[39;49mtotal,[0;10m[39;49m[0;10m  2861284k 
[0;10m[39;49mused,[0;10m[39;49m[0;10m   227700k 
[0;10m[39;49mfree,[0;10m[39;49m[0;10m   286872k 
[0;10m[39;49mbuffers[0;10m[39;49m[K
Swap:[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mtotal,[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mused,[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mfree,[0;10m[39;49m[0;10m  1780732k 
[0;10m[39;49mcached[0;10m[39;49m[K
[6;1H
[7m  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM 
   TIME+  COMMAND 
                                                            
                                                            
                     [0;10m[39;49m[K
[0;10m[0;10m31801 root      20   0  577m 337m  48m R 
66.9 11.2 158:27.70 firefox-bin 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m10227 root      20   0 57396  31m  27m S 12.7  1.1 
256:54.85 kded 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m[0;10m 5534 root      30  10     0    0    0 R 
 9.0  0.0  90:28.34 kmemleak 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m10256 root      20   0 94484  42m 7548 S  3.6  1.4 
 31:16.69 artsd 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m[0;10m26642 root      20   0  2620 1116  812 R 
 1.8  0.0   0:00.03 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m    1 root      20   0   824  320  280 S  0.0  0.0 
  0:35.88 init 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m    2 root      20   0     0    0    0 S  0.0  0.0 
  0:01.19 kthreadd 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m    3 root      20   0     0    0    0 S  0.0  0.0 
  6:12.80 ksoftirqd/0 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m    6 root      RT   0     0    0    0 S  0.0  0.0 
  0:00.00 migration/0 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m    7 root      RT   0     0    0    0 S  0.0  0.0 
  0:05.35 watchdog/0 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m    8 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 khelper 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m    9 root      20   0     0    0    0 S  0.0  0.0 
  0:00.03 kdevtmpfs 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m   10 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 netns 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1086 root      20   0     0    0    0 S  0.0  0.0 
  0:00.47 sync_supers 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1088 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 bdi-default 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1089 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kintegrityd 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1090 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kblockd 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1108 root     -51   0     0    0    0 S  0.0  0.0 
  0:00.00 irq/9-acpi 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1236 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 tifm 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m 1268 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 ata_sff 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1280 root      20   0     0    0    0 S  0.0  0.0 
  0:00.04 khubd 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1295 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 md 
                                                            
                                                            
                          [0;10m[39;49m
[0;10m 1420 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 rpciod 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1450 root      20   0     0    0    0 S  0.0  0.0 
  0:00.03 khungtaskd 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1456 root      20   0     0    0    0 S  0.0  0.0 
  0:02.47 kswapd0 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1457 root      25   5     0    0    0 S  0.0  0.0 
  0:00.00 ksmd 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m 1532 root      39  19     0    0    0 S  0.0  0.0 
  0:06.17 khugepaged 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1533 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 fsnotify_mark 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 1572 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 ecryptfs-kthrea 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1575 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 nfsiod 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1580 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 cifsiod 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1606 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsIO 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1607 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsCommit 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m 1608 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsSync 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1615 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfsalloc 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1616 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfs_mru_cache 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 1617 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfslogd 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1624 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 ocfs2_wq 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1627 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 user_dlm 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1633 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 glock_workqueue 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1634 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 delete_workqueu 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1638 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 gfs_recovery 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 1642 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 crypto 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1780 root      20   0     0    0    0 S  0.0  0.0 
  0:00.23 kworker/u:2 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 2408 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 cciss_scan 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 2542 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 iscsi_eh 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 2551 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kmpath_rdacd 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 2552 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fc_exch_workque 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2553 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fc_rport_eq 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 2554 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fcoethread/0 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 2556 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fnic_event_wq 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 2558 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2fc_l2_threa 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2559 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2fc_thread/0 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2636 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2i_thread/0 
                                                            
                                                            
              [0;10m[39;49m
[0;10m 2675 root      20   0     0    0    0 S  0.0  0.0 
  0:00.39 scsi_eh_2 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m 2678 root      20   0     0    0    0 S  0.0  0.0 
  0:25.28 scsi_eh_3 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m 2688 root      20   0     0    0    0 S  0.0  0.0 
  0:00.02 scsi_eh_4 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m 2691 root      20   0     0    0    0 S  0.0  0.0 
  0:00.33 scsi_eh_5 
                                                            
                                                            
                   [0;10m[39;49m[6;1H[K[H[0;10mtop - 
16:20:04 up 2 days, 16:51,  5 users,  load average: 2.16, 
1.55, 1.11[0;10m[39;49m[K

Cpu(s):[0;10m[39;49m[0;10m 
77.0%[0;10m[39;49mus,[0;10m[39;49m[0;10m 
23.0%[0;10m[39;49msy,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mni,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mid,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mwa,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mhi,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49msi,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mst[0;10m[39;49m[K
Mem: [0;10m[39;49m[0;10m  3088984k 
[0;10m[39;49mtotal,[0;10m[39;49m[0;10m  2861540k 
[0;10m[39;49mused,[0;10m[39;49m[0;10m   227444k 
[0;10m[39;49mfree,[0;10m[39;49m[0;10m   286872k 
[0;10m[39;49mbuffers[0;10m[39;49m[K
Swap:[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mtotal,[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mused,[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mfree,[0;10m[39;49m[0;10m  1780748k 
[0;10m[39;49mcached[0;10m[39;49m[K
[6;1H

[0;10m[0;10m31801 root      20   0  577m 337m  48m R 
75.1 11.2 158:29.99 firefox-bin 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m[0;10m 5534 root      30  10     0    0    0 R 
 9.5  0.0  90:28.63 kmemleak 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m10227 root      20   0 57396  31m  27m S  6.2  1.1 
256:55.04 kded 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m10256 root      20   0 94484  42m 7548 S  3.6  1.4 
 31:16.80 artsd 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m22802 root      20   0  2624 1132  828 S  1.0  0.0 
  0:05.91 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m[0;10m26642 root      20   0  2624 1132  828 R 
 1.0  0.0   0:00.06 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m24974 root      20   0  2620 1196  896 S  0.7  0.0 
  0:02.40 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m    3 root      20   0     0    0    0 S  0.3  0.0 
  6:12.81 ksoftirqd/0 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m24935 root      20   0  6088 2676 1848 S  0.3  0.1 
  0:00.63 mrxvt 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m    1 root      20   0   824  320  280 S  0.0  0.0 
  0:35.88 init 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m    2 root      20   0     0    0    0 S  0.0  0.0 
  0:01.19 kthreadd 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m    6 root      RT   0     0    0    0 S  0.0  0.0 
  0:00.00 migration/0 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m    7 root      RT   0     0    0    0 S  0.0  0.0 
  0:05.35 watchdog/0 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m    8 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 khelper 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m    9 root      20   0     0    0    0 S  0.0  0.0 
  0:00.03 kdevtmpfs 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m   10 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 netns 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1086 root      20   0     0    0    0 S  0.0  0.0 
  0:00.47 sync_supers 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1088 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 bdi-default 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1089 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kintegrityd 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1090 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kblockd 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1108 root     -51   0     0    0    0 S  0.0  0.0 
  0:00.00 irq/9-acpi 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1236 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 tifm 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m 1268 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 ata_sff 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1280 root      20   0     0    0    0 S  0.0  0.0 
  0:00.04 khubd 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1295 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 md 
                                                            
                                                            
                          [0;10m[39;49m
[0;10m 1420 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 rpciod 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1450 root      20   0     0    0    0 S  0.0  0.0 
  0:00.03 khungtaskd 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1456 root      20   0     0    0    0 S  0.0  0.0 
  0:02.47 kswapd0 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1457 root      25   5     0    0    0 S  0.0  0.0 
  0:00.00 ksmd 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m 1532 root      39  19     0    0    0 S  0.0  0.0 
  0:06.17 khugepaged 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1533 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 fsnotify_mark 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 1572 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 ecryptfs-kthrea 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1575 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 nfsiod 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1580 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 cifsiod 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1606 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsIO 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1607 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsCommit 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m 1608 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsSync 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1615 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfsalloc 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1616 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfs_mru_cache 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 1617 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfslogd 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1624 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 ocfs2_wq 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1627 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 user_dlm 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1633 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 glock_workqueue 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1634 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 delete_workqueu 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1638 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 gfs_recovery 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 1642 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 crypto 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1780 root      20   0     0    0    0 S  0.0  0.0 
  0:00.23 kworker/u:2 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 2408 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 cciss_scan 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 2542 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 iscsi_eh 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 2551 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kmpath_rdacd 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 2552 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fc_exch_workque 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2553 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fc_rport_eq 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 2554 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fcoethread/0 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 2556 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fnic_event_wq 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 2558 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2fc_l2_threa 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2559 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2fc_thread/0 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2636 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2i_thread/0 
                                                            
                                                            
              [0;10m[39;49m
[0;10m 2675 root      20   0     0    0    0 S  0.0  0.0 
  0:00.39 scsi_eh_2 
                                                            
                                                            
                   [0;10m[39;49m[6;1H[K[H[0;10mtop - 
16:20:07 up 2 days, 16:51,  5 users,  load average: 2.15, 
1.55, 1.12[0;10m[39;49m[K

Cpu(s):[0;10m[39;49m[0;10m 
77.6%[0;10m[39;49mus,[0;10m[39;49m[0;10m 
22.4%[0;10m[39;49msy,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mni,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mid,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mwa,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mhi,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49msi,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mst[0;10m[39;49m[K
Mem: [0;10m[39;49m[0;10m  3088984k 
[0;10m[39;49mtotal,[0;10m[39;49m[0;10m  2861540k 
[0;10m[39;49mused,[0;10m[39;49m[0;10m   227444k 
[0;10m[39;49mfree,[0;10m[39;49m[0;10m   286872k 
[0;10m[39;49mbuffers[0;10m[39;49m[K
Swap:[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mtotal,[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mused,[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mfree,[0;10m[39;49m[0;10m  1780768k 
[0;10m[39;49mcached[0;10m[39;49m[K
[6;1H

[0;10m[0;10m31801 root      20   0  577m 337m  48m R 
75.8 11.2 158:32.30 firefox-bin 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m[0;10m 5534 root      30  10     0    0    0 R 
 9.5  0.0  90:28.92 kmemleak 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m10227 root      20   0 57396  31m  27m S  5.9  1.1 
256:55.22 kded 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m10256 root      20   0 94484  42m 7548 S  3.3  1.4 
 31:16.90 artsd 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m24974 root      20   0  2620 1196  896 S  1.0  0.0 
  0:02.43 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m22802 root      20   0  2624 1132  828 S  0.7  0.0 
  0:05.93 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m24935 root      20   0  6088 2676 1848 S  0.7  0.1 
  0:00.65 mrxvt 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m[0;10m26642 root      20   0  2624 1132  828 R 
 0.7  0.0   0:00.08 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m 5549 root      20   0     0    0    0 S  0.3  0.0 
  0:54.85 kjournald 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m10183 root      20   0 12404 1640 1328 S  0.3  0.1 
  8:54.40 tpb 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m    1 root      20   0   824  320  280 S  0.0  0.0 
  0:35.88 init 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m    2 root      20   0     0    0    0 S  0.0  0.0 
  0:01.19 kthreadd 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m    3 root      20   0     0    0    0 S  0.0  0.0 
  6:12.81 ksoftirqd/0 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m    6 root      RT   0     0    0    0 S  0.0  0.0 
  0:00.00 migration/0 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m    7 root      RT   0     0    0    0 S  0.0  0.0 
  0:05.35 watchdog/0 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m    8 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 khelper 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m    9 root      20   0     0    0    0 S  0.0  0.0 
  0:00.03 kdevtmpfs 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m   10 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 netns 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1086 root      20   0     0    0    0 S  0.0  0.0 
  0:00.47 sync_supers 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1088 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 bdi-default 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1089 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kintegrityd 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1090 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kblockd 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1108 root     -51   0     0    0    0 S  0.0  0.0 
  0:00.00 irq/9-acpi 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1236 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 tifm 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m 1268 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 ata_sff 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1280 root      20   0     0    0    0 S  0.0  0.0 
  0:00.04 khubd 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1295 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 md 
                                                            
                                                            
                          [0;10m[39;49m
[0;10m 1420 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 rpciod 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1450 root      20   0     0    0    0 S  0.0  0.0 
  0:00.03 khungtaskd 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1456 root      20   0     0    0    0 S  0.0  0.0 
  0:02.47 kswapd0 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1457 root      25   5     0    0    0 S  0.0  0.0 
  0:00.00 ksmd 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m 1532 root      39  19     0    0    0 S  0.0  0.0 
  0:06.17 khugepaged 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1533 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 fsnotify_mark 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 1572 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 ecryptfs-kthrea 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1575 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 nfsiod 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1580 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 cifsiod 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1606 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsIO 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1607 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsCommit 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m 1608 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsSync 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1615 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfsalloc 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1616 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfs_mru_cache 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 1617 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfslogd 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1624 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 ocfs2_wq 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1627 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 user_dlm 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1633 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 glock_workqueue 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1634 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 delete_workqueu 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1638 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 gfs_recovery 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 1642 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 crypto 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1780 root      20   0     0    0    0 S  0.0  0.0 
  0:00.23 kworker/u:2 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 2408 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 cciss_scan 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 2542 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 iscsi_eh 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 2551 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kmpath_rdacd 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 2552 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fc_exch_workque 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2553 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fc_rport_eq 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 2554 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fcoethread/0 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 2556 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fnic_event_wq 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 2558 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2fc_l2_threa 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2559 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2fc_thread/0 
                                                            
                                                            
             [0;10m[39;49m[6;1H[K[H[0;10mtop - 
16:20:10 up 2 days, 16:52,  5 users,  load average: 2.15, 
1.55, 1.12[0;10m[39;49m[K

Cpu(s):[0;10m[39;49m[0;10m 
77.1%[0;10m[39;49mus,[0;10m[39;49m[0;10m 
22.5%[0;10m[39;49msy,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mni,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mid,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mwa,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mhi,[0;10m[39;49m[0;10m 
 0.3%[0;10m[39;49msi,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mst[0;10m[39;49m[K
Mem: [0;10m[39;49m[0;10m  3088984k 
[0;10m[39;49mtotal,[0;10m[39;49m[0;10m  2861540k 
[0;10m[39;49mused,[0;10m[39;49m[0;10m   227444k 
[0;10m[39;49mfree,[0;10m[39;49m[0;10m   286872k 
[0;10m[39;49mbuffers[0;10m[39;49m[K
Swap:[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mtotal,[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mused,[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mfree,[0;10m[39;49m[0;10m  1780780k 
[0;10m[39;49mcached[0;10m[39;49m[K
[6;1H

[0;10m[0;10m31801 root      20   0  577m 337m  48m R 
75.5 11.2 158:34.60 firefox-bin 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m[0;10m 5534 root      30  10     0    0    0 R 
 9.2  0.0  90:29.20 kmemleak 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m10227 root      20   0 57396  31m  27m S  6.2  1.1 
256:55.41 kded 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m10256 root      20   0 94484  42m 7548 S  3.6  1.4 
 31:17.01 artsd 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m22802 root      20   0  2624 1132  828 S  0.7  0.0 
  0:05.95 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m24974 root      20   0  2620 1196  896 S  0.7  0.0 
  0:02.45 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m[0;10m26642 root      20   0  2624 1132  828 R 
 0.7  0.0   0:00.10 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m    3 root      20   0     0    0    0 S  0.3  0.0 
  6:12.82 ksoftirqd/0 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 9961 root      20   0  3800 1076  920 S  0.3  0.0 
  1:46.57 hald-addon-stor 
                                                            
                                                            
             [0;10m[39;49m
[0;10m10183 root      20   0 12404 1640 1328 S  0.3  0.1 
  8:54.41 tpb 
                                                            
                                                            
                         [0;10m[39;49m


[0;10m    6 root      RT   0     0    0    0 S  0.0  0.0 
  0:00.00 migration/0 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m    7 root      RT   0     0    0    0 S  0.0  0.0 
  0:05.35 watchdog/0 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m    8 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 khelper 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m    9 root      20   0     0    0    0 S  0.0  0.0 
  0:00.03 kdevtmpfs 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m   10 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 netns 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1086 root      20   0     0    0    0 S  0.0  0.0 
  0:00.47 sync_supers 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1088 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 bdi-default 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1089 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kintegrityd 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1090 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kblockd 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1108 root     -51   0     0    0    0 S  0.0  0.0 
  0:00.00 irq/9-acpi 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1236 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 tifm 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m 1268 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 ata_sff 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1280 root      20   0     0    0    0 S  0.0  0.0 
  0:00.04 khubd 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1295 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 md 
                                                            
                                                            
                          [0;10m[39;49m
[0;10m 1420 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 rpciod 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1450 root      20   0     0    0    0 S  0.0  0.0 
  0:00.03 khungtaskd 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1456 root      20   0     0    0    0 S  0.0  0.0 
  0:02.47 kswapd0 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1457 root      25   5     0    0    0 S  0.0  0.0 
  0:00.00 ksmd 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m 1532 root      39  19     0    0    0 S  0.0  0.0 
  0:06.17 khugepaged 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1533 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 fsnotify_mark 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 1572 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 ecryptfs-kthrea 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1575 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 nfsiod 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1580 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 cifsiod 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1606 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsIO 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1607 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsCommit 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m 1608 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsSync 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1615 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfsalloc 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1616 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfs_mru_cache 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 1617 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfslogd 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1624 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 ocfs2_wq 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1627 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 user_dlm 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1633 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 glock_workqueue 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1634 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 delete_workqueu 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1638 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 gfs_recovery 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 1642 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 crypto 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1780 root      20   0     0    0    0 S  0.0  0.0 
  0:00.23 kworker/u:2 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 2408 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 cciss_scan 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 2542 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 iscsi_eh 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 2551 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kmpath_rdacd 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 2552 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fc_exch_workque 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2553 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fc_rport_eq 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 2554 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fcoethread/0 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 2556 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fnic_event_wq 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 2558 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2fc_l2_threa 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2559 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2fc_thread/0 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2636 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2i_thread/0 
                                                            
                                                            
              [0;10m[39;49m[6;1H[K[H[0;10mtop - 
16:20:14 up 2 days, 16:52,  5 users,  load average: 2.14, 
1.56, 1.12[0;10m[39;49m[K

Cpu(s):[0;10m[39;49m[0;10m 
77.7%[0;10m[39;49mus,[0;10m[39;49m[0;10m 
22.3%[0;10m[39;49msy,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mni,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mid,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mwa,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mhi,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49msi,[0;10m[39;49m[0;10m 
 0.0%[0;10m[39;49mst[0;10m[39;49m[K
Mem: [0;10m[39;49m[0;10m  3088984k 
[0;10m[39;49mtotal,[0;10m[39;49m[0;10m  2861540k 
[0;10m[39;49mused,[0;10m[39;49m[0;10m   227444k 
[0;10m[39;49mfree,[0;10m[39;49m[0;10m   286876k 
[0;10m[39;49mbuffers[0;10m[39;49m[K
Swap:[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mtotal,[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mused,[0;10m[39;49m[0;10m        0k 
[0;10m[39;49mfree,[0;10m[39;49m[0;10m  1780796k 
[0;10m[39;49mcached[0;10m[39;49m[K
[6;1H

[0;10m[0;10m31801 root      20   0  577m 337m  48m R 
75.7 11.2 158:36.91 firefox-bin 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m[0;10m 5534 root      30  10     0    0    0 R 
 9.5  0.0  90:29.49 kmemleak 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m10227 root      20   0 57396  31m  27m S  6.2  1.1 
256:55.60 kded 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m10256 root      20   0 94484  42m 7548 S  3.6  1.4 
 31:17.12 artsd 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m22802 root      20   0  2624 1132  828 S  1.3  0.0 
  0:05.99 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m[0;10m26642 root      20   0  2624 1132  828 R 
 1.0  0.0   0:00.13 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m24974 root      20   0  2620 1196  896 S  0.7  0.0 
  0:02.47 top 
                                                            
                                                            
                         [0;10m[39;49m
[0;10m24935 root      20   0  6088 2676 1848 S  0.3  0.1 
  0:00.66 mrxvt 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m    1 root      20   0   824  320  280 S  0.0  0.0 
  0:35.88 init 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m    2 root      20   0     0    0    0 S  0.0  0.0 
  0:01.19 kthreadd 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m    3 root      20   0     0    0    0 S  0.0  0.0 
  6:12.82 ksoftirqd/0 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m    6 root      RT   0     0    0    0 S  0.0  0.0 
  0:00.00 migration/0 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m    7 root      RT   0     0    0    0 S  0.0  0.0 
  0:05.35 watchdog/0 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m    8 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 khelper 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m    9 root      20   0     0    0    0 S  0.0  0.0 
  0:00.03 kdevtmpfs 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m   10 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 netns 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1086 root      20   0     0    0    0 S  0.0  0.0 
  0:00.47 sync_supers 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1088 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 bdi-default 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1089 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kintegrityd 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 1090 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kblockd 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1108 root     -51   0     0    0    0 S  0.0  0.0 
  0:00.00 irq/9-acpi 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1236 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 tifm 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m 1268 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 ata_sff 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1280 root      20   0     0    0    0 S  0.0  0.0 
  0:00.04 khubd 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1295 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 md 
                                                            
                                                            
                          [0;10m[39;49m
[0;10m 1420 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 rpciod 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1450 root      20   0     0    0    0 S  0.0  0.0 
  0:00.03 khungtaskd 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1456 root      20   0     0    0    0 S  0.0  0.0 
  0:02.47 kswapd0 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1457 root      25   5     0    0    0 S  0.0  0.0 
  0:00.00 ksmd 
                                                            
                                                            
                        [0;10m[39;49m
[0;10m 1532 root      39  19     0    0    0 S  0.0  0.0 
  0:06.17 khugepaged 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 1533 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 fsnotify_mark 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 1572 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 ecryptfs-kthrea 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1575 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 nfsiod 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1580 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 cifsiod 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1606 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsIO 
                                                            
                                                            
                       [0;10m[39;49m
[0;10m 1607 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsCommit 
                                                            
                                                            
                   [0;10m[39;49m
[0;10m 1608 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 jfsSync 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1615 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfsalloc 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1616 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfs_mru_cache 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 1617 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 xfslogd 
                                                            
                                                            
                     [0;10m[39;49m
[0;10m 1624 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 ocfs2_wq 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1627 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 user_dlm 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 1633 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 glock_workqueue 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1634 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 delete_workqueu 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 1638 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 gfs_recovery 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 1642 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 crypto 
                                                            
                                                            
                      [0;10m[39;49m
[0;10m 1780 root      20   0     0    0    0 S  0.0  0.0 
  0:00.23 kworker/u:2 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 2408 root      20   0     0    0    0 S  0.0  0.0 
  0:00.00 cciss_scan 
                                                            
                                                            
                  [0;10m[39;49m
[0;10m 2542 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 iscsi_eh 
                                                            
                                                            
                    [0;10m[39;49m
[0;10m 2551 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 kmpath_rdacd 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 2552 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fc_exch_workque 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2553 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fc_rport_eq 
                                                            
                                                            
                 [0;10m[39;49m
[0;10m 2554 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fcoethread/0 
                                                            
                                                            
                [0;10m[39;49m
[0;10m 2556 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 fnic_event_wq 
                                                            
                                                            
               [0;10m[39;49m
[0;10m 2558 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2fc_l2_threa 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2559 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2fc_thread/0 
                                                            
                                                            
             [0;10m[39;49m
[0;10m 2636 root       0 -20     0    0    0 S  0.0  0.0 
  0:00.00 bnx2i_thread/0 
                                                            
                                                            
              [0;10m[39;49m
[0;10m 2675 root      20   0     0    0    0 S  0.0  0.0 
  0:00.39 scsi_eh_2 
                                                            
                                                            
                   [0;10m[39;49m[6;1H[K[66;1H[?25h[?0c


---
Professional hosting for everyone - http://www.host.ru
