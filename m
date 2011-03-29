Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab1C2U0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 16:26:31 -0400
Received: from cable-static-216-94.intergga.ch ([87.102.216.94]:51102 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab1C2U0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:26:30 -0400
X-Spam-ASN: 
X-Spam-Spammy: 0.966-+--H*r:mail.ffwll.ch, 0.957-+--amazing,
	0.875-+--H*F:D*ffwll.ch
X-Spam-Hammy: 0.000-+--H*Ad:U*dri-devel, 0.000-+--HCc:D*freedesktop.org,
	0.000-+--HCc:D*lists.freedesktop.org
Date: Tue, 29 Mar 2011 22:26:08 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Lucas Stach <dev@lynxeye.de>, r6144 <rainy6144@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: GEM-related desktop sluggishness due to linear-time
 arch_get_unmapped_area_topdown()
Message-ID: <20110329202608.GA3454@viiv.ffwll.ch>
Mail-Followup-To: Jerome Glisse <j.glisse@gmail.com>,
	Lucas Stach <dev@lynxeye.de>, r6144 <rainy6144@gmail.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1301310995.5615.92.camel@wangqingchuan>
 <1301336010.2217.20.camel@workstation>
 <AANLkTikMJszEyv8-SMMjD-MeykSwmsKf=gmezcMgySoP@mail.gmail.com>
 <1301409864.5615.98.camel@wangqingchuan>
 <AANLkTi=fcWBpmQ66a3+vQwgFOXn=0rJAviNzR4a0mfcJ@mail.gmail.com>
 <1301421664.2151.12.camel@Portable-Work>
 <AANLkTin_v5h==E0i5mQgK2AEdaZhwViykr3acbz4CW0k@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin_v5h==E0i5mQgK2AEdaZhwViykr3acbz4CW0k@mail.gmail.com>
X-Operating-System: Linux viiv 2.6.38-08569-g16c29da 
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 03:45:34PM -0400, Jerome Glisse wrote:
> Short lived & small bo would definitly doesn't work well for this kind
> of API, it would all be a function of the ioctl cost. But i am not
> sure the drawback would be that big, intel tested with pread/pwrite
> and gived up don't remember why. For the vbo case you describe the
> scheme i was thinking would be : allocate bo and on buffer data call
> upload to the allocated bo using the bind user page feature that would
> mean zero extra copy operation. For the fire forget case of vbo,
> likely somekind of transient buffer would be more appropriate.

Just to clarify: Uploads to linear buffers are all done with pwrite (due
to an api foobar, it's not so great for 2d/tiled stuff). It's amazing how
much faster that is: Switching vbo's from mmpa to pwrite has given a few
percent more fps in openarena in i915g! As long as the chunk you're gonna
write fits into L1 cache, it's probably a net win.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
