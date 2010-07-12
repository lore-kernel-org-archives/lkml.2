Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0GLPnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:43:05 -0400
Received: from web50908.mail.re2.yahoo.com ([206.190.38.128]:32840 "HELO
	web50908.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752328Ab0GLPnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:43:03 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jul 2010 11:43:03 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=Qw1mc9zMEfB9iFEnXUoExRmGIMJyY6Qx1IzOY0XcnKhQ7B9hyUCtx6Njjf7eOCu2R3m4UmSz1fDXs4FvpTKpJKkThznEh+vuE7OP95x2wTLEU/1xUPNeh2iNihSlprvS7WHQ45ql4auPsZ6IF3XjQKqT0gn+nznwoY6Huh65PJs=;
Message-ID: <75980.97062.qm@web50908.mail.re2.yahoo.com>
X-YMail-OSG: QtGYvxUVM1l.SdEItHaYnUf.AWZ__W37M0kEZStdJcYukAw
 5.wl.LBHMyDKxaspNa_Qrg1E5Tkf4L6N.9moI550iWEo1GMx2vgv1mlT2s6W
 vhxwrwwth1f1K9bSWEfMtkUFZoUsbVjZ8zV5EgBspRwOF867T3zZszHLyWKz
 3kJ48YwrMPkX7BhNvRqU3SnX6vN5ZzBGADqB0WkH9hqp9fbz_cC0Bmg2YhS2
 gP02Wfl3OPxG1ZCRAZZJWCsXbEMjKfkF7Bsw4LzGatsrsScvwuysdGoFp7Fc
 ku6WK6icX3PMIp.F9rotRKbJRHQ--
X-Mailer: YahooMailRC/420.4 YahooMailWebService/0.8.104.276605
Date: Mon, 12 Jul 2010 08:36:19 -0700 (PDT)
From: Rohit B <b_rohitb@yahoo.com>
Subject: Hang observed while reading a block device using a simple block driver using the file as a back-end data store
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1916392561-1278948979=:97062"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1916392561-1278948979=:97062
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,=0AI am trying to implement a block driver and facing an issue. Please f=
ind =0Aattached a simple code snippet which reproduces this hang. I have us=
ed and =0Amodified the Simple Block driver(sbull) example from Linux Device=
 Drivers (3rd =0AEd) =0Ato simulate the problem. The example has been modif=
ied to use a file as the =0Aback-end instead of memory. =0A=0AThe problem t=
hat I see with this example is that, when an attempt is made to =0Aread =0A=
the block device using dd, the vfs_read function call in thesbull_make_requ=
est =0Ahangs. =0AThis sometimes causes the insmod of sbull to hang. And alm=
ost always causes the =0Add command to hang. This hang is only observed in =
the linux kernel version =0A2.6.27.45-0.1 (SLES 11). I have also tried the =
same code example on =0ALiunx 2.6.16.46-0.12 (SLES 10 and its service packs=
), but the hang is not =0Aobserved there. While I understand that this is n=
ot a normal use-case, a block =0Adriver will not use a file as a back-end, =
I wanted to understand how to fix my =0Aexample code to solve this hang pro=
blem for the latest kernel. Any help in this =0Aregard is highly appreciate=
d.=0A=0ADistribution Used SLES 11=0AKernels checked: 2.6.27.45-0.1=0ADescri=
ption of the Source Attached: This attached source uses the simple =0Ano-qu=
eue version and defines a make-request. The make-request reads the file for=
 =0A=0Athe data and services the bio. =0A=0ASteps to reproduce the problem:=
=0A1.      untar the sbull.tar.gz and cd into sbull and do a make. Make als=
o =0Acreates a 512MB file in the current=0Adirectory which is used as the b=
ack-end.=0A2.      insmod sbull.ko, a block device /dev/sbulla is created.=
=0A3.      dd if=3D/dev/sbulla of=3D./file (hangs)=0A=0AStack Trace of the =
Hang:=0Acrash> bt 4289=0APID: 4289   TASK: ffff880026120200  CPU: 1   COMMA=
ND: "dd"=0A#0 [ffff8800260a15c8] schedule at ffffffff8049c0a7=0A#1 [ffff880=
0260a16d0] io_schedule at ffffffff8049c1c6=0A#2 [ffff8800260a16f0] sync_pag=
e at ffffffff80282d5d=0A#3 [ffff8800260a1700] __lock_page_killable at fffff=
fff8028305f=0A#4 [ffff8800260a1760] do_generic_file_read at ffffffff80283e8=
4=0A#5 [ffff8800260a17f0] generic_file_aio_read at ffffffff80284a94=0A#6 [f=
fff8800260a1880] do_sync_read at ffffffff802b1880=0A#7 [ffff8800260a19b0] v=
fs_read at ffffffff802b227a=0A#8 [ffff8800260a19e0] sbull_make_request at f=
fffffffa02bd3f3=0A#9 [ffff8800260a1a40] generic_make_request at ffffffff803=
3a7f8=0A#10 [ffff8800260a1ae0] submit_bio at ffffffff8033a901=0A#11 [ffff88=
00260a1b20] submit_bh at ffffffff802d2ae2=0A#12 [ffff8800260a1b40] block_re=
ad_full_page at ffffffff802d5b08=0A#13 [ffff8800260a1c00] __do_page_cache_r=
eadahead at ffffffff8028aeed=0A#14 [ffff8800260a1c80] ondemand_readahead at=
 ffffffff8028b22b=0A#15 [ffff8800260a1cc0] do_generic_file_read at ffffffff=
80283d52=0A#16 [ffff8800260a1d50] generic_file_aio_read at ffffffff80284a94=
=0A#17 [ffff8800260a1de0] do_sync_read at ffffffff802b1880=0A#18 [ffff88002=
60a1f10] vfs_read at ffffffff802b227a=0A#19 [ffff8800260a1f40] sys_read at =
ffffffff802b23df=0A#20 [ffff8800260a1f80] system_call_fastpath at ffffffff8=
020bffb=0A    RIP: 00007ffabd782ee0  RSP: 00007fff3b4131f8  RFLAGS: 0000021=
7=0A    RAX: 0000000000000000  RBX: ffffffff8020bffb  RCX: 00007ffabd782ee0=
=0A    RDX: 0000000000000200  RSI: 0000000000611000  RDI: 0000000000000000=
=0A    RBP: 0000000000000000   R8: 0000000000000000   R9: 0000000000000000=
=0A    R10: 0000000000000000  R11: 0000000000000246  R12: 0000000000611000=
=0A    R13: 0000000000000200  R14: 0000000000000800  R15: 0000000000000000=
=0A    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b=0Acrash>=0A=0A=0ARgds=
,=0ARohit=0A=0A
--0-1916392561-1278948979=:97062
Content-Type: application/x-gzip; name="sbull.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="sbull.tar.gz"

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
NdTwN+G/xBqzYwBQAAA=

--0-1916392561-1278948979=:97062--
