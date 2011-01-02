Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1ABTsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 14:48:17 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:36044 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1ABTsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 14:48:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c5H37hta5IyA0qwA8XQ8KWFBsdyJZZ0LJcl2cwAZCTMeEdgy6hGVw5S83UIFqWphJh
         25I5eS8+tjnmnPNHaOicmuTm2m9ISSzjAQoWZuXN5wH1DqTuE/W908saP1tJX1tOQgeB
         OApkuia1oNq2rWTVlVquBm7mTGWtBhflpvvA4=
MIME-Version: 1.0
In-Reply-To: <1293982286-15389-1-git-send-email-stefani@seibold.net>
References: <1293982286-15389-1-git-send-email-stefani@seibold.net>
Date: Sun, 2 Jan 2011 21:48:15 +0200
Message-ID: <AANLkTi=7M=gSgBjcrCVEj+GKZ5cf5t4MPqm6r9NGr=MZ@mail.gmail.com>
Subject: Re: [PATCH] new UDPCP Communication Protocol
From: Daniel Baluta <daniel.baluta@gmail.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have some style comments, please read below.

> +struct udpcp_statistics {
> +       unsigned int txMsgs;            /* Num of transmitted messages */
> +       unsigned int rxMsgs;            /* Num of received messages */
> +       unsigned int txNodes;           /* Num of receiver nodes */
> +       unsigned int rxNodes;           /* Num of transmitter nodes */
> +       unsigned int txTimeout;         /* Num of unsuccessful transmissions */
> +       unsigned int rxTimeout;         /* Num of partial message receptions */
> +       unsigned int txRetries;         /* Num of resends */
> +       unsigned int rxDiscardedFrags;  /* Num of discarded fragments */
> +       unsigned int crcErrors;         /* Num of crc errors detected */

Is there any strong reason to have this camel case naming?
I would prefer tx_msgs, rx_msgs etc..

> +struct udpcp_dest {
> +       struct list_head list;
> +       struct sk_buff_head xmit;
> +       unsigned long tx_time;
> +       unsigned long rx_time;
> +       u32 txTimeout;
> +       u32 rxTimeout;

Here you have mixed naming conventions. I guess
tx_timeout will fit in better than txTimeout.

> +       u32 txRetries;
> +       u32 rxDiscardedFrags;
> +       struct sk_buff *xmit_wait;
> +       struct sk_buff *xmit_last;
> +       struct sk_buff *recv_msg;
> +       struct sk_buff *recv_last;
> +       struct udpcphdr lastmsg;
> +       struct ipcm_cookie ipc;
> +       struct flowi fl;
> +       struct rtable *rt;
> +       __be32 addr;
> +       __be16 port;
> +       u16 msgid;
> +       u8 use_flag;
> +       u8 insync;
> +       u8 ackmode;
> +       u8 chkmode;
> +       u8 try;
> +       u8 acks;
> +       struct udp_sock udpsock;
> +       struct sk_buff_head assembly;
> +       u32 assembly_len;
> +       struct udpcp_dest *assembly_dest;
> +       wait_queue_head_t wq;
> +       struct list_head destlist;
> +       struct list_head udpcplist;
> +       struct timer_list timer;
> +       struct udpcp_statistics stat;
> +       u32 pending;
> +       unsigned long tx_timeout;
> +       unsigned long rx_timeout;
> +       void (*udp_data_ready) (struct sock *sk, int bytes);
> +       u8 ackmode;
> +       u8 chkmode;
> +       u8 maxtry;
> +       u8 acks;
> +       u8 timeout;
> +/* overall UDPCP statistics */
> +static atomic_t udpcp_txMsgs;
> +static atomic_t udpcp_rxMsgs;
> +static atomic_t udpcp_txNodes;
> +static atomic_t udpcp_rxNodes;
> +static atomic_t udpcp_txTimeout;
> +static atomic_t udpcp_rxTimeout;
> +static atomic_t udpcp_txRetries;
> +static atomic_t udpcp_rxDiscardedFrags;
> +static atomic_t udpcp_crcErrors;

same here.

> +
> +module_param(debug, int, 0);
> +MODULE_PARM_DESC(debug, "Debug enabled or not");
> +

thanks,
Daniel.
