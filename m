Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0G2KKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:10:22 -0400
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:44415 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab0G2KKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:10:19 -0400
X-MXL-Hash: 4c51538a2465c7f3-fa76c53fc1328cbad8b6bfe03cd7adc875140cd4
Message-ID: <4C515384.6030905@bluearc.com>
Date: Thu, 29 Jul 2010 11:10:12 +0100
From: Andy Chittenden <andyc@bluearc.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB; rv:1.9.2.7) Gecko/20100713 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Chuck Lever <chuck.lever@oracle.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "Linux Kernel Mailing List (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: nfs client hang
References: <99613C19B13C5D40914FB8930657FA9303365708DE@uk-ex-mbx1.terastack.bluearc.com>	 <4C4E89D4.8040607@bluearc.com>	 <ABFC24E4C13D81489F7F624E14891C8607DDF8D1E4@uk-ex-mbx1.terastack.bluearc.com> <1280233276.2827.175.camel@edumazet-laptop> <4C4F174C.2000308@oracle.com> <ABFC24E4C13D81489F7F624E14891C8607DDF8D3D0@uk-ex-mbx1.terastack.bluearc.com> <4C506AD0.4070608@oracle.com>
In-Reply-To: <4C506AD0.4070608@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <andyc@bluearc.com>
X-SOURCE-IP: [213.121.168.131]
X-AnalysisOut: [v=1.0 c=1 a=VphdPIyG4kEA:10 a=IkcTkHD0fZMA:10 a=sIqM7rbIUs]
X-AnalysisOut: [2FIam8obyq6w==:17 a=JhofNBBMX6QQod_UlWUA:9 a=BG6rA3MRoB40X]
X-AnalysisOut: [cb3JRhEgdSogMkA:4 a=QEXdDO2ut3YA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 2010-07-28 18:37, Chuck Lever wrote:
> On 07/28/10 03:24 AM, Andy Chittenden wrote:
>> resending as it seems to have been corrupted on LKML!
>>
>>> The RPC client marks the socket closed. and the linger timeout is
>>> cancelled.  At this point, sk_shutdown should be set to zero, correct?
>>> I don't see an xs_error_report() call here, which would confirm that the
>>> socket took a trip through tcp_disconnect().
>>  From my reading of tcp_disconnect(), it calls sk->sk_error_report(sk)
>> unconditionally so as there's no xs_error_report(), that surely means
>> the exact opposite: tcp_disconnect() wasn't called. If it's not
>> called, sk_shutdown is not cleared. And my revised tracing confirmed
>> that it was set to SEND_SHUTDOWN.
> Sorry, that's what I meant above.
>
> An xs_error_report() debugging message at that point in the log would
> confirm that the socket took a trip through tcp_disconnect().  But I
> don't see such a message.
I don't see how tcp_disconnect() gets called if the application does a 
shutdown when the state is TCP_ESTABLISHED (or a myriad of other 
states). It just seems to send a FIN. Should tcp_disconnect() be called? 
If so, how? Alternatively, I wonder whether my patch that set 
sk_shutdown to 0 in tcp_connect_init() is the correct fix after all.

-- 
Andy, BlueArc Engineering

