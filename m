Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab2BXKqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:46:15 -0500
Received: from zfrontend1.aha.ru ([195.2.83.147]:46181 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751766Ab2BXKqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:46:14 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: Re: [Bug #42669] 3.3-rc1: compiling problems nvme , l2cap_sock
 , mc13892-regulator , and snd-pcsp don't work
To: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        kernel-testers@vger.kernel.org, maciej.rutecki@gmail.com,
        florian@mickler.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 24 Feb 2012 06:48:58 -0400
Message-ID: <web-701709481@zbackend1.aha.ru>
In-Reply-To: <20120223.181904.501214130038312055.davem@davemloft.net>
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera>
 	<qCQH7HfZS8E.A.FVG.M9rRPB@chimera>
 <20120223.181904.501214130038312055.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But why then the error is still in the source code, at 
least until the last 3.3-rc4 ???  I also compiled the 
code, removing always inline from the line as in the 
patch, then it works.

Also, the other compiling errors what I reclaim about, 
aren't yet resolved.

This things happens, because people, after changes, nor 
compile them subroutines ...   :(   Much less,  test them 
...


W.Landgraf


=============================================================

On Thu, 23 Feb 2012 18:19:04 -0500 (EST)
  David Miller <davem@davemloft.net> wrote:
>From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Thu, 23 Feb 2012 23:51:25 +0100 (CET)
> 
>> This message has been generated automatically as a part 
>>of a summary report
>> of recent regressions.
>> 
>> The following bug entry is on the current list of known 
>>regressions
>> from 3.2.  Please verify if it still should be listed 
>>and let the tracking team
>> know (either way).
>> 
>> 
>> Bug-Entry	: 
>>http://bugzilla.kernel.org/show_bug.cgi?id=42669
>> Subject		: 3.3-rc1: compiling problems  nvme , 
>>l2cap_sock , mc13892-regulator , and snd-pcsp don't work
>> Submitter	: werner <w.landgraf@ru.ru>
>> Date		: 2012-01-20 18:52 (35 days old)
>> Message-ID	: <web-682421181@zbackend1.aha.ru>
>> References	: 
>>http://marc.info/?l=linux-kernel&m=132708923719565&w=2
> 
> The l2cap_sock problem is fixed in the net GIT tree by 
>commit:
> 
> --------------------
> commit 4aa832c27edf902130f8bace1d42cf22468823fa
> Author: Johan Hedberg <johan.hedberg@intel.com>
> Date:   Sun Jan 8 22:51:16 2012 +0200
> 
>    Bluetooth: Remove bogus inline declaration from 
>l2cap_chan_connect
>    
>    As reported by Dan Carpenter this function causes a 
>Sparse warning and
>    shouldn't be declared inline:
>    
>    include/net/bluetooth/l2cap.h:837:30 error: marked 
>inline, but without a
>    definition"
>    
>    Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>    Signed-off-by: Johan Hedberg 
><johan.hedberg@intel.com>
>    Acked-by: Marcel Holtmann <marcel@holtmann.org>
> 
> diff --git a/include/net/bluetooth/l2cap.h 
>b/include/net/bluetooth/l2cap.h
> index 68f5891..124f7cf 100644
> --- a/include/net/bluetooth/l2cap.h
> +++ b/include/net/bluetooth/l2cap.h
> @@ -834,7 +834,7 @@ int l2cap_add_scid(struct l2cap_chan 
>*chan,  __u16 scid);
> struct l2cap_chan *l2cap_chan_create(struct sock *sk);
> void l2cap_chan_close(struct l2cap_chan *chan, int 
>reason);
> void l2cap_chan_destroy(struct l2cap_chan *chan);
> -inline int l2cap_chan_connect(struct l2cap_chan *chan, 
>__le16 psm, u16 cid,
> +int l2cap_chan_connect(struct l2cap_chan *chan, __le16 
>psm, u16 cid,
> 								bdaddr_t *dst);
> int l2cap_chan_send(struct l2cap_chan *chan, struct 
>msghdr *msg, size_t len,
> 								u32 priority);
> diff --git a/net/bluetooth/l2cap_core.c 
>b/net/bluetooth/l2cap_core.c
> index faf0b11..980abdb 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -1120,7 +1120,7 @@ static struct l2cap_chan 
>*l2cap_global_chan_by_psm(int state, __le16 psm, bdaddr
> 	return c1;
> }
> 
> -inline int l2cap_chan_connect(struct l2cap_chan *chan, 
>__le16 psm, u16 cid, bdaddr_t *dst)
> +int l2cap_chan_connect(struct l2cap_chan *chan, __le16 
>psm, u16 cid, bdaddr_t *dst)
> {
> 	struct sock *sk = chan->sk;
> 	bdaddr_t *src = &bt_sk(sk)->src;
> 
> 

"werner" <w.landgraf@ru.ru>
---
Professional hosting for everyone - http://www.host.ru
