Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871Ab2KBJ0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:26:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60854 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab2KBJZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:25:59 -0400
MIME-Version: 1.0
Date: Fri, 2 Nov 2012 17:25:59 +0800
Message-ID: <CACV3sbLJ=ueYj+p_FKeNLB9Tbu33UJXPW12n1ZKVU+bgMLA1Zw@mail.gmail.com>
Subject: [BUG] arm: perf probe can not get __copy_to_user callchain symbol
From: Jovi Zhang <bookjovi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

In ARM, It seems that we cannot get __copy_to_user callchain symbol,
like below output,

I guess it due to function __copy_to_user don't compile with unwind
info, is this right?(not sure)

If the problem is relate with unwind info, is there anybody can make a
patch on this? I'm not familiar with unwind stuff very much.
thanks very much.


#perf record -e probe:__copy_to_user* -g -a ls

# Events: 677  probe:__copy_to_user
#
# Overhead  Command      Shared Object          Symbol
# ........  .......  .................  ..............
#
    93.50%     perf  [kernel.kallsyms]  [k] __copy_to_user
               |
               --- __copy_to_user
                  |
                  |--29.38%-- 0xffffffff
                  |          0xc0b00604
                  |
                  |--21.80%-- (nil)
                  |          |
                  |          |--92.03%-- 0xc0b00604
                  |          |
                  |          |--5.07%-- 0xc0af1bcc
                  |          |
                  |          |--1.45%-- 0xc0ab83b4
                  |          |
                  |          |--0.72%-- 0xc0af5a20
                  |          |
                  |           --0.72%-- 0xc0b0c8b0
                  |
                  |--19.91%-- 0xc0b0c8b0
                  |
                  |--19.91%-- 0xc0af5a20
                  |
                  |--8.53%-- 0xc0b0c658
                   --0.47%-- [...]
