Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab1FXRBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 13:01:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34419 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1FXRBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 13:01:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=V3fgAsleH5lq9nUe1SS0wroXH473XP79Mlbn74bsRZzFJOtEET4HI3U/n54Sknun+d
         d6g/LY8ZM9KiW57x/sXPwcvEwc0QhmOIpNwnlZbskCUq103h5tVx/tpIMr7t+gPK8EUe
         oWEIDx3gdnsXf4TJ/RVwLeO8G59Bq7IkLiRFc=
MIME-Version: 1.0
In-Reply-To: <201106241833.15424.arnd@arndb.de>
References: <20110622063441.GA1740@x4.trippels.de> <4E048C0D.7020403@suse.cz>
 <20110624135100.GB1708@x4.trippels.de> <201106241833.15424.arnd@arndb.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 24 Jun 2011 13:00:44 -0400
X-Google-Sender-Auth: T7vZPyOU7vnT7AL2pSYVCMHmy4Y
Message-ID: <BANLkTi=9e-it8nd2s-vcbEfc1h8tnSmj8A@mail.gmail.com>
Subject: Re: {PATCH] fix __packed in exported kernel headers
To: Arnd Bergmann <arnd@arndb.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Michal Marek <mmarek@suse.cz>, Joe Perches <joe@perches.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 12:33, Arnd Bergmann wrote:
> On Friday 24 June 2011, Markus Trippelsdorf wrote:
>> checkpatch.pl warns about using __attribute__((packed)) in kernel
>> headers: "__packed is preferred over __attribute__((packed))". If one
>> follows that advice it could cause problems in the exported header
>> files, because the outside world doesn't know about this shortcut.
>>
>> For example busybox will fail to compile:
>>  CC      miscutils/ubi_attach_detach.o
>>  In file included from miscutils/ubi_attach_detach.c:27:0:
>>  /usr/include/mtd/ubi-user.h:330:3: error: conflicting types for ‘__packed’
>>  /usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
>> ...
>>
>> Fix the problem by substituting __packed with __attribute__((packed)) in
>> the header_install.pl script.
>
> No objections to the patch, but it should probably be noted that user
> visible data structures should ideally not have any attributes, because
> that requires building all applictions using that interface with gcc.
>
> We generally try to add no such requirements on user applications.

the only real solution there is to export the compiler.h headers too

plus, many compilers nowadays (like icc/llvm) tend to include support
for common gcc attributes ...
-mike
