Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031036Ab2CAOFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 09:05:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45770 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030988Ab2CAOE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 09:04:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.225.194 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120301123540.GE25627@aemeltch-MOBL1>
References: <1330599561-20392-1-git-send-email-santoshprasadnayak@gmail.com>
	<20120301123540.GE25627@aemeltch-MOBL1>
Date: Thu, 1 Mar 2012 19:34:58 +0530
Message-ID: <CAOD=uF4LSS8nuKMNHGEH2JsVZHU0rntSxZjvNaa4oZrey1macw@mail.gmail.com>
Subject: Re: Resend: [PATCH] Bluetooth: Fix Endian Bug.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
        santosh nayak <santoshprasadnayak@gmail.com>, marcel@holtmann.org,
        padovan@profusion.mobi, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrei,

I could not get you.

Do you want me to resend the patch with subject,
  "[PATCH] Bluetooth: Fix network to host endian conversion for L2CAP
chan id."  ?



regards
santosh




On Thu, Mar 1, 2012 at 6:05 PM, Andrei Emeltchenko
<andrei.emeltchenko.news@gmail.com> wrote:
> Hi Santosh,
>
> On Thu, Mar 01, 2012 at 04:29:21PM +0530, santosh nayak wrote:
>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>>
>> Fix for endian bug.
>>
>> Fix for null dereferenced removed as it is already
>> submitted by Andrei.
>>
>> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
>> ---
>>  net/bluetooth/l2cap_sock.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> We prefer following commit log (this is the example)
>
> <------8<----------------------------------------------------------
> |  From: Santosh Nayak <santoshprasadnayak@gmail.com>
> |
> |  Fix network to host endian conversion for L2CAP chan id.
> |
> |  Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> |
> |  ---
> |          * v2 Fix for null dereferenced removed as it is already
> |          submitted by Andrei.
> |
> |    net/bluetooth/l2cap_sock.c |    5 +++--
> |    1 files changed, 3 insertions(+), 2 deletions(-)
> |
> <------8<----------------------------------------------------------
>
>
>>
>> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
>> index 401d942..86d5067 100644
>> --- a/net/bluetooth/l2cap_sock.c
>> +++ b/net/bluetooth/l2cap_sock.c
>> @@ -82,7 +82,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
>>       }
>>
>>       if (la.l2_cid)
>> -             err = l2cap_add_scid(chan, la.l2_cid);
>> +             err = l2cap_add_scid(chan, __le16_to_cpu(la.l2_cid));
>>       else
>>               err = l2cap_add_psm(chan, &la.l2_bdaddr, la.l2_psm);
>>
>> @@ -123,7 +123,8 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr, int al
>>       if (la.l2_cid && la.l2_psm)
>>               return -EINVAL;
>>
>> -     err = l2cap_chan_connect(chan, la.l2_psm, la.l2_cid, &la.l2_bdaddr);
>> +     err = l2cap_chan_connect(chan, la.l2_psm, __le16_to_cpu(la.l2_cid),
>> +                             &la.l2_bdaddr);
>
> I live this to Marcel to decide should we reindent our code otherwise this
> one looks odd.
>
> Best regards
> Andrei Emeltchenko
>
