Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934404Ab1KCSqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 14:46:42 -0400
Received: from nm20-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.180]:41920 "HELO
	nm20-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933609Ab1KCSql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 14:46:41 -0400
X-Yahoo-Newman-Id: 266437.99022.bm@smtp216.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: DLc2KokVM1na7qEW2DOrd5x_l2QXBCx7aO8KZhCSm6kW9JA
 aZGoJgo_jIRHHMlxe9sdNWTeIkSG.YRNpIsAggtHlKmG0d3hNqGAZfF10HN3
 U0iyoJjJN2wEPpHgWLpLuCun.1f2EatMZj0i8rThLm.wIxPGaYvcW_Vw4zei
 JyzZuoKzYFR4jmjzFwgrAlXH8FaFZ03hOcU6oZOCcSYDC28HA.thvzhP7eYs
 Pph4FUjJ_ntxaPlOUZYMXeerelPu5.5v55O9grcGZoGpmY4X8s.8W5sMOrSG
 1AZTqNTjwZQcHs2SbR5exZ0GXlrm39TPVYHHIUFTXzxdAHqQxbN2yeULcBCh
 YhTv3g8Fc4z7BsICQ5K.PAo63zXZMuPwy1sGSMVUFa_ME_u4CHQt83IMolPa
 aoh9VnuNi96BhlY2PUQ_W2kA4Cg--
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Thu, 3 Nov 2011 13:46:19 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111103184559.GA3295@zeus>
References: <20111101124759.GA1326@zeus>
 <20111102054658.GA29035@core.coreip.homeip.net>
 <20111102160208.GA6657@zeus>
 <20111102163109.GA29430@core.coreip.homeip.net>
 <20111103155956.GG4417@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103155956.GG4417@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 08:59:56AM -0700, Tejun Heo wrote:
> Andrew, just in case, can you please double check that you're
> reverting only that single commit (not all the ones afterwards) and
> the test results?  If they're all okay, can you please trigger the
> problem, wait a while, trigger sysrq-t and attach the kernel log?

Hi Tejun.

I am only reverting 8ee294cd9def0004887da7f44b80563493b0a097 though I first
revert part of 1d64b655dc083df5c5ac39945ccbbc6532903bf1 so it reverts 
cleanly. 

I am very sure of my test results; normally I get 4-5 bad resumes on a 20
hibernate loop and get no bad resumes with the commit reverted. I have
been very thorough in my testing to ensure I am not generating false
positives or false negatives (repeating the loops many times).

Below is the output you asked for (sysrq t).

Thanks.

~ Andy

======================


