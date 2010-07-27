Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab0G0MvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 08:51:17 -0400
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:48023 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab0G0MvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 08:51:15 -0400
X-MXL-Hash: 4c4ed643037516aa-d2e70f4aaf3940df16fc26e84d88839bce798f8b
Message-ID: <4C4ED641.1030803@bluearc.com>
Date: Tue, 27 Jul 2010 13:51:13 +0100
From: Andy Chittenden <andyc@bluearc.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB; rv:1.9.2.7) Gecko/20100713 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "Linux Kernel Mailing List (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        netdev <netdev@vger.kernel.org>
Subject: Re: nfs client hang
References: <99613C19B13C5D40914FB8930657FA9303365708DE@uk-ex-mbx1.terastack.bluearc.com>	 <4C4E89D4.8040607@bluearc.com>	 <ABFC24E4C13D81489F7F624E14891C8607DDF8D1E4@uk-ex-mbx1.terastack.bluearc.com> <1280233276.2827.175.camel@edumazet-laptop>
In-Reply-To: <1280233276.2827.175.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <andyc@bluearc.com>
X-SOURCE-IP: [213.121.168.131]
X-AnalysisOut: [v=1.0 c=1 a=VphdPIyG4kEA:10 a=IkcTkHD0fZMA:10 a=sIqM7rbIUs]
X-AnalysisOut: [2FIam8obyq6w==:17 a=o0cdoPS4yRlJsJjKNPkA:9 a=cXxaut9FHxzI_]
X-AnalysisOut: [LVZQZoA:7 a=7qNss1jP2wjFzL82pD8kZAKI90EA:4 a=QEXdDO2ut3YA:]
X-AnalysisOut: [10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 2010-07-27 13:21, Eric Dumazet wrote:
> Le mardi 27 juillet 2010 à 11:53 +0100, Andy Chittenden a écrit :
>>>>> IE the client starts a connection and then closes it again without sending data.
>>>> Once this happens, here's some rpcdebug info for the rpc module using 2.6.34.1 kernel:
>>>>
>>>> ... lots of the following nfsv3 WRITE requests:
>>>> [ 7670.026741] 57793 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
>>>> [ 7670.026759] 57794 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
>>>> [ 7670.026778] 57795 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
>>>> [ 7670.026797] 57796 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
>>>> [ 7670.026815] 57797 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
>>>> [ 7670.026834] 57798 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
>>>> [ 7670.026853] 57799 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
>>>> [ 7670.026871] 57800 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
>>>> [ 7670.026890] 57801 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
>>>> [ 7670.026909] 57802 0001    -11 ffff88012e32b000   (null)        0 ffffffffa03beb10 nfsv3 WRITE a:call_reserveresult q:xprt_backlog
>>>> [ 7680.520042] RPC:       worker connecting xprt ffff88013e62d800 via tcp to 10.1.6.102 (port 2049)
>>>> [ 7680.520066] RPC:       ffff88013e62d800 connect status 99 connected 0 sock state 7
>>>> [ 7680.520074] RPC: 33550 __rpc_wake_up_task (now 4296812426)
>>>> [ 7680.520079] RPC: 33550 disabling timer
>>>> [ 7680.520084] RPC: 33550 removed from queue ffff88013e62db20 "xprt_pending"
>>>> [ 7680.520089] RPC:       __rpc_wake_up_task done
>>>> [ 7680.520094] RPC: 33550 __rpc_execute flags=0x1
>>>> [ 7680.520098] RPC: 33550 xprt_connect_status: retrying
>>>> [ 7680.520103] RPC: 33550 call_connect_status (status -11)
>>>> [ 7680.520108] RPC: 33550 call_transmit (status 0)
>>>> [ 7680.520112] RPC: 33550 xprt_prepare_transmit
>>>> [ 7680.520118] RPC: 33550 rpc_xdr_encode (status 0)
>>>> [ 7680.520123] RPC: 33550 marshaling UNIX cred ffff88012e002300
>>>> [ 7680.520130] RPC: 33550 using AUTH_UNIX cred ffff88012e002300 to wrap rpc data
>>>> [ 7680.520136] RPC: 33550 xprt_transmit(32920)
>>>> [ 7680.520145] RPC:       xs_tcp_send_request(32920) = -32
>>>> [ 7680.520151] RPC:       xs_tcp_state_change client ffff88013e62d800...
>>>> [ 7680.520156] RPC:       state 7 conn 0 dead 0 zapped 1
>>> I changed that debug to output sk_shutdown too. That has a value of 2
>>> (IE SEND_SHUTDOWN). Looking at tcp_sendmsg(), I see this:
>>>           err = -EPIPE;
>>>           if (sk->sk_err || (sk->sk_shutdown&  SEND_SHUTDOWN))
>>>                   goto out_err;
>>> which correlates with the trace "xs_tcp_send_request(32920) = -32". So,
>>> this looks like a problem in the sockets/tcp layer. The rpc layer issues
>>> a shutdown and then reconnects using the same socket. So either
>>> sk_shutdown needs zeroing once the shutdown completes or should be
>>> zeroed on subsequent connect. The latter sounds safer.
>> This patch for 2.6.34.1 fixes the issue:
>>
>> --- /home/company/software/src/linux-2.6.34.1/net/ipv4/tcp_output.c     2010-07-27 08:46:46.917000000 +0100
>> +++ net/ipv4/tcp_output.c       2010-07-27 09:19:16.000000000 +0100
>> @@ -2522,6 +2522,13 @@
>>          struct tcp_sock *tp = tcp_sk(sk);
>>          __u8 rcv_wscale;
>>
>> +       /* clear down any previous shutdown attempts so that
>> +        * reconnects on a socket that's been shutdown leave the
>> +        * socket in a usable state (otherwise tcp_sendmsg() returns
>> +        * -EPIPE).
>> +        */
>> +       sk->sk_shutdown = 0;
>> +
>>          /* We'll fix this up when we get a response from the other end.
>>           * See tcp_input.c:tcp_rcv_state_process case TCP_SYN_SENT.
>>           */
>>
>> As I mentioned in my first message, we first saw this issue in 2.6.32 as supplied by debian (linux-image-2.6.32-5-amd64 Version: 2.6.32-17). It looks like the same patch would fix the problem there too.
>>
> CC netdev
>
> This reminds me a similar problem we had in the past, fixed with commit
> 1fdf475a (tcp: tcp_disconnect() should clear window_clamp)
>
> But tcp_disconnect() already clears sk->sk_shutdown
>
> If NFS calls tcp_disconnect(), then shutdown(), there is a problem.
>
> Maybe xs_tcp_shutdown() should make some sanity tests ?
>
> Following sequence is legal, and your patch might break it.
>
> fd = socket(...);
> shutdown(fd, SHUT_WR);
> ...
> connect(fd, ...);
>
>
>
Thanks for the response. From my reading of the RPC code, because 
nothing clears the sk_shutdown flag, the RPC code goes into a loop when 
recovering from packets being lost:

shutdown
connect
send fails so repeat

My patch stops the NFS client hang that I was seeing but I'm not an 
expert on either the socket layer, RPC code or NFS code so I'm happy for 
someone else to come up with the alternative, correct fix.

-- 
Andy, BlueArc Engineering

