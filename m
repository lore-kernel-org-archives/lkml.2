Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030611Ab2CAKZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:25:01 -0500
Received: from mail-pw0-f66.google.com ([209.85.160.66]:65247 "EHLO
	mail-pw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab2CAKY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:24:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.219.234 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120301102341.GC6488@1984>
References: <1330593466-19317-1-git-send-email-santoshprasadnayak@gmail.com>
	<20120301102341.GC6488@1984>
Date: Thu, 1 Mar 2012 15:54:58 +0530
Message-ID: <CAOD=uF6T-POkOORw6_S7_NtHgLX4GJj_9A8tg4QRCc8=gCvFaA@mail.gmail.com>
Subject: Re: [PATCH 3/3] netfilter: Remove redundant code.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: bart.de.schuymer@pandora.be, kaber@trash.net, shemminger@vyatta.com,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please see last line of my 2nd patch.
I have added a new label "out" .


regards
santosh

On Thu, Mar 1, 2012 at 3:53 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Mar 01, 2012 at 02:47:46PM +0530, santosh nayak wrote:
>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>>
>> Remove the redundant code.
>>
>> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
>> ---
>>  net/bridge/netfilter/ebtables.c |   18 ++++++------------
>>  1 files changed, 6 insertions(+), 12 deletions(-)
>>
>> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
>> index 9c0f177..1efc234 100644
>> --- a/net/bridge/netfilter/ebtables.c
>> +++ b/net/bridge/netfilter/ebtables.c
>> @@ -226,10 +226,8 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
>>
>>               if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &acpar) != 0)
>>                       goto letscontinue;
>> -             if (acpar.hotdrop) {
>> -                     read_unlock_bh(&table->lock);
>> -                     return NF_DROP;
>> -             }
>> +             if (acpar.hotdrop)
>> +                     goto out;
>
> This is really broken! there's no "out" label in ebt_do_table as in
> the previous patch!
