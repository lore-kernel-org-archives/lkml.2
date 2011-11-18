Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab1KRMEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 07:04:34 -0500
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:55477 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754438Ab1KRMEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 07:04:33 -0500
Date: Fri, 18 Nov 2011 13:04:30 +0100
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Jinxin Zheng <jinxinzheng@gmail.com>
Cc: gerrit@erg.abdn.ac.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: ipv4 udplite broken in >=linux-3.0 ?
Message-ID: <20111118120430.GG3317@hell>
References: <CABPbr_msepemFt4ezGVRk3QS0MU3F47MKimfV4Y+6jqvUrLFeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPbr_msepemFt4ezGVRk3QS0MU3F47MKimfV4Y+6jqvUrLFeA@mail.gmail.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jinxin Zheng | 2011-11-18 12:09:25 [+0800]:

>I don't know how to debug udplite. Can any one of you give me a tip on
>how to get more debug info, then I can do further test and provide
>with it?

net-next works for me:

$ sudo aptitude install netsend
$ sudo tcpdump -n -ttt -vv -i lo > pcap.trace &
$ netsend udplite receive &
$ netsend udplite transmit /etc/fstab 127.0.0.1

$ cat pcap.trace
00:00:00.000000 IP (tos 0x0, ttl 64, id 30602, offset 0, flags [DF], proto unknown (136), length 40) 127.0.0.1 > 127.0.0.1:  udplite 20
00:00:00.000074 IP (tos 0x0, ttl 64, id 30603, offset 0, flags [DF], proto unknown (136), length 1125) 127.0.0.1 > 127.0.0.1:  udplite 1105


Kernel version? What is the output of strace?
