Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0G1HYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:24:34 -0400
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:35653 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0G1HYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:24:33 -0400
X-MXL-Hash: 4c4fdb312c154eaf-78d0a3554b56f801c03c6144ffbcd0a5b6ce0ef2
X-MXL-Hash: 4c4fdb1f6ed47914-0e89f01a7e3faa295669f3b3671d042529a55feb
From: Andy Chittenden <andyc@bluearc.com>
To: Andy Chittenden <andyc@bluearc.com>, Chuck Lever <chuck.lever@oracle.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC: "Linux Kernel Mailing List (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Date: Wed, 28 Jul 2010 08:24:09 +0100
Subject: RE: nfs client hang
Thread-Topic: nfs client hang
Thread-Index: AcstsUyl/yRExswGQ6eSTBlV8RAxswAcbnQgAACk4UA=
Message-ID: <ABFC24E4C13D81489F7F624E14891C8607DDF8D3D0@uk-ex-mbx1.terastack.bluearc.com>
References: <99613C19B13C5D40914FB8930657FA9303365708DE@uk-ex-mbx1.terastack.bluearc.com>
	 <4C4E89D4.8040607@bluearc.com>
	 <ABFC24E4C13D81489F7F624E14891C8607DDF8D1E4@uk-ex-mbx1.terastack.bluearc.com>
 <1280233276.2827.175.camel@edumazet-laptop> <4C4F174C.2000308@oracle.com> 
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <andyc@bluearc.com>
X-SOURCE-IP: [213.121.168.131]
X-AnalysisOut: [v=1.0 c=1 a=VphdPIyG4kEA:10 a=IkcTkHD0fZMA:10 a=sIqM7rbIUs]
X-AnalysisOut: [2FIam8obyq6w==:17 a=suP9k7LRRQ2iNzehWc8A:9 a=dI0tmxBxbtM12]
X-AnalysisOut: [tpPTs19U8s0MGkA:4 a=QEXdDO2ut3YA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o6S7Ok4W026724

resending as it seems to have been corrupted on LKML!

> The RPC client marks the socket closed. and the linger timeout is 
> cancelled.  At this point, sk_shutdown should be set to zero, correct? 
> I don't see an xs_error_report() call here, which would confirm that the 
> socket took a trip through tcp_disconnect().

>From my reading of tcp_disconnect(), it calls sk->sk_error_report(sk) unconditionally so as there's no xs_error_report(), that surely means the exact opposite: tcp_disconnect() wasn't called. If it's not called, sk_shutdown is not cleared. And my revised tracing confirmed that it was set to 
SEND_SHUTDOWN.

-- 
Andy, BlueArc Engineering
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
