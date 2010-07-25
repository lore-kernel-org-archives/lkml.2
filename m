Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0GYV3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:29:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34454 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0GYV3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=QPHogDUmiYi3zdvR9VY4I5pPyftzA2he9mESn6a8PFdFERqHpNPOXqbffvUZpGRffJ
         J1QKp2dLUCmZ5dk+1rAuJvHf2nxA3LPDFjrWZ5CVUwUt6UbRRS0zHeHIRq4IteV81Dtz
         DOHeyphfxSh44FnFLa4WSuL89NfjVJE6cQ2BM=
MIME-Version: 1.0
Date: Mon, 26 Jul 2010 05:29:04 +0800
Message-ID: <AANLkTinW8t9QdXwZdjESVh_fR64o6DXun_zSWa0HYXu6@mail.gmail.com>
Subject: why are there some redundant variable definition
From: Parmenides <mobile.parmenides@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I have read a macro like this
++++ include/linux/kernel.h
159: #define min_t(type,x,y) \
160: ({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
++++ net/ipv4/tcp_output.c
654: int full_space = min_t(int, tp->window_clamp, tcp_full_space(sk));

The definitions of __x and __y are somewhat redundant. I think a more
