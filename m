Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab2IQQcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:32:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40226 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2IQQck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:32:40 -0400
Message-ID: <505750A4.9080207@gmail.com>
Date: Mon, 17 Sep 2012 10:32:36 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        tzanussi@gmail.com
Subject: Re: perf script: rwtop: SIGALRM and pipe read race
References: <20120914153952.GA8834@turtle.usersys.redhat.com> <505355AF.7000006@gmail.com> <20120914181049.GA16618@turtle.usersys.redhat.com> <505739EF.5010000@gmail.com> <50573EC3.6020209@gmail.com> <20120917160211.GC31375@ghostprotocols.net>
In-Reply-To: <20120917160211.GC31375@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/12 10:02 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Sep 17, 2012 at 09:16:19AM -0600, David Ahern escreveu:
>> On 9/17/12 8:55 AM, David Ahern wrote:
>>> 2. the rwtop.pl script is not handling negative return values ($ret < 0)
>>> properly -- the '$ret > 0' check is succeeding even though $ret is
>>> negative (e.g., -EAGAIN) leading to astronomical read values
>>
>> I think perl is treating $ret as an unsigned integer.
>>
>> Again, I know little about perl, but this change to
>> ./scripts/perl/rwtop.pl makes it behave properly:
>>
>>      my $n = sprintf("%d", $ret);
>>
>>      if ($n > 0) {
>>      ...
>
> I think what you figured out makes sense, its the best we have and you
> found it to get it back working, could you please send the two patches
> properly signed-off, etc?

I'll do that for the readn.

The above change seems like a workaround - not a proper fix. Why is perl 
treating it like an unsigned int? The trace format for the read syscall 
shows long. How is the binding done for perl? I can't make heads or 
tails of it scanning the files under perl. If we are forced to do a hack 
like the above is there a better way? I tried (int) $ret and perl did 
not like that. Any other (better) options?

David

