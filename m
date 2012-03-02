Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030668Ab2CBVbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:31:40 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:38188 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758293Ab2CBVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:31:32 -0500
Message-ID: <4F513C2B.6030604@pandora.be>
Date: Fri, 02 Mar 2012 22:31:23 +0100
From: Bart De Schuymer <bdschuym@pandora.be>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: santosh nayak <santoshprasadnayak@gmail.com>, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        bart.de.schuymer@pandora.be, netfilter-devel@vger.kernel.org,
        shemminger@vyatta.com
Subject: Re: [Bridge] [PATCH 2/3] netfilter: potential null derefence.
References: <1330593434-19275-1-git-send-email-santoshprasadnayak@gmail.com> <20120301123004.GA7250@1984>
In-Reply-To: <20120301123004.GA7250@1984>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 120302-1, 02/03/2012), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 1/03/2012 13:30, Pablo Neira Ayuso schreef:
> On Thu, Mar 01, 2012 at 02:47:14PM +0530, santosh nayak wrote:
>> From: Santosh Nayak<santoshprasadnayak@gmail.com>
>>
>> I am getting following error.
>> " net/bridge/netfilter/ebtables.c:269 ebt_do_table()
>>    error: potential null derefence 'cs'"
>>
>>      i = cs[sp].n;  // If cs == Null then this will cause problem.
>
> Very sorry, I didn't see the out label.
>
> I'll apply this to my nf [1] once David takes my previous request for
> pulling.
>

Hi,

Has this patch been tested? Really, that code in the core firewall 
function is there for a reason, wouldn't you think?
The chainstack is only allocated when user-defined chains are used (see 
translate_table).
Never blindly trust a tool.

Bart
