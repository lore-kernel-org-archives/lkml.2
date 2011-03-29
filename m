Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab1C2SBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 14:01:08 -0400
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:48531 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751782Ab1C2SBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:01:07 -0400
Subject: Re: GEM-related desktop sluggishness due to linear-time
 arch_get_unmapped_area_topdown()
From: Lucas Stach <dev@lynxeye.de>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: r6144 <rainy6144@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
In-Reply-To: <AANLkTi=fcWBpmQ66a3+vQwgFOXn=0rJAviNzR4a0mfcJ@mail.gmail.com>
References: <1301310995.5615.92.camel@wangqingchuan>
	 <1301336010.2217.20.camel@workstation>
	 <AANLkTikMJszEyv8-SMMjD-MeykSwmsKf=gmezcMgySoP@mail.gmail.com>
	 <1301409864.5615.98.camel@wangqingchuan>
	 <AANLkTi=fcWBpmQ66a3+vQwgFOXn=0rJAviNzR4a0mfcJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 20:01:04 +0200
Message-ID: <1301421664.2151.12.camel@Portable-Work>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 29.03.2011, 11:23 -0400 schrieb Jerome Glisse:
> 2011/3/29 r6144 <rainy6144@gmail.com>:
> > 在 2011-03-29二的 10:22 -0400，Jerome Glisse写道：
> >
> >> Killer solution would be to have no mapping and a decent
> >> upload/download ioctl that can take userpage.
> >
> > Doesn't this sound like GEM's read/write interface implemented by e.g.
> > the i915 driver?  But if I understand correctly, a mmap-like interface
> > should still be necessary if we want to implement e.g. glMapBuffer()
> > without extra copying.
> >
> > r6144
> >
> >
> glMapBuffer should not be use, it's really not a good way to do stuff.
> Anyway the extra copy might be unavoidable given that sometime the
> front/back might either be in unmappable vram or either have memory
> layout that is not the one specify at buffer creation (this is very
> common when using tiling for instance). So even considering MapBuffer
> or a like function i believe it's a lot better to not allow buffer
> mapping in userspace but provide upload/download hooks that can use
> userpage to avoid as much as possible extra copy.
> 
> Cheers,
> Jerome
> 

Wouldn't this give us a performance penalty for short lived resources
like vbo's which are located in GART memory? Mmap allows us to write
directly to this drm controlled portion of sysram. With a copy based
implementation we would have to allocate the buffer in sysram just to
copy it over to another portion of sysram which seems a little insane to
me, but I'm not an expert here.

-- Lucas


