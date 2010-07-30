Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab0G3QP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 12:15:58 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2991 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab0G3QP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 12:15:56 -0400
Date: Fri, 30 Jul 2010 18:15:44 +0200
Message-Id: <201007301615.o6UGFill008660@xs8.xs4all.nl>
From: "Miquel van Smoorenburg" <mikevs@xs4all.net>
To: savinov.guram@gmail.com
Subject: Re: Get interface MAC address in sys_accept4() syscall
Cc: linux-kernel@vger.kernel.org
X-Newsgroups: lists.linux.kernel
In-Reply-To: <AANLkTin8vaiWTRTM+WzZ_PAWO6j-voP29n1jHfLv+=q3@mail.gmail.com>
References: <4C5211D6.3000406@gmail.com>
	<20100730071617.GA5638@cr0.nay.redhat.com>
	<AANLkTi=bSLALO0xP3kWgX9ipRBroDsqzXp6=kPuwMtW2@mail.gmail.com>
	<20100730100351.GC5638@cr0.nay.redhat.com>
Organization: 
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <AANLkTin8vaiWTRTM+WzZ_PAWO6j-voP29n1jHfLv+=q3@mail.gmail.com> you write:
>Yes, I know, but sys_accept4() have int fd argument, that is socket
>descriptor, can I work with it like raw socket and get MAC from
>ethernet frame?

You can do getsockname(2) on the socket and you'll get the IP address
of the local interface.

You can then use getifaddrs(3) to get a list of local interfaces,
loop over all of them, and compare the IP address to the one you got
from getsockame().

Once you have the name of the interface, loop over the results
from getifaddrs() again, and find the AF_PACKET address of that
interface. The AF_PACKET address has the MAC address. See packet(7).

Mike.
