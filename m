Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab2FOIgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 04:36:39 -0400
Received: from mx0.aculab.com ([213.249.233.131]:36329 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753060Ab2FOIgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 04:36:35 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC] Introduce to batch variants of accept() and epoll_ctl() syscall
Date: Fri, 15 Jun 2012 09:35:29 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6F4D@saturn3.aculab.com>
In-Reply-To: <4FDAB652.6070201@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [RFC] Introduce to batch variants of accept() and epoll_ctl() syscall
thread-index: Ac1KrRBoF3+QXM6hSDWQKmZkkQnn6AAIyPTA
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Li Yu" <raise.sail@gmail.com>,
        "Linux Netdev List" <netdev@vger.kernel.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        <davidel@xmailserver.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
>   We encounter a performance problem in a large scale computer
> cluster, which needs to handle a lot of incoming concurrent TCP
> connection requests.
> 
>   The top shows the kernel is most cpu hog, the testing is simple,
> just a accept() -> epoll_ctl(ADD) loop, the ratio of cpu util sys% to
> si% is about 2:5.
> 
>   I also asked some experienced webserver/proxy developers in my team
> for suggestions, it seem that behavior of many userland 
> programs already
> called accept() multiple times after it is waked up by
> epoll_wait(). And the common action is adding the fd that accept()
> return into epoll interface by epoll_ctl() syscall then.
> 
>   Therefore, I think that we'd better to introduce to batch 
> variants of
> accept() and epoll_ctl() syscall, just like sendmmsg() or recvmmsg().
...

Having seen the support added to NetBSD for sendmmsg() and
recvmmsg() (and I'm told the linux code is much the same),
I'm surprised that just cutting out a system call entry/exit
and fd lookup is significant above the rest of the costs
involved in sending a message (which I presume is UDP here).
I'd be even more surprised if it is significant for an
incoming connection.

	David


