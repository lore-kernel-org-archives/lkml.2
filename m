Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1AOPOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:14:20 -0500
Received: from ns1.huweb.hu ([62.112.193.37]:59672 "EHLO ns1.huweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab1AOPOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:14:19 -0500
Message-ID: <38935164A54A4EE38D32AD5046EA0DFD@M2007>
From: "Gabor FUNK" <FUNK.Gabor@hunetkft.hu>
To: <linux-kernel@vger.kernel.org>
Subject: kernel tcp messages crippled randomly?
Date: Sat, 15 Jan 2011 16:13:56 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
X-MailScanner-ID: 1Pe7pV-0007j2-D5
X-huweb-ns1-MailScanner: Found to be clean
X-huweb-ns1-MailScanner-From: funk.gabor@hunetkft.hu
X-huweb-ns1-MessageSize: 5726
X-huweb-ns1-Authenticated-ID: bcd9805ec380393dea9f77d47cc6f2e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just replaced an old server with a new one, put kernel version 2.6.37 (amd64) on it.
I just noticed strange/crippled entries in kern.log/syslog, seemingly coming ONLY from the kernel, eg. other log entries generated 
by apache/ftp/sql/exim/etc don't exhibit such problem.
Also in general, kernel messages are fine, but sometimes they get "scrambled"...
[It is under a good streess, hundreds of www-s, sql, mails, etc., no problems (no core/kernel panic, so likely hw has no problems, 
looks healthy otherwise)]

Find log part below, look for:
"uepcel hukwno" and "nxetdysrn idw" for "UnExPeCtEdLy sHrUnK WiNdOw" (every 2nd letter)
"eeeyhnwd" is same "unExpEctEdlY sHruNk WinDow" (every 3rd letter)
"rpie" / "eard" for RePaIrEd
    and
"pigpceI" / "dopn aktN" for "DrOpPiNg pAcKeTiN" - the "kernel / nf_ct_ftp" lines.

Is it just me, or, erm... not?

(btw, port 8081 is running a lighttpd)

Thanks,

G.

---

Jan 14 22:55:19 ns1 kernel: : C:Pe 7291.1:5554uepcel hukwno 5948130346 rpie)<>C:Pe 8.4.1.543788 nxetdysrn idw11319:88778(eard
Jan 14 22:55:20 ns1 kernel: : TCP: Peer 189.248.113.75:49377/8081 unexpectedly shrunk window 1818371798:1818376758 (repaired)
Jan 15 11:15:16 ns1 kernel: : TCP: Peer 93.108.182.189:49303/8081 unexpectedly shrunk window 2235699385:2235701010 (repaired)
Jan 15 11:15:16 ns1 kernel: : TCP: Pee 910146:76/01uepcel hukwno 2165936401 rpie)<>C:Pe 910146:76/01nptlsu nw245:671(pr)<7>TCP: Peer 
93.108.182.189:4930388 nxetdysrn idw23698:25000(eard
Jan 15 11:24:15 ns1 kernel: : C:Pe 4372:5/8uxcd uwo32:43ri)
Jan 15 13:39:39 ns1 kernel: : TCP: Peer 217.208.245.66:55511/8081 unexpectedly shrunk window 3424515429:3424520381 (repaired)
Jan 15 14:14:45 ns1 kernel: : TCP: Peer 189.106.231.213:57107/8081 unexpectedly shrunk window 3521837958:352184647 rpie)<7>TCP: Peer 
189.106.231.213:57107/8081 unexpectedly shrunk window 3521837958:3521846475 (repaired)
Jan 15 14:15:33 ns1 kernel: C:Pe 902.3760 eeeyhnwd 6364829rae
Jan 15 14:15:58 ns1 kernel: : TCP: Peer 18.0.32:2/8uxcd rkio4808123 eid<7>TCP: Peer 84.183.181.79:54549/8081 unexpectedly shrunk 
window 3957382290:3957395358 (repaired)
Jan 15 14:15:59 ns1 kernel: : TCP: Peer 84.183.181.79:54549/8081 unexpectedly shrunk window 3957382290:3957395358 (repaired)
Jan 15 14:16:00 ns1 kernel: C:e 902.3760 eeeyhnwd 418333(pr)<7>TCP: Peer 84.183.181.79:54549/8081 unexpectedly shrunk window 
3957382290:3957395358 (repaired)
Jan 15 14:16:03 ns1 kernel: : TCP: Peer 84.183.181.79:54549/8081 unexpectedly shrunk window 3957382290:3957395358 (repaired)
Jan 15 14:16:45 ns1 kernel: : TCP: Peer 189.106.231.213:57364/8081 unexpectedly shrunk window 486063161:486071678 (repaired)
Jan 15 14:17:27 ns1 kernel: : C:Pe 7108.7:39/01uepcel hukwno 1255324556 rpie)pigpceI=OTeh R=212133 S=3632 =T0 C0T4=6FOTS2P4 
=56A324IWR0   PU64D5
Jan 15 14:17:28 ns1 kernel: : nf_ct_ftp: dropping packetIN= OUT=eth0 SRC=62.112.193.37 DST=213.163.39.234 LEN=92 TOS=0x00 PREC=0x00 
TTL=64 ID=57662 DF PROTO=TCP SPT=21 DPT=44132 SEQ=1545444681 ACK=3116252248 WINDOW=9 RES=0x00 ACK PSH URGP=0 UID=65534 GID=65534
Jan 15 14:17:29 ns1 kernel: nf_ct_ftp: dropping packetIN= OUT=eth0 SRC=62.112.193.37 DST=213.163.39.234 LEN=92 TOS=0x00 PREC=0x00 
TTL=64 ID=57665 DF PROTO=TCP SPT=21 DPT=44132 SEQ=1545444681 ACK=3116252248 WINDOW=9 RES=0x00 ACK PSH URGP=0 UID=65534 GID=65534
Jan 15 14:17:33 ns1 kernel: nf_ct_ft:dopn aktN U=t0SC6.1.9.7DT23133.3 E=2TS00 RC00 T=4I=77 FPOOTPST2 P=43 E=55461AK31224 IDW9RS00 C 
S RP0UD654GD654
Jan 15 14:17:35 ns1 kernel: nf_ct_ftp: dropping packetIN= OUT=eth0 SRC=62.112.193.37 DST=213.163.39.234 LEN=92 TOS=0x00 PREC=0x00 
TTL=64 ID=57673 DF PROTO=TCP SPT=21 DPT=44132 SEQ=1545444681 ACK=3116252248 WINDOW=9 RES=0x00 ACK PSH URGP=0 UID=65534 GID=65534
Jan 15 14:17:38 ns1 kernel: : nf_ct_ftp: dropping packetIN= OUT=eth0 SRC=62.112.193.37 DST=213.163.39.234 LEN=92 TOS=0x00 PREC=0x00 
TTL=64 ID=57677 DF PROTO=TCP SPT=21 DPT=44132 SEQ=1545444681 ACK=3116252248 WINDOW=9 RES=0x00 ACK PSH URGP=0 UID=65534 GID=65534
Jan 15 14:22:22 ns1 kernel: : nf_ct_ftp: dropping packetIN= OUT=eth0 SRC=62.112.193.37 DST=213.163.39.234 LEN=92 TOS=0x00 PREC=0x00 
TTL=64 ID=57658 DF PROTO=TCP SPT=21 DPT=44132 SEQ=55461AK31224 IDW9RS00 C PHUG= I=53 I=53 <>fc_t:dopn aktN U=t0SC6.1.9.7DT23133.3 
E=2TS00 RC00 T=4I=75 FPOOTPST2 P=43 E=55461AK3154WD=R=0A HR=U=5 D54<7>TCP: Peer 189.106.231.213:58360/8081 unexpectedlysrn 
idw21364:11053(eard
Jan 15 14:22:23 ns1 kernel: : TCP: Peer 189.106.231.213:58360/8081 unexpectedly shrunk window 2111396046:2111404563 (repaired)
Jan 15 14:22:24 ns1 kernel: : TCP: Peer 189.106.231.213:58397/8081 unexpectedly shrunk window 2210186308:2210191921 (repaired)
Jan 15 14:22:25 ns1 kernel: : C:Pe 8.0.3.1:86/01uepcel hukwno 11906145 eid<7>TCP: Peer 189.106.231.213:58397/8081 unexpectedly 
shrunk window 2210186308:2210191921 (repaired) 

