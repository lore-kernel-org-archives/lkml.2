Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1IVOdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:33:19 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60657 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1IVOdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:33:18 -0400
MIME-Version: 1.0
In-Reply-To: <201109212048.23074.rjw@sisk.pl>
References: <s5hmxdzyyzx.wl%tiwai@suse.de>
	<201109212048.23074.rjw@sisk.pl>
Date: Thu, 22 Sep 2011 07:33:17 -0700
X-Google-Sender-Auth: gUIMb6fK9gZGwHAy8XMRU8flyHo
Message-ID: <CAE9FiQVy4D0NhaN=PvPK_+L4Jv=+7huLy9U--LYW49GFZ9TyaQ@mail.gmail.com>
Subject: Re: S4 resume broken since 2.6.39 (3.1, too)
From: Yinghai Lu <yinghai.lu@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, oneukum@suse.de, x86@kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 11:48 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> It looks like init_memory_mapping() is sometimes called with "end"
> beyond the last mapped PFN and it explodes when we try to write stuff to
> that address during image restoration.
>
> IOW, the Yinghai's assumption that init_memory_mapping() would always be
> called with a "good end" on x86_64 was overomptimistic.

for 64bit x86, kernel_physical_mapping_init() will use
map_low_page()/call early_memmap() to access ram for page_table that is above
rather last mapped PFN.

the point is:
on system with 64g, usable ram will be [0,2048m), [4g, 64g)
init_memory_mapping will be called two times for them.
before putting page_table high,
page table will be two parts: one is just below 512M, and one below 2048m.
after putting page_table high,
page table will be two parts: one is just below 2048M, and one below 64G.

one of the purposes is finding biggest continuous big range under
1024m for kdump.

Thanks

Yinghai
