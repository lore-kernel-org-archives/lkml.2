Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab0DYOaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 10:30:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:59414 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab0DYOaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 10:30:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Jongman Heo <jongman.heo@gmail.com>
Subject: Re: [2.6.34-rc5-git6] EIP: is at =?utf-8?b?aW5ldDZfY3NrX2JpbmRfY29uZmxpY3Q=?= + 06xe/0xb7 =?utf-8?b?CVtpcHY2XQ==?=
Date: Sun, 25 Apr 2010 14:26:12 +0000 (UTC)
Message-ID: <loom.20100425T162010-523@post.gmane.org>
References: <m2z2d0a357f1004250613of5215185z1490aaae7363b161@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 121.140.230.128 (Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; OfficeLiveConnector.1.3; OfficeLivePatch.0.0))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sedat Dilek <sedat.dilek <at> googlemail.com> writes:

> 
> Hi,
> 
> I have built today 2.6.34-rc5-git6 Linux-kernel on a 32-bit Debian/sid 
system.
> 
> Unfortunately, my machine hangs while startup at sshd-start (from
> memory + written down):
> 
> [...]
> EIP: is at inet6_csk_bind_conflict + 06xe/0xb7 [ipv6]
> Pid: 2150, comm: sshd Not tainted $(uname -r) #1 30AC/HP Compaq nc6400
> (RH72EA#ABD)
> [...]
> 
> I suspect one of the latest IPv6 commits as culprit, especially:
> 
> commit f4f914b58019f0e50d521bbbadfaee260d766f95
> net: ipv6 bind to device issue
> 
> ...or...
> commit f2228f785a9d97307aa8ba709088cfda6c3df73f
> ipv6: allow to send packet after receiving ICMPv6 Too Big message with
> MTU field less than IPV6_MIN_MTU
> 
> Could not test yet by reverting.
> 
> Kind Regards,
> - Sedat -
> 

I also hit this bug today.

Doing git bisect, first bad commit was

 commit fda48a0d7a8412cedacda46a9c0bf8ef9cd13559
 tcp: bind() fix when many ports are bound

Reverting above commit fixes the problem.

Regards.

