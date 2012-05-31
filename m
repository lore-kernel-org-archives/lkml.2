Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab2EaNqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 09:46:34 -0400
Received: from mx2.netapp.com ([216.240.18.37]:9165 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948Ab2EaNqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 09:46:32 -0400
X-IronPort-AV: E=Sophos;i="4.75,692,1330934400"; 
   d="scan'208";a="652353744"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Michael Tokarev <mjt@tls.msk.ru>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.0+ NFS issues
Thread-Topic: 3.0+ NFS issues
Thread-Index: AQHNPy05dzwzDjRQlEai2sHeL9oSEZbkWIgAgAAF9YA=
Date: Thu, 31 May 2012 13:46:16 +0000
Message-ID: <1338471975.7732.5.camel@lade.trondhjem.org>
References: <4FBF2C57.3070203@msgid.tls.msk.ru>
	  <20120529152416.GC3441@fieldses.org> <4FC5C82E.4020806@msgid.tls.msk.ru>
	  <20120530132518.GA13794@fieldses.org> <4FC713ED.5040807@msgid.tls.msk.ru>
	 <1338469169.2420.7.camel@lade.trondhjem.org>
	 <4FC77128.9090206@msgid.tls.msk.ru>
In-Reply-To: <4FC77128.9090206@msgid.tls.msk.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FECD90FA83178479BEE605AFF8C900E@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4VDkgWO006974

On Thu, 2012-05-31 at 17:24 +0400, Michael Tokarev wrote:
> On 31.05.2012 16:59, Myklebust, Trond wrote:
> []
> > That is tcpdump trying to interpret your NFSv4 trace as NFSv2/v3.
> 
> Oh.
> 
> > Can you either please use wireshark to provide a full text dump (using
> > something like 'tshark -V -O nfs,rpc'), or just send us the binary
> > tcpdump output using 'tcpdump -w /tmp/foo -s 90000'?
> 
> I started tcpdump:
> 
>  tcpdump -npvi br0 -s 0 host 192.168.88.4 and \( proto ICMP or port 2049 \) -w nfsdump
> 
> on the client (192.168.88.2).  Next I mounted a directory on the client,
> and started reading (tar'ing) a directory into /dev/null.  It captured a
> few stalls.  Tcpdump shows number of packets it got, the stalls are at
> packet counts 58090, 97069 and 97071.  I cancelled the capture after that.
> 
> The resulting file is available at http://www.corpit.ru/mjt/tmp/nfsdump.xz ,
> it is 220Mb uncompressed and 1.3Mb compressed.  The source files are
> 10 files of 1Gb each, all made by using `truncate' utility, so does not
> take place on disk at all.  This also makes it obvious that the issue
> does not depend on the speed of disk on the server (since in this case,
> the server disk isn't even in use).

OK. So from the above file it looks as if the traffic is mainly READ
requests.

In 2 places the server stops responding. In both cases, the client seems
to be sending a single TCP frame containing several COMPOUNDS containing
READ requests (which should be legal) just prior to the hang. When the
server doesn't respond, the client pings it with a RENEW, before it ends
up severing the TCP connection and then retransmitting.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
