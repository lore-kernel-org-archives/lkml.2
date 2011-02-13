Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab1BNDwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 22:52:53 -0500
Received: from ozlabs.org ([203.10.76.45]:52451 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433Ab1BNDwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 22:52:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH v2] module: deal with alignment issues in built-in module parameters
Date: Mon, 14 Feb 2011 09:34:17 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        "Linux-Arch" <linux-arch@vger.kernel.org>
References: <1297123347-2170-1-git-send-email-dtor@vmware.com> <20110211220356.GA13504@dtor-ws.eng.vmware.com>
In-Reply-To: <20110211220356.GA13504@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102140934.17671.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Feb 2011 08:33:56 am Dmitry Torokhov wrote:
> >From 03f1332fc02af7af0d06ab409e3ec72107637845 Mon Sep 17 00:00:00 2001
> From: Dmitry Torokhov <dtor@vmware.com>
> Date: Mon, 7 Feb 2011 13:47:20 -0800
> Subject: [PATCH] module: deal with alignment issues in built-in module parameters
> 
> As DaveM said, we can't reliably put structures into independent
> objects, put them into a special section, and then expect array
> access over them (via the section boundaries) after linking the
> objects together to just "work" due to variable alignment choices
> in different situations. The only solution that seems to work
> reliably is to make an array of plain pointers to the objects in
> question and put those pointers in the special section.

I've applied this, but won't put it to linux-next.  I'll let it stew for
a bit longer unless someone actually reports a problem with the current
code.

Thanks,
Rusty.
