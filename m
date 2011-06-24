Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1FXQeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 12:34:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1FXQeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 12:34:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: {PATCH] fix __packed in exported kernel headers
Date: Fri, 24 Jun 2011 18:33:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Michal Marek <mmarek@suse.cz>, Joe Perches <joe@perches.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
References: <20110622063441.GA1740@x4.trippels.de> <4E048C0D.7020403@suse.cz> <20110624135100.GB1708@x4.trippels.de>
In-Reply-To: <20110624135100.GB1708@x4.trippels.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201106241833.15424.arnd@arndb.de>
X-Provags-ID: V02:K0:MVI5loaP3Ao+eIsc5byEtQimoJZo2FuFeU05bjcNdJ1
 eGtE97OYi/pBufUO8TBYKCcvbh4W84d373DVnnzZDJTyWzZokP
 XMNYgAc/h3C1is1/w9T4CxLnTeLq4insYoDoK593dI4kIQEf96
 gh3v7BEwTAZV1TK4lu5q3+/Kuc0xDs+Q0scWZcBGJeLoj1TrtP
 3cOJvzXoP52RLek70F3aA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 June 2011, Markus Trippelsdorf wrote:
> checkpatch.pl warns about using __attribute__((packed)) in kernel
> headers: "__packed is preferred over __attribute__((packed))". If one
> follows that advice it could cause problems in the exported header
> files, because the outside world doesn't know about this shortcut.
> 
> For example busybox will fail to compile:
>  CC      miscutils/ubi_attach_detach.o
>  In file included from miscutils/ubi_attach_detach.c:27:0:
>  /usr/include/mtd/ubi-user.h:330:3: error: conflicting types for ‘__packed’
>  /usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
> ...
> 
> Fix the problem by substituting __packed with __attribute__((packed)) in
> the header_install.pl script.

No objections to the patch, but it should probably be noted that user
visible data structures should ideally not have any attributes, because
that requires building all applictions using that interface with gcc.

We generally try to add no such requirements on user applications.

	Arnd
