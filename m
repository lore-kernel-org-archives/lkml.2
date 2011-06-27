Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab1F0P4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:56:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63089 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1F0P4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:56:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=FrxQQlLoCgQmH0vrVm0RLQAUzaWcSR+URrDAwcNS6WwnMZ3u5vGrDzUYHu4EpBtxlt
         tF2q3pZT5PDR6MF2ZE3wFBdqW26gQAawKnHVZX7gsRyAJQ3SFDQ0QP2XNkZ7I3eq4Gac
         ARBqV5zgXvIo794QU00nU7iqtYHnbIUaBsbjA=
MIME-Version: 1.0
In-Reply-To: <BANLkTin+pn=WSegcW7cnHk4=76wHkaHPCw@mail.gmail.com>
References: <BANLkTin+pn=WSegcW7cnHk4=76wHkaHPCw@mail.gmail.com>
From: Prateek Sharma <prateek3.14@gmail.com>
Date: Mon, 27 Jun 2011 21:25:55 +0530
Message-ID: <BANLkTi=eVDsTy0nU5nuiDC+SDe_rhCt3qg@mail.gmail.com>
Subject: Re: Linux 3.0-rc4 - fail to compile...
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will this issue be be please fixed in rc5 ? Not being able to even
compile it is a big hindrance.


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Paul Rolland (???・???)
>
> Sent: Tuesday, June 21, 2011 3:14 PM
> To: Linus Torvalds
> Cc: Linux Kernel Mailing List; rol@witbe.net
> Subject: Re: Linux 3.0-rc4 - fail to compile...
> Hello,
>
> On Mon, 20 Jun 2011 21:02:56 -0700
>
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> > Mostly the usual small driver one- (or few-) liners, and some bigger
> > changes to drm (and md). But also two new smallish drivers
>
> > (net/usb/kalmia.c, and the ADP8870 backlight driver). Some filesystem
> > fixes (btrfs, cifs, afs, xfs, nfsd).
>
> This is failing to compile on my machine :
> ...
>   CC      mm/page_cgroup.o
>   CC      fs/direct-io.o
>
> mm/page_cgroup.c: In function ‘page_cgroup_init’:
> mm/page_cgroup.c:308: error: implicit declaration of function ‘node_start_pfn’
> mm/page_cgroup.c:309: error: implicit declaration of function ‘node_end_pfn’
> make[1]: *** [mm/page_cgroup.o] Error 1
>
> make: *** [mm] Error 2
> make: *** Waiting for unfinished jobs....
>   CC      fs/mpage.o
>   CC      fs/ioprio.o
> This seems to be caused by arch/x86/include/asm/mmzone_64.h which only defines
> node_start_pfn and node_end_pfn if CONFIG_NUMA is set.
>
>
> Adding CONFIG_NUMA to my .config fixes the issue.
>
> Paul
