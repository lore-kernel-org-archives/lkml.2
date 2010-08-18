Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0HRTV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:21:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65154 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0HRTV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=anJyFNrKzSlWZKcbqPlhe6R3gQI5fzvnZvppy8PFNojHBjizZNPmS7Xt87h5IT5WXj
         ZD18C1kIUoPtgIvnWJaKOMc8WsqntRZYxSn/IT/qhScZuPZwZ0nSmzcGJBvYdUFo0bDY
         QQjNTT+Fgqss2agoXfnPWhmP9YYRXS+MJF+8M=
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 18 Aug 2010 15:21:35 -0400
Message-ID: <AANLkTi=VzruV3RYLTwKnC0bYtR7fSKzGehV=LLzoicXE@mail.gmail.com>
Subject: nommu vm_get_page_prot and framebuffer drivers in 2.6.36-rc1
To: David Howells <dhowells@redhat.com>
Cc: uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the recent commit c07fbfd17e614a76b194f371c5331e21e6cffb54 added a
call to vm_get_page_prot() in drivers/video/fbmem.c.  but this
function doesnt exist for nommu.  so obviously we get:
ERROR: "vm_get_page_prot" [drivers/video/fb.ko] undefined!

looking a bit through mm/, i guess we should stub this out to 0 ?
#define vm_page_prot(x) 0
-mike
