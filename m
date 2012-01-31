Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2AaVRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 16:17:09 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:52733 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2AaVRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 16:17:07 -0500
Date: Tue, 31 Jan 2012 16:15:35 -0500 (EST)
Message-Id: <20120131.161535.422381201029777577.davem@davemloft.net>
To: joe@perches.com
Cc: asharma@fb.com, bhelgaas@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, glommer@parallels.com, mingo@elte.hu,
        christoph.paasch@uclouvain.be
Subject: Re: [PATCH] net: Disambiguate kernel message
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328043341.8702.3.camel@joe2Laptop>
References: <1328040546.8012.6.camel@joe2Laptop>
	<4F285310.5060104@fb.com>
	<1328043341.8702.3.camel@joe2Laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 Jan 2012 13:15:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 31 Jan 2012 12:55:41 -0800

> On Tue, 2012-01-31 at 12:46 -0800, Arun Sharma wrote:
>> On 1/31/12 12:09 PM, Joe Perches wrote:
>> >> +	too_many_orphans = tcp_too_many_orphans(sk, shift);
>> >> +	out_of_socket_memory = tcp_out_of_memory(sk);
>> >> +	tcp_log_oom(too_many_orphans, out_of_socket_memory);
>> >> +	if (too_many_orphans || out_of_socket_memory) {
>> > Perhaps these repeated three lines should be a routine like:
>> > bool tcp_check_oom(struct sock *sk, int shift)
>> > {
>> > 	bool tcp_orphans = tcp_too_many_orphans(sk, shift);
>> > 	bool tcp_oom = tcp_out_of_memory(sk);
>> >
>> > 	printks...
>> >
>> > 	return tcp_orphans || tcp_oom;
>> > }
>> I like your previous suggestion better. It preserves the ability to write:
>> if (too_many_orphans) {
>>    do_something();
>> }
>> if (out_of_socket_memory) {
>>    do_something_else();
>> }
> 
> shrug. That isn't currently used and 
> tcp_too_many_orphans and tcp_out_of_memory
> could still be checked.
> 
> I think the routine could be moved out-of-line.

Indeed, and make the out-of-line combined routine (that does the test
as well as the conditional logging) return a boolean that determines
if the "if (too_many_orphans || out_of_socket_memory)" test should
pass.
