Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447Ab2EWBji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:39:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63494 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760399Ab2EWBjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:39:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7faf6d000001f49-2c-4fbc3fd79d65
Message-id: <4FBC3FD6.6050704@samsung.com>
Date: Wed, 23 May 2012 10:39:34 +0900
From: Minho Ban <mhban@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
To: Chanyeol Park <chanyeol.park@samsung.com>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] Bluetooth: prevent double l2cap_chan_destroy
References: <4FB992C8.8090105@samsung.com> <20120521162137.GE16942@joana>
 <4FBAFEF5.2000207@samsung.com> <4FBB8544.3040408@samsung.com>
In-reply-to: <4FBB8544.3040408@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t9jAd3r9nv8DX7cErSYc62P2eLyrjls
	FscWiDkwe3zeJBfAGMVlk5Kak1mWWqRvl8CVMeXtBsaCuawVXx6sZ21gvMjcxcjJISFgIrHw
	63cmCFtM4sK99WwgtpDAIkaJyzM0QWxeAUGJH5PvsXQxcnAwC8hLHLmUDRJmFlCXmDRvETNE
	+VtGia3TGCHKtST2b3nDClLOIqAq8e5jLkiYTUBZ4u6zW6wgtqhAmMTrKYfAJooI6Er87aiC
	mNjIJPH2sTKILSzgKtG4eQtQCRfQ9E5GiVn3nrODJDgFtCWWHXvNPIFRYBaS42YhHDcLyXEL
	GJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH4jPpHYyrGiwOMQpwMCrx8L6w2OMvxJpY
	VlyZe4hRgoNZSYR3/fTd/kK8KYmVValF+fFFpTmpxYcYpTlYlMR5nyzZ4S8kkJ5YkpqdmlqQ
	WgSTZeLglGpgdAi6VVa11Uhn73v/KQ84k9k23mx6H8e3K2JziK2T/7oDkhLTr06v5PO6s6Np
	LtPGK41KdcoiL/v6snbcT7g1+4Dq398KUyzEOVvv3NtzSDb0XMXiHecdV9/e8ujOyWX7p0Z0
	N/fKG0WlVDuFKLrn9BfEfPvSzLxBL6RMRMZm+ayQoDzBdvNuJZbijERDLeai4kQAkxYc4kEC	AAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 09:23 PM, Chanyeol Park wrote:
> Hi
> 
> On 2012년 05월 22일 11:50, Minho Ban wrote:
>> @@ -1343,10 +1343,10 @@ static void l2cap_conn_del(struct hci_conn *hcon, int err)
>>                  l2cap_chan_lock(chan);
>>
>>                  l2cap_chan_del(chan, err);
>> +               chan->ops->close(chan->data);
>>
>>                  l2cap_chan_unlock(chan);
>>
>> -               chan->ops->close(chan->data);
>>                  l2cap_chan_put(chan);
>>          }
> I think this patch does not make sense Because inside chan->ops->close() "chan" could be freed in the l2cap_chan_destroy().
> 

I agree, thanks for pointing out.
