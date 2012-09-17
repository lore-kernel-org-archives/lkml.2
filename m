Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab2IQPQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:16:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34058 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab2IQPQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:16:22 -0400
Message-ID: <50573EC3.6020209@gmail.com>
Date: Mon, 17 Sep 2012 09:16:19 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>, acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, tzanussi@gmail.com
Subject: Re: perf script: rwtop: SIGALRM and pipe read race
References: <20120914153952.GA8834@turtle.usersys.redhat.com> <505355AF.7000006@gmail.com> <20120914181049.GA16618@turtle.usersys.redhat.com> <505739EF.5010000@gmail.com>
In-Reply-To: <505739EF.5010000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/12 8:55 AM, David Ahern wrote:
> 2. the rwtop.pl script is not handling negative return values ($ret < 0)
> properly -- the '$ret > 0' check is succeeding even though $ret is
> negative (e.g., -EAGAIN) leading to astronomical read values

I think perl is treating $ret as an unsigned integer.

Again, I know little about perl, but this change to 
./scripts/perl/rwtop.pl makes it behave properly:

     my $n = sprintf("%d", $ret);

     if ($n > 0) {
     ...

David
