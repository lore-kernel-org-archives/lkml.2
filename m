Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574Ab1FXPRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 11:17:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758870Ab1FXPRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 11:17:34 -0400
Message-ID: <4E04AA89.9030909@suse.cz>
Date: Fri, 24 Jun 2011 17:17:29 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Joe Perches <joe@perches.com>, Nick Bowler <nbowler@elliptictech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: {PATCH] fix __packed in exported kernel headers
References: <20110622063441.GA1740@x4.trippels.de> <20110623134209.GA10813@elliptictech.com> <20110623150209.GA12413@x4.trippels.de> <1308848277.6688.7.camel@Joe-Laptop> <4E048C0D.7020403@suse.cz> <20110624135100.GB1708@x4.trippels.de>
In-Reply-To: <20110624135100.GB1708@x4.trippels.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.6.2011 15:51, Markus Trippelsdorf wrote:
> checkpatch.pl warns about using __attribute__((packed)) in kernel
> headers: "__packed is preferred over __attribute__((packed))". If one
> follows that advice it could cause problems in the exported header
> files, because the outside world doesn't know about this shortcut.
>
> For example busybox will fail to compile:
>   CC      miscutils/ubi_attach_detach.o
>   In file included from miscutils/ubi_attach_detach.c:27:0:
>   /usr/include/mtd/ubi-user.h:330:3: error: conflicting types for ‘__packed’
>   /usr/include/mtd/ubi-user.h:314:3: note: previous declaration of ‘__packed’ was here
> ...
>
> Fix the problem by substituting __packed with __attribute__((packed)) in
> the header_install.pl script.
>
> Cc: Artem Bityutskiy<Artem.Bityutskiy@nokia.com>
> CC: Joe Perches<joe@perches.com>
> Signed-off-by: Markus Trippelsdorf<markus@trippelsdorf.de>
> ---
>   scripts/headers_install.pl |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)

Thanks, applied to kbuild-2.6.git#kbuild.

Michal
