Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030542Ab2CAKXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:23:32 -0500
Received: from mail-pw0-f66.google.com ([209.85.160.66]:40020 "EHLO
	mail-pw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030401Ab2CAKX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:23:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.225.194 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120301102136.GB6488@1984>
References: <1330593434-19275-1-git-send-email-santoshprasadnayak@gmail.com>
	<20120301102136.GB6488@1984>
Date: Thu, 1 Mar 2012 15:53:29 +0530
Message-ID: <CAOD=uF5O=VJheUhxg7zadpq8p+bqa_M2jiKE1mqLXz6JJps-sg@mail.gmail.com>
Subject: Re: [PATCH 2/3] netfilter: potential null derefence.
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

Hi Pablo,

Please look at the last line of my patch.
I have added a new label "out"

regards
santosh

On Thu, Mar 1, 2012 at 3:51 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Mar 01, 2012 at 02:47:14PM +0530, santosh nayak wrote:
>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>>
>> I am getting following error.
>> " net/bridge/netfilter/ebtables.c:269 ebt_do_table()
>>   error: potential null derefence 'cs'"
>>
>>     i = cs[sp].n;  // If cs == Null then this will cause problem.
>>
>> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
>> ---
>>  net/bridge/netfilter/ebtables.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
>> index f3fcbd9..9c0f177 100644
>> --- a/net/bridge/netfilter/ebtables.c
>> +++ b/net/bridge/netfilter/ebtables.c
>> @@ -209,8 +209,10 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
>>          smp_processor_id());
>>       if (private->chainstack)
>>               cs = private->chainstack[smp_processor_id()];
>> -     else
>> +     else {
>>               cs = NULL;
>> +             goto out;
>
> There is no "out" label in ebt_do_table !!
