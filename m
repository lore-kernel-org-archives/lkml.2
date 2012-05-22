Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2EVMf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:35:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53133 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2EVMfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:35:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfee61a-b7fe76d0000023f5-06-4fbb88285bf8
Message-id: <4FBB8828.303@samsung.com>
Date: Tue, 22 May 2012 21:35:52 +0900
From: Chanyeol Park <chanyeol.park@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
To: Minho Ban <mhban@samsung.com>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix null pointer dereference in l2cap_chan_send
References: <4FB9932B.9070101@samsung.com>
In-reply-to: <4FB9932B.9070101@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jAV2Njt3+BptbdSzmXOtjtri8aw6b
	xbEFYg7MHp83yQUwRnHZpKTmZJalFunbJXBlNP2/ylLQIFXRNHsecwPjatEuRk4OCQETic+X
	nrFB2GISF+6tB7K5OIQEFjFKXFr8ggUkwSsgKPFj8j0gm4ODWUBe4silbJAws4CZxKOWdcwQ
	9a8YJSYvuwpVryax42YjO4jNIqAqsb17H1icTUBf4tCu44wgtqhAmMTrKYfA4iICihIrT/1j
	gxjayCTx9rEyiC0s4C/xZ/FCVhBbSEBL4t3rSWC9nALaEmum3mafwCgwC8l5sxDOm4XkvAWM
	zKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxggPymdQOxpUNFocYBTgYlXh4Bap3+wuxJpYV
	V+YeYpTgYFYS4d3UtstfiDclsbIqtSg/vqg0J7X4EKM0B4uSOK/d4h3+QgLpiSWp2ampBalF
	MFkmDk6pBsZlleVHF+3+yrvo6c6eOeunM+QXv/Hcd97xtu5KXed9DjFrrxXNlJh2zP1u8oOF
	TzOiol6EXr5r5vAqbQfHg7V1fzjbVj3ZG3nyzIo3Dc/mJIr5qwU67608OPd09VVZ5sfnZdg1
	GG9H9vRnXWlJXrdrievN5l+bW5hyJXrmW7pcCN3ZsaCcQ/u3EktxRqKhFnNRcSIASSnR1UQC	AAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
On 2012년 05월 21일 09:58, Minho Ban wrote:
> If l2cap_chan_send is called will null conn it will cause kernel Oops.
> This patch checks if conn is valid before entering l2cap_chan_send.
>
> 2871 [  177.271861] Unable to handle kernel NULL pointer dereference at virtual address 00000010
> 2872 [  177.271867] pgd = eadc0000
> 2873 [  177.271870] [00000010] *pgd=6ad03831, *pte=00000000, *ppte=00000000
> 2874 [  177.271884] Internal error: Oops: 17 [#1] PREEMPT SMP
> 2875 [  177.271891] Modules linked in:
> 2876 [  177.271900] CPU: 3    Not tainted  (3.0.15-00019-g097836e #36)
> 2877 [  177.271925] PC is at l2cap_chan_send+0x8c/0x6f8
> 2878 [  177.271933] LR is at 0xc089d59c
> 2879 [  177.271940] pc : [<c0531514>]    lr : [<c089d59c>]    psr: 80000013
> 2880 [  177.271943] sp : ddda1d50  ip : 0000035c  fp : ddda1dac
> 2881 [  177.271948] r10: 0000035c  r9 : 00000000  r8 : ddda1f3c
> 2882 [  177.271954] r7 : ed67ec00  r6 : 00000006  r5 : ed67ec00  r4 : 00000003
> 2883 [  177.271959] r3 : ddda1d7c  r2 : 0000035c  r1 : 00000000  r0 : ed67ec00
> 2884 [  177.271967] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32 ISA ARM  Segment user
> 2885 [  177.271973] Control: 10c5387d  Table: 6adc004a  DAC: 00000015
> ~~~ snip ~~~~~
> 3000 [  177.272989] Backtrace:
> 3001 [  177.273001] [<c0531488>] (l2cap_chan_send+0x0/0x6f8) from [<c053700c>] (l2cap_sock_sendmsg+0xc0/0x15c)
> 3002 [  177.273023] [<c0536f4c>] (l2cap_sock_sendmsg+0x0/0x15c) from [<c0458afc>] (sock_sendmsg+0xcc/0xd4)
> 3003 [  177.273035] [<c0458a30>] (sock_sendmsg+0x0/0xd4) from [<c0459558>] (sys_sendto+0xb8/0xdc)
> 3004 [  177.273041]  r9:ddda0000 r8:00004040 r7:00000000 r6:ebdf9d40 r5:0004fb00
> 3005 [  177.273050] r4:0000035c
> 3006 [  177.273059] [<c04594a0>] (sys_sendto+0x0/0xdc) from [<c045959c>] (sys_send+0x20/0x28)
> 3007 [  177.273077] [<c045957c>] (sys_send+0x0/0x28) from [<c00431c0>] (ret_fast_syscall+0x0/0x30)
> 3008 [  177.273087] Code: e5901004 e24b3030 e51ba050 e590e21c (e5914010)
> 3009 [  177.273096] ---[ end trace 29a418305c9cffba ]---
>
> Signed-off-by: Minho Ban<mhban@samsung.com>
> ---
>   net/bluetooth/l2cap_sock.c |    6 ++++--
>   1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index 3bb1611..98d4541 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -727,10 +727,12 @@ static int l2cap_sock_sendmsg(struct kiocb *iocb, struct socket *sock, struct ms
>   	if (msg->msg_flags&  MSG_OOB)
>   		return -EOPNOTSUPP;
>
> -	if (sk->sk_state != BT_CONNECTED)
> +	l2cap_chan_lock(chan);
> +	if (sk->sk_state != BT_CONNECTED || !chan->conn) {
> +		l2cap_chan_unlock(chan);
>   		return -ENOTCONN;
> +	}
>
> -	l2cap_chan_lock(chan);
>   	err = l2cap_chan_send(chan, msg, len, sk->sk_priority);
>   	l2cap_chan_unlock(chan);
>   
Beside !chan->conn condition,I think it makes sense that sk_state check 
should be moved after l2cap_chan_lock()
because sk_state could be changed due to l2cap_conn_del().

I think sk->state could be protected by l2cap_chan_lock() in the below 
procedure.

l2cap_conn_del()
->l2cap_chan_lock()
->l2cap_chan_del()
-> lock_sock()
__l2cap_sock_state_change() *
-> release_sock()
->l2cap_chan_unlock()

BR
Chanyeol Park.
