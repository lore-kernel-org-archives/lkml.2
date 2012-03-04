Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab2CDEaj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 23:30:39 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55464 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2CDEah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 23:30:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of yuehaixu@gmail.com designates 10.236.146.6 as permitted sender) smtp.mail=yuehaixu@gmail.com; dkim=pass header.i=yuehaixu@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330819855.8460.291.camel@deadeye>
References: <CAEc1PS1j2DL4m7B1Rp9nseqLWsxaXXY+ZJDHra+99c5-WPgYcQ@mail.gmail.com>
	<1330819855.8460.291.camel@deadeye>
Date: Sat, 3 Mar 2012 23:30:36 -0500
Message-ID: <CAEc1PS0OhdbVD_tUurNO2rk_w_VSewSNWirq2w6LwZCsZoBisQ@mail.gmail.com>
Subject: Re: How do I know my driver support RSS?
From: Yuehai Xu <yuehaixu@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, yhxu@wayne.edu, sbw@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 3, 2012 at 7:10 PM, Ben Hutchings <bhutchings@solarflare.com> wrote:
> On Sat, 2012-03-03 at 16:25 -0500, Yuehai Xu wrote:
> [...]
>> Since I read the following statements from a paper, "we use a separate
>> hardware receive and transmit queue for each core and configure the
>> IXGBE to inspect the port number in each incoming packet header, place
>> the packet on the queue dedicated to the associated memcached's core,
>> and deliver the receive interrupt to that core." and the background of
>> this configuration is that each memcached is pinned to a separate core
>> and has its own UDP port. It seems that IXGBE's driver can detect UDP
>> packets according to their port numbers and put these packets into
>> corresponding receive queues in the hardware, is this achieved by
>> configuring RSS in IXGBE? If it is, I am wondering whether bnx2
>> supports RSS and whether it can configure in the same way.
>>
>> I appreciate any help for this.
>
> You're confusing RSS (flow hashing) with flow steering.  These are both
> explained in Documentation/network/scaling.txt.
>
> Ben.
>
I appreciate your replying!! What confuses me is that for each UDP
socket with exclusive port number, it has RX queue in transport layer,
and network card might also have multiple RX queues. These two queues
are definitely different. So, is it possible to configure network card
to put packets to queues(RX queues in network card) according to hash?
I read the codes of RPS/RFS, it seems that packets are put into queues
in transport layer of sockets instead of queues in network card. Am I
correct?

I appreciate any replies.

Yuehai
