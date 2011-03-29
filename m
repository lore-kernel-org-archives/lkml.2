Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1C2VFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:05:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55154 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab1C2VFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:05:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qyoY3wejvPDQ6HVR2S8NgU8rVV0WH32kWQZ8lRDei2c5bEj/kJpHp3H+AqTzOggERq
         Jez/MV9duRunbpOEz1Sf2c4dUzbUYv88xtcXGJhTEJvX3AxeK0vuGx+I6T0rlVDNAri1
         EH9ORytX7nXQuBTp9oPV064+A+666B0C4mVQo=
MIME-Version: 1.0
In-Reply-To: <20110329202608.GA3454@viiv.ffwll.ch>
References: <1301310995.5615.92.camel@wangqingchuan>
	<1301336010.2217.20.camel@workstation>
	<AANLkTikMJszEyv8-SMMjD-MeykSwmsKf=gmezcMgySoP@mail.gmail.com>
	<1301409864.5615.98.camel@wangqingchuan>
	<AANLkTi=fcWBpmQ66a3+vQwgFOXn=0rJAviNzR4a0mfcJ@mail.gmail.com>
	<1301421664.2151.12.camel@Portable-Work>
	<AANLkTin_v5h==E0i5mQgK2AEdaZhwViykr3acbz4CW0k@mail.gmail.com>
	<20110329202608.GA3454@viiv.ffwll.ch>
Date: Tue, 29 Mar 2011 17:04:59 -0400
Message-ID: <AANLkTim2AyGPrun8MNq0=TyXpJ+b8i=eyHhLz01F+f2P@mail.gmail.com>
Subject: Re: GEM-related desktop sluggishness due to linear-time arch_get_unmapped_area_topdown()
From: Jerome Glisse <j.glisse@gmail.com>
To: Jerome Glisse <j.glisse@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        r6144 <rainy6144@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 4:26 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, Mar 29, 2011 at 03:45:34PM -0400, Jerome Glisse wrote:
>> Short lived & small bo would definitly doesn't work well for this kind
>> of API, it would all be a function of the ioctl cost. But i am not
>> sure the drawback would be that big, intel tested with pread/pwrite
>> and gived up don't remember why. For the vbo case you describe the
>> scheme i was thinking would be : allocate bo and on buffer data call
>> upload to the allocated bo using the bind user page feature that would
>> mean zero extra copy operation. For the fire forget case of vbo,
>> likely somekind of transient buffer would be more appropriate.
>
> Just to clarify: Uploads to linear buffers are all done with pwrite (due
> to an api foobar, it's not so great for 2d/tiled stuff). It's amazing how
> much faster that is: Switching vbo's from mmpa to pwrite has given a few
> percent more fps in openarena in i915g! As long as the chunk you're gonna
> write fits into L1 cache, it's probably a net win.
> -Daniel

What i had in mind was something little bit more advance that pwrite,
somethings that would take width,height,pitch of userpage and would be
able to perform proper blit. But yes pwrite in intel is kind of
limited.

Cheers,
Jerome
