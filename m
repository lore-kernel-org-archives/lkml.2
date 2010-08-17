Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943Ab0HQNZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:25:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38036 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab0HQNZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:25:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AHnjmuRm9AWgEr0dDGkZcUy0bvRyHyTXCP+bmQbU/XKunOV0x6giWEiGfzvU4GXDug
         LB2pCYD2zjYz9SIWbV0gGHUT7UqM/uH/GIP/CFVtu0Qw9MpMW4ZpDDKzsNJafl00wYxH
         TzCgiZOZlLpVChjjhYmTu6ygFpIzNwq3hDBKI=
Subject: Re: [PATCH] init/do_mounts.c: replace sys_mount() to do_mount()
From: Namhyung Kim <namhyung@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <201008171515.26175.arnd@arndb.de>
References: <1282048643-2475-1-git-send-email-namhyung@gmail.com>
	 <201008171515.26175.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 22:25:20 +0900
Message-ID: <1282051520.1635.7.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-17 (화), 15:15 +0200, Arnd Bergmann:
> AFAICT there is no need for the copy at all here. The reason that sys_mount
> copies to a separate page is that it gets passed an arbitrary-length user
> input.
> 
> 	Arnd

Right. But make sure to user options never exceed a page, do_mount() has
following code:

	if (data_page)
		((char *)data_page)[PAGE_SIZE - 1] = 0;


-- 
Regards,
Namhyung Kim


