Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab2EVBVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:21:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:48090 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2EVBVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:21:04 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-c2-4fbae9ff1189
Message-id: <4FBAE9FE.9030807@samsung.com>
Date: Tue, 22 May 2012 10:21:02 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-version: 1.0
To: Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix null pointer dereference in l2cap_chan_send
References: <4FB9932B.9070101@samsung.com> <20120521161707.GD16942@joana>
In-reply-to: <20120521161707.GD16942@joana>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jAd3/L3f5G6x/xGkx51ofs8XlXXPY
	LI4tEHNg9vi8SS6AMYrLJiU1J7MstUjfLoErY+m3pewFrewV97o+MTYwXmHtYuTkkBAwkfhw
	opsdwhaTuHBvPVsXIxeHkMAiRol1B0ESIM5bRon5u94ygVTxCmhJ9Ex6yQhiswioStz/c4kN
	xGYTUJa4++wW2FRRgTCJ11MOsUDUC0r8mHyPBWSQiEAjk0Tzp36wZmEBf4k/ixeCNQgJeEo8
	XTQX7AxOAW2JNV3rwZYxC+hI7G+dxgZhy0tsXvOWeQIj/ywkc2chKZuFpGwBI/MqRtHUguSC
	4qT0XEO94sTc4tK8dL3k/NxNjODweya1g3Flg8UhRgEORiUe3oBLu/yFWBPLiitzDzFKcDAr
	ifBuagMK8aYkVlalFuXHF5XmpBYfYpTmYFES57VbvMNfSCA9sSQ1OzW1ILUIJsvEwSnVwNg4
	MbZFf1/cMyPmJr/SyB07Pjw8E9wcGD0l1NTA63tlFjeXea9v4ITq+z9MLdXMOtevXcD6T/TB
	PDfJ2vBJc5/Uq+w4bRG04Wg578NJJZ8kaxekP9Jdv7DaRrajuOhEfEmQ0qTwZzzzmfcv/f0k
	xHM6f8qbpUn/p2xkfqKmN4/vwq6uq4lGskosxRmJhlrMRcWJAAT5j4k7AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 01:17 AM, Gustavo Padovan wrote:
> Hi Minho,
> 
> * Minho Ban <mhban@samsung.com> [2012-05-21 09:58:19 +0900]:
> 
>> If l2cap_chan_send is called will null conn it will cause kernel Oops.
>> This patch checks if conn is valid before entering l2cap_chan_send.
> 
> chan->conn should be always valid, and if not we have a bug somewhere else in
> the code and not in l2cap_chan_send(). It could be a locking problem maybe.
> Also check if you can reproduce this with latest bluetooth-next.
> 
> 	Gustavo
> 

Thanks for comment. I'm using bluetooth-next backporting to kernel 3.0
I wonder how do we guarantee chan->conn is valid if other thread release chan->lock
just after exit l2cap_chan_del.
It seem l2cap_chan_del is well protected with various mutex (eg, sk, conn, chan) but
that may not enough to prevent lock waiters from accessing object.

Regards,
Minho Ban
