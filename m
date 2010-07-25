Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab0GYVo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:44:56 -0400
Received: from xenotime.net ([72.52.115.56]:35139 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752139Ab0GYVoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:44:54 -0400
Date: Sun, 25 Jul 2010 14:44:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Parmenides <mobile.parmenides@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: why are there some redundant variable definition
Message-Id: <20100725144447.32f4b5b3.rdunlap@xenotime.net>
In-Reply-To: <AANLkTinW8t9QdXwZdjESVh_fR64o6DXun_zSWa0HYXu6@mail.gmail.com>
References: <AANLkTinW8t9QdXwZdjESVh_fR64o6DXun_zSWa0HYXu6@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jul 2010 05:29:04 +0800 Parmenides wrote:

> Hi,
>   I have read a macro like this
> ++++ include/linux/kernel.h
> 159: #define min_t(type,x,y) \
> 160: ({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
> ++++ net/ipv4/tcp_output.c
> 654: int full_space = min_t(int, tp->window_clamp, tcp_full_space(sk));
> 
> The definitions of __x and __y are somewhat redundant. I think a more
> --

The local variables __x and __y are used so that 'x' and 'y' are not
re-evaluated multiple times.  That could be a problem if either one of
them is an expression.

Anything else?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
