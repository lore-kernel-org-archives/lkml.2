Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab0HQNmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:42:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54997 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0HQNmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:42:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] init/do_mounts.c: replace sys_mount() to do_mount()
Date: Tue, 17 Aug 2010 15:41:46 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1282048643-2475-1-git-send-email-namhyung@gmail.com> <201008171515.26175.arnd@arndb.de> <1282051520.1635.7.camel@leonhard>
In-Reply-To: <1282051520.1635.7.camel@leonhard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201008171541.47078.arnd@arndb.de>
X-Provags-ID: V02:K0:SuUjMR+x4Dl+gDizkawrz6P+IfuSgkc23c/R0Ob5PpG
 Qawe5AVHsPX9drJEulWbyNN0cGJO06rpzE9sNiPBDFhohiySf6
 Pq/delZ2EL3CjQgS7ubypJYt+WMEjRBcMtVlPrBUw41R3IipF8
 g2/Ywd8gdhIqlwa8EScFuLrokgQUTCP6o6GmuHooP+waTcmosL
 7ISbsDEkv+MiYXrO3vryg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010, Namhyung Kim wrote:
> 2010-08-17 (화), 15:15 +0200, Arnd Bergmann:
> > AFAICT there is no need for the copy at all here. The reason that sys_mount
> > copies to a separate page is that it gets passed an arbitrary-length user
> > input.
> 
> Right. But make sure to user options never exceed a page, do_mount() has
> following code:
> 
>         if (data_page)
>                 ((char *)data_page)[PAGE_SIZE - 1] = 0;

Hmm, how very unexpected...

Maybe you can fix that as well in the same patch and move this safeguard
into the copy_mount_options() function? I guess ideally we'd even mark
the arguments to do_mount() as pointers to const, but that might create
an excessive amount of churn.

	Arnd
