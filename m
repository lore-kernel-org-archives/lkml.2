Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2LYKzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 05:55:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55403 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab2LYKzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 05:55:01 -0500
Date: Tue, 25 Dec 2012 11:54:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Andy Furniss <andyqos@ukfsn.org>, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20121225105459.GB7692@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Shuah Khan <shuahkhan@gmail.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Andy Furniss <andyqos@ukfsn.org>,
	Alex Deucher <alexdeucher@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>
References: <CADnq5_Oe=_nOrsgUZvPc82F5CFAWecx=Uiqn0CAeK+YG3ns3AA@mail.gmail.com>
 <20121223105527.GA6230@liondog.tnic>
 <50D6E491.3030801@ukfsn.org>
 <20121223110730.GC6230@liondog.tnic>
 <50D6E8A4.1030204@ukfsn.org>
 <20121223113153.GA8918@liondog.tnic>
 <20121223115133.GA229@x4>
 <20121223122210.GA4460@liondog.tnic>
 <20121223133102.GA8153@liondog.tnic>
 <CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 09:50:11PM -0700, Shuah Khan wrote:
> Saw the same error and after reading this thread, reverted the
>
> Commit 2d6cc7296d4ee128ab0fa3b715f0afde511f49c2.
>
> drm/radeon: use async dma for ttm buffer moves on 6xx-SI
>
> and the problem is gone. In my case, it is a solid hang right after
> system switches to vga. I was able to login on console once or twice.
> But dmesg showed the same message reported in this thread:
>
> [ 35.812085] radeon 0000:01:00.0: GPU lockup CP stall for more than
> 10000msec [ 35.812091] radeon 0000:01:00.0: GPU lockup (waiting for
> 0x0000000000000002 last fence id 0x0000000000000001)
>
>
> My system has: 01:00.0 VGA compatible controller: Advanced Micro
> Devices [AMD] nee ATI RV620 [Mobility Radeon HD 3400 Series]

You can apply http://marc.info/?l=dri-devel&m=135628734704029 instead,
in the meantime. It partially reverts the above commit and if RV620 is a
R600 asic (it should be) then it would fix your observation too.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
