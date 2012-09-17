Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab2IQQCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:02:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36951 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab2IQQCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:02:17 -0400
Date: Mon, 17 Sep 2012 09:02:11 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        tzanussi@gmail.com
Subject: Re: perf script: rwtop: SIGALRM and pipe read race
Message-ID: <20120917160211.GC31375@ghostprotocols.net>
References: <20120914153952.GA8834@turtle.usersys.redhat.com>
 <505355AF.7000006@gmail.com>
 <20120914181049.GA16618@turtle.usersys.redhat.com>
 <505739EF.5010000@gmail.com>
 <50573EC3.6020209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50573EC3.6020209@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 17, 2012 at 09:16:19AM -0600, David Ahern escreveu:
> On 9/17/12 8:55 AM, David Ahern wrote:
> >2. the rwtop.pl script is not handling negative return values ($ret < 0)
> >properly -- the '$ret > 0' check is succeeding even though $ret is
> >negative (e.g., -EAGAIN) leading to astronomical read values
> 
> I think perl is treating $ret as an unsigned integer.
> 
> Again, I know little about perl, but this change to
> ./scripts/perl/rwtop.pl makes it behave properly:
> 
>     my $n = sprintf("%d", $ret);
> 
>     if ($n > 0) {
>     ...

I think what you figured out makes sense, its the best we have and you
found it to get it back working, could you please send the two patches
properly signed-off, etc?

If Andrew could please test the patchset so that I could add his
Tested-by, that would be great,

Thanks,

- Arnaldo
