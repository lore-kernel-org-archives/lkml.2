Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab2BWAO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:14:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53238 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab2BWAOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:14:25 -0500
Message-ID: <4F4584C3.3040508@zytor.com>
Date: Wed, 22 Feb 2012 16:13:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Hitoshi Mitake <h.mitake@gmail.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: segmentation fault of modpost
References: <CAMO-S2gHb1fTvELVuBJ6ew+6WRRuUs8qWRX1HkvcCk1eB-Tpfg@mail.gmail.com>
In-Reply-To: <CAMO-S2gHb1fTvELVuBJ6ew+6WRRuUs8qWRX1HkvcCk1eB-Tpfg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 11:17 PM, Hitoshi Mitake wrote:
> Hi,
> 
> I tried to build tip-tree with allmodconfig and ARCH=i386 on x86_64 machine.
> And modpost caused segmentation fault like this:
> modpost[23652]: segfault at 2b53bece3000 ip 00000000004030bb sp
> 00007ffffad8d260 error 4 in modpost[400000+d000]
> # from dmesg
> 
> The commit of -tip tree is 64256eb8e9f8cd53100ee6142968df336c54eb32.
> 
> Is this problem already reported or solved?
> If not, I'd like to solve this because I need to build all{mod,yes}config
> kernel for testing readq/writeq of x86.
> 

I cannot reproduce this on a Fedora 15 development system.  I have to
turn off two modules:

CONFIG_SCx200HR_TIMER=n
CONFIG_ANDROID_BINDER_IPC=n

... but modpost runs just fine.  It would be good if you could compile
modpost with -g and see where in the code the failure happens.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