kernel: [  345.226523] SysRq : Show State
kernel: [  345.226531]   task                PC stack   pid father
kernel: [  345.226535] init            S f4a47b68  5488     1      0 0x00000000
kernel: [  345.226765] kthreadd        S 00000000  7172     2      0 0x00000000
kernel: [  345.226819] ksoftirqd/0     S 0000003f  7472     3      2 0x00000000
kernel: [  345.226887] kworker/u:0     S 00000000  6404     5      2 0x00000000
kernel: [  345.226956] rcu_kthread     S c10ce899  7324     6      2 0x00000000
kernel: [  345.227032] watchdog/0      S 0000000b  7616     7      2 0x00000000
kernel: [  345.227096] cpuset          S f5c55f58  7696     8      2 0x00000000
kernel: [  345.227160] khelper         S f5c57f58  7696     9      2 0x00000000
kernel: [  345.227224] kworker/u:1     S 00000000  5800    10      2 0x00000000
kernel: [  345.227284] netns           S f5c69f58  7660    13      2 0x00000000
kernel: [  345.227348] sync_supers     S f5ca5fbc  7712   227      2 0x00000000
kernel: [  345.227425] bdi-default     S f5ca7e70  7392   229      2 0x00000000
kernel: [  345.227507] kblockd         S f5cd7f58  7660   231      2 0x00000000
kernel: [  345.227509] ata_sff         S f5cf1f58  7660   318      2 0x00000000
kernel: [  345.227509] khubd           S c13f0020  5844   328      2 0x00000000
kernel: [  345.227509] md              S f5ce1f58  7660   335      2 0x00000000
kernel: [  345.227509] cfg80211        S f5cfdf58  7660   345      2 0x00000000
kernel: [  345.227509] kworker/0:1     S f49ae800  6248   346      2 0x00000000
kernel: [  345.227509] rpciod          S f5ce5f58  7660   444      2 0x00000000
kernel: [  345.227509] khungtaskd      S 00000000  7564   461      2 0x00000000
kernel: [  345.227509] kswapd0         S f5d25ea8  7444   467      2 0x00000000
kernel: [  345.227509] fsnotify_mark   S 00000000  7668   532      2 0x00000000
kernel: [  345.227509] nfsiod          S f5f05f58  7660   544      2 0x00000000
kernel: [  345.227509] crypto          S f5f19f58  7660   549      2 0x00000000
kernel: [  345.227509] ttm_swap        S f5f13f58  7660   628      2 0x00000000
kernel: [  345.227509] kworker/0:2     S 000ce000  6776   768      2 0x00000000
kernel: [  345.227509] kpsmoused       S f577ff58  7660   776      2 0x00000000
kernel: [  345.227509] kjournald       S 0000004f  6524   834      2 0x00000000
kernel: [  345.227509] udevd           S f500de68  6192   866      1 0x00000000
kernel: [  345.227509] kworker/0:3     S f5115f20  6860  1043      2 0x00000000
kernel: [  345.227509] pccardd         S f52dff24  7344  1048      2 0x00000000
kernel: [  345.227509] pccardd         S f530bf24  7344  1050      2 0x00000000
kernel: [  345.227509] flush-3:0       S c10d787b  6432  1116      2 0x00000000
kernel: [  345.227509] syslogd         S 00000000  6164  1167      1 0x00000000
kernel: [  345.227509] klogd           S 00000058  6612  1171      1 0x00000000
kernel: [  345.227509] inetd           S 00000000  6440  1283      1 0x00000000
kernel: [  345.227509] sshd            S 00000000  6332  1286      1 0x00000000
kernel: [  345.227509] acpid           S f539daf4  6248  1293      1 0x00000000
kernel: [  345.227509] dbus-daemon     S 00000000  6356  1301      1 0x00000000
kernel: [  345.227509] hald            S f5c649e0  6180  1306      1 0x00000000
kernel: [  345.227509] hald            S f77d82c4  7076  1308      1 0x00000000
kernel: [  345.227509] hald-runner     S c11f5171  6356  1307   1306 0x00000000
kernel: [  345.227509] hald-addon-inpu S 0222270e  6356  1342   1307 0x00000000
kernel: [  345.227509] hald-addon-gene S 00000010  6592  1344   1307 0x00000000
kernel: [  345.227509] hald-addon-acpi S 00000001  6572  1356   1307 0x00000000
kernel: [  345.227509] crond           S f53cdf40  6632  1363      1 0x00000000
kernel: [  345.227509] atd             S f53d1fb4  6532  1365      1 0x00000000
kernel: [  345.227509] sendmail        S f53f1f40  6268  1368      1 0x00000000
kernel: [  345.227509] sendmail        S f517c800  6176  1371      1 0x00000000
kernel: [  345.227509] udevd           S f53dde8c  6592  1377    866 0x00000000
kernel: [  345.227509] udevd           S f57a8000  6924  1378    866 0x00000000
kernel: [  345.227509] vnstatd         S 00000000  6556  1421      1 0x00000000
kernel: [  345.227509] auditd          S f5cb3d90  6584  1427      1 0x00000000
kernel: [  345.227509] auditd          S c1029e3c  6072  1428      1 0x00000000
kernel: [  345.227509] kauditd         S f481bf2c  7440  1430      2 0x00000000
kernel: [  345.227509] bash            S f5009b80  5844  1613      1 0x00000080
kernel: [  345.227509] agetty          S f53e3e04  6748  1614      1 0x00000080
kernel: [  345.227509] agetty          S f53e5e04  6748  1615      1 0x00000080
kernel: [  345.227509] agetty          S f4819e04  6748  1616      1 0x00000080
kernel: [  345.227509] agetty          S f53f3e04  6704  1617      1 0x00000080
kernel: [  345.227509] agetty          S f4971e04  6404  1618      1 0x00000080
kernel: [  345.227509] startx          S f5ddb700  6308  1633   1613 0x00000080
kernel: [  345.227509] xinit           S f49b5f9c  6592  1649   1633 0x00000080
kernel: [  345.227509] X               S f49d5944  5468  1650   1649 0x00400080
kernel: [  345.227509] sh              S f51e7180  6480  1658   1649 0x00000080
kernel: [  345.227509] xscreensaver    S f53f1f40  5800  1664   1658 0x00000080
kernel: [  345.227509] ssh-agent       S 00000000  6440  1667      1 0x00000080
kernel: [  345.227509] dbus-launch     S 00000000  6440  1672      1 0x00000080
kernel: [  345.227509] dbus-daemon     S 00000000  6356  1674      1 0x00000080
kernel: [  345.227509] xfce4-session   S f4a0daf4  5800  1676   1658 0x00000080
kernel: [  345.227509] xfconfd         S 00000033  5728  1678      1 0x00000080
kernel: [  345.227509] xfwm4           S c11f5234  5896  1683      1 0x00000080
kernel: [  345.227509] xfce4-panel     S c11f5234  5800  1685      1 0x00000080
kernel: [  345.227509] xfce4-panel     S 00000000  7360  1745      1 0x00000080
kernel: [  345.227509] Thunar          S f53f1f40  5800  1687      1 0x00000080
kernel: [  345.227509] xfsettingsd     S 00000010  6592  1688      1 0x00000080
kernel: [  345.227509] xfdesktop       S f53f1f40  5800  1690      1 0x00000080
kernel: [  345.227509] gkrellm         S f29e981d  5728  1694      1 0x00000080
kernel: [  345.227509] tilda           S 00000010  5876  1696      1 0x00000080
kernel: [  345.227509] tilda           S 00000000  7360  1720      1 0x00000080
kernel: [  345.227509] autocutsel      S c11f5234  6200  1698      1 0x00000080
kernel: [  345.227509] orage           S c11f5171  5728  1700      1 0x00000080
kernel: [  345.227509] gam_server      S 00000246  5728  1702      1 0x00000080
kernel: [  345.227509] devilspie       S f4aafaf4  6312  1706      1 0x00000080
kernel: [  345.227509] xterm           S 00000000  5728  1710      1 0x00000080
kernel: [  345.227509] xfce4-settings- S f4ad1b00  6356  1715      1 0x00000080
kernel: [  345.227509] xfce4-menu-plug S 00200246  6268  1717   1685 0x00000080
kernel: [  345.227509] gnome-pty-helpe S 00000003  6532  1718   1696 0x00000080
kernel: [  345.227509] bash            S f4ae1e04  6704  1719   1696 0x00000080
kernel: [  345.227509] tail            S f3c03fb4  5800  1724   1710 0x00000080
kernel: [  345.227509] gvfsd           S f3c07af0  5800  1726      1 0x00000080
kernel: [  345.227509] xfce4-weather-p S f4aa3b68  5800  1729   1685 0x00000080
kernel: [  345.227509] xfce4-notes-plu S f3c05af4  5800  1730   1685 0x00000080
kernel: [  345.227509] xfce4-battery-p S f4aed630  6180  1731   1685 0x00000080
kernel: [  345.227509] xfce4-mixer-plu S 00000000  6200  1732   1685 0x00000080
kernel: [  345.227509] task0           S 00000000  6484  1740   1685 0x00000080
kernel: [  345.227509] gvfs-fuse-daemo S c1029e3c  7176  1736      1 0x00000080
kernel: [  345.227509] gvfs-fuse-daemo S f4aebdc4  6944  1737      1 0x00000080
kernel: [  345.227509] gvfs-fuse-daemo S f4aeef04  7268  1738      1 0x00000080
kernel: [  345.227509] gvfs-fuse-daemo S 00000000  6592  1739      1 0x00000080
kernel: [  345.227509] xterm           S f3c69aa0  6160  1744      1 0x00000080
kernel: [  345.227509] bash            S f3c0cb00  6876  1747   1744 0x00000080
kernel: [  345.227509] bash            S 7f1c0300  5728  1763   1747 0x00000080
kernel: [  345.227509] flush-0:18      S f3d13f24  7616  1809      2 0x00000080
kernel: [  345.227509] kworker/u:2     S 00000000  6768  1810      2 0x00000080
kernel: [  345.227509] kworker/u:3     S 00000000  6552  1811      2 0x00000080
kernel: [  345.227509] kworker/u:4     S 00000000  6768  1812      2 0x00000080
kernel: [  345.227509] kworker/u:5     S 00000000  6768  1813      2 0x00000080
kernel: [  345.227509] kworker/u:6     S 00000000  6768  1814      2 0x00000080
kernel: [  345.227509] kworker/u:7     S 00000000  7124  1815      2 0x00000080
kernel: [  345.227509] kworker/u:8     S 00000000  6864  1816      2 0x00000080
kernel: [  345.227509] kworker/u:9     S 00000000  6356  1817      2 0x00000080
kernel: [  345.227509] kworker/u:10    S 00000000  6864  1818      2 0x00000080
kernel: [  345.227509] kworker/u:11    S 00000000  6600  1819      2 0x00000080
kernel: [  345.227509] kworker/u:12    S 00000000  7356  1820      2 0x00000080
kernel: [  345.227509] kworker/u:13    S 00000000  6356  1821      2 0x00000080
kernel: [  345.227509] kworker/u:14    S 00000000  7356  1822      2 0x00000080
kernel: [  345.227509] kworker/u:15    S 00000000  7356  1823      2 0x00000080
kernel: [  345.227509] kworker/u:16    S 00000000  7136  1824      2 0x00000080
kernel: [  345.227509] kworker/u:17    S 00000000  6600  1825      2 0x00000080
kernel: [  345.227509] kworker/u:18    S 00000000  7356  1826      2 0x00000080
kernel: [  345.227509] kworker/u:19    S 00000000  7136  1827      2 0x00000080
kernel: [  345.227509] kworker/u:20    S 00000000  6600  1828      2 0x00000080
kernel: [  345.227509] kworker/u:21    S 00000000  6356  1829      2 0x00000080
kernel: [  345.227509] kworker/u:22    S 00000000  7136  1830      2 0x00000080
kernel: [  345.227509] kworker/u:23    S 00000000  6864  1831      2 0x00000080
kernel: [  345.227509] kworker/u:24    S 00000000  7120  1832      2 0x00000080
kernel: [  345.227509] kworker/u:25    S 00000000  6768  1833      2 0x00000080
kernel: [  345.227509] kworker/u:26    S 00000000  7356  1834      2 0x00000080
kernel: [  345.227509] kworker/u:27    S 00000000  6768  1835      2 0x00000080
kernel: [  345.227509] kworker/u:28    S 00000000  6404  1836      2 0x00000080
kernel: [  345.227509] kworker/u:29    S 00000000  7224  1837      2 0x00000080
kernel: [  345.227509] kworker/u:30    S 00000000  6404  1838      2 0x00000080
kernel: [  345.227509] kworker/u:31    S 00000000  6768  1839      2 0x00000080
kernel: [  345.227509] kworker/u:32    S 00000000  6568  1840      2 0x00000080
kernel: [  345.227509] kworker/u:33    S 00000000  6768  1841      2 0x00000080
kernel: [  345.227509] kworker/u:34    S 00000000  6404  1842      2 0x00000080
kernel: [  345.227509] kworker/u:35    S 00000000  7248  1850      2 0x00000080
kernel: [  345.227509] kworker/u:36    S 00000000  6404  1851      2 0x00000080
kernel: [  345.227509] kworker/u:37    S 00000000  6768  1852      2 0x00000080
kernel: [  345.227509] kworker/u:38    S 00000000  6568  1853      2 0x00000080
kernel: [  345.227509] kworker/u:39    S 00000000  7356  1854      2 0x00000080
kernel: [  345.227509] kworker/u:40    S 00000000  7356  1855      2 0x00000080
kernel: [  345.227509] kworker/u:41    S 00000000  7672  1864      2 0x00000080

