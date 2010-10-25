Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab0JYNbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:31:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50351 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab0JYNbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:31:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [microblaze-uclinux] Re: [PATCH v2 22/22] bitops: remove minix bitops from asm/bitops.h
Date: Mon, 25 Oct 2010 15:31:35 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com> <AANLkTikgRWWH0RhR2S5cFE+jkJbW30Arwsjic4UANuVd@mail.gmail.com> <4CC4C1B4.9090907@monstr.eu>
In-Reply-To: <4CC4C1B4.9090907@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010251531.35485.arnd@arndb.de>
X-Provags-ID: V02:K0:dQPmYAkkSV2eurA52YOFlyc12IMKEGSkFerCCZtDIUo
 gJj6oWj6WbvTrWhPcuHLiY6G0M6fnMy02sa93VjOFCLgUTOep3
 lpQcr2JQwkIDYvWQedZSMsCdTnL40kBmQWCON8bDVDgnHWeVUV
 eVsdmpzp1V8iLe1A529er+IXqrvWqW153Y3us3RvxrY2EC/2hs
 L4d8teJA/C4mdnum4s+mA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 October 2010, Michal Simek wrote:
> > If upcomming microblade little-endian mode will use little-endian
> > bitmaps for minixfs, microblade can continue to select
> > CONFIG_MINIX_FS_NATIVE_ENDIAN and you don't need to change it.
> > 
> > But if it will use big-endian bitmaps, it may need some extra work
> > to support it. Becuase there is no little-endian architecture
> > which uses bit-endian bitmaps for minixfs.
> 
> As I wrote I don't know anybody who wants to use minixfs that's why we don't
> need to do anything with it. I can test it but it has no high priority.

I think it needs to be set up in a way that new architectures (and those
that never cared about minixfs) automatically get a reasonable default
and should not need to set anything.

I don't see a reason why little-endian microblaze should use big-endian
bitops in minixfs, since that file system layout would also be incompatible
with every other one.

CONFIG_MINIX_FS_NATIVE_ENDIAN seems reasonable for both big- and little-
endian microblaze, but new architectures should just keep the default
little-endian bitops IMHO.
I also don't see a reason for testing. Any new users on microblaze or
future architectures would use a modern file system anyway.

	Arnd
