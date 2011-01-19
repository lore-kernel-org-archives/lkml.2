Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1ASGUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 01:20:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab1ASGUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 01:20:17 -0500
Message-ID: <4D36828C.5030601@redhat.com>
Date: Wed, 19 Jan 2011 14:19:56 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Yannick Heneault <yheneaul@matrox.com>,
        Matthew Garrett <mjg@redhat.com>, open@linux-sh.org,
        "\"list@linux-sh.org\"@zmta03.collab.prod.int.phx2.redhat.com:FRAMEBUFFER
	LAYER" <linux-fbdev@vger.kernel.org>
Subject: Re: [Patch] video: remove pointless comments in drivers/video/console/vgacon.c
References: <1295416803-17651-1-git-send-email-amwang@redhat.com> <20110119060257.GA12205@linux-sh.org> <4D367FD6.1010006@redhat.com> <20110119061551.GB12205@linux-sh.org>
In-Reply-To: <20110119061551.GB12205@linux-sh.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年01月19日 14:15, Paul Mundt 写道:
> On Wed, Jan 19, 2011 at 02:08:22PM +0800, Cong Wang wrote:
>> ??? 2011???01???19??? 14:02, Paul Mundt ??????:
>>> On Wed, Jan 19, 2011 at 02:00:02PM +0800, Amerigo Wang wrote:
>>>> Now vgacon_scrollback_startup() uses slab, not bootmem,
>>>> so that comment is obsolete, the rest are useless.
>>>>
>>>> Signed-off-by: WANG Cong<amwang@redhat.com>
>>>>
>>> If you're going to do this then at least follow through and do the rest
>>> of it. The comment is no longer applicable, but then neither is the
>>> __init_refok annotation. Killing off the comment explaining why something
>>> is (or was there) without killing off the thing that is referenced by the
>>> comment is not terribly productive.
>>
>> Isn't __init_refok already a clear sign of "silence modpost"?
>> Why need to comment it again?
>
> __init_refok was to silence what was presumably an alloc_bootmem()
> reference at the time that the slab allocations were not early enough to
> satisfy the allocation, necessitating the use of bootmem. Since kmalloc
> and friends became usable early enough and the bootmem allocation has
> subsequently been dropped, there's no longer any need for the annotation.
>
> ie, alloc_bootmem() itself is __init while vgacon_scrollback_startup() is
> not, hence the modpost complaint.

Ah, I see, will remove '__init_refok' as well.

Thanks!
