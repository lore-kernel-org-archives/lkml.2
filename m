Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab2I1KtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:49:04 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40965 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2I1KtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:49:03 -0400
MIME-Version: 1.0
From: Shantanu Gupta <shans95g@gmail.com>
Date: Fri, 28 Sep 2012 16:18:41 +0530
Message-ID: <CAPDArR+9Kd+Rzgxj9FgQR0NCayZskXkq4bg3U-GRpCKFP5uC+Q@mail.gmail.com>
Subject: xchg in fastpath for mutex unlock [mutex-xchg.h]
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am currently studying mutex(es) and was referring to linux sources
for it's implementation. However I noticed one shortcoming, in
"/include/asm-generic/mutex-xchg.h" of the master branch inside
__mutex_fastpath_trylock, Why doesn't the kernel use a cmpxchg instead
of dirtying the value with xchg ?

(The only thing that came to my mind was that x86_x64 implementation
mentioned that all x86_x64 cpu(s) have cmpxchg leading me to
assumption that certain archs can have xchg but not cmpxchg, so is it
this way just to work with architectures without a cmpxchg but with
xchg ?)

Thanks,
Rick
