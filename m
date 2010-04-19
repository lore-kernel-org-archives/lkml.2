Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0DSTVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:21:49 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:53852 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab0DSTVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:21:48 -0400
Date: Mon, 19 Apr 2010 12:21:47 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, hch@lst.de
Subject: [2.6.34 regression] utsname.domainname not set in x86_32 processes
Message-ID: <20100419192147.GP11130@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-rc4 uname(2) from a x86_32 process copies out 325 bytes rather
than the 390 bytes that 2.6.31 copied out (and that userland expects):

2.6.31.12% cat foo.c
main()
{
	char buf[1000];
	memset(buf, 'x', sizeof(buf));
	uname(buf);
	write(1, buf, sizeof(buf));
	return 0;
}
2.6.31.12% i686-linux-gcc foo.c
2.6.31.12% ./a.out | hd
00000000  4c 69 6e 75 78 00 00 00  00 00 00 00 00 00 00 00  |Linux...........|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000040  00 63 76 70 65 34 33 30  30 00 00 00 00 00 00 00  |.cvpe4300.......|
00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000080  00 00 32 2e 36 2e 33 31  2e 31 32 2d 63 76 70 32  |..2.6.31.12-cvp2|
00000090  30 31 30 30 33 32 39 2d  30 30 31 34 38 2d 67 39  |0100329-00148-g9|
000000a0  61 38 62 36 36 61 00 00  00 00 00 00 00 00 00 00  |a8b66a..........|
000000b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000000c0  00 00 00 23 36 20 53 4d  50 20 54 75 65 20 41 70  |...#6 SMP Tue Ap|
000000d0  72 20 36 20 31 36 3a 30  33 3a 33 31 20 50 44 54  |r 6 16:03:31 PDT|
000000e0  20 32 30 31 30 00 00 00  00 00 00 00 00 00 00 00  | 2010...........|
000000f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000100  00 00 00 00 78 38 36 5f  36 34 00 00 00 00 00 00  |....x86_64......|
00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000140  00 00 00 00 00 28 6e 6f  6e 65 29 00 00 00 00 00  |.....(none).....|
00000150  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000180  00 00 00 00 00 00 78 78  78 78 78 78 78 78 78 78  |......xxxxxxxxxx|
00000190  78 78 78 78 78 78 78 78  78 78 78 78 78 78 78 78  |xxxxxxxxxxxxxxxx|
*
000003e0  78 78 78 78 78 78 78 78                           |xxxxxxxx|
000003e8

2.6.34-rc4% ./a.out | hd
00000000  4c 69 6e 75 78 00 00 00  00 00 00 00 00 00 00 00  |Linux...........|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000040  00 63 76 70 2d 6c 6f 61  6e 65 72 2d 31 36 00 00  |.cvp-loaner-16..|
00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000080  00 00 32 2e 36 2e 33 34  2d 72 63 34 2d 30 30 31  |..2.6.34-rc4-001|
00000090  31 35 2d 67 64 63 35 37  64 61 33 00 00 00 00 00  |15-gdc57da3.....|
000000a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000000c0  00 00 00 23 36 20 53 4d  50 20 46 72 69 20 41 70  |...#6 SMP Fri Ap|
000000d0  72 20 31 36 20 31 30 3a  34 31 3a 34 33 20 50 44  |r 16 10:41:43 PD|
000000e0  54 20 32 30 31 30 00 00  00 00 00 00 00 00 00 00  |T 2010..........|
000000f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000100  00 00 00 00 78 38 36 5f  36 34 00 00 00 00 00 00  |....x86_64......|
00000110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000140  00 00 00 00 00 78 78 78  78 78 78 78 78 78 78 78  |.....xxxxxxxxxxx|
00000150  78 78 78 78 78 78 78 78  78 78 78 78 78 78 78 78  |xxxxxxxxxxxxxxxx|
*
000003e0  78 78 78 78 78 78 78 78                           |xxxxxxxx|
000003e8

-andy
