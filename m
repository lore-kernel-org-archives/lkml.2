Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab1FNNKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:10:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50224 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1FNNKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:10:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=d6xl9oK3QB1YmokXkKhQKb+44sOrd0KCocugDRGaydgMHxfUQHaW4ZgDEoPae7qWQf
         9oENA2MgpF8qLcpq3IacvoP1t4CGm2Mpf6pa4BCA6iuPpIxNdANxUqlRcLjjXLpW2jHm
         0dequQYWozRRAWpORzoqzDntyS+m6vxtNTW6A=
MIME-Version: 1.0
Date: Tue, 14 Jun 2011 15:10:49 +0200
Message-ID: <BANLkTiko+2AM8dq8jP5xjbTcCM63hBAK=A@mail.gmail.com>
Subject: Possible deadlock when suspending framebuffer
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed that a possible deadlock can happen when the current frame
buffering is being suspended and a new frambuffer device is being
registred at the same time.

When suspending the current frambuffer by doing : echo 1
>/sys/class/graphics/fb0/state, the kernel actually takes the
following locks in that order: console_lock, lock_fb_info (see
store_fbstate()).

However when a new framebuffer is coming in, the lock sequence is:
lock_fb_info (taken by do_remove_conflicting_framebuffer()),
console_lock() (taken by unbind_console).

I don't know how this should be fixed though...

Thanks
-- 
Francis
