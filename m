Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2LWLvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:51:40 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:59407 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2LWLvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:51:36 -0500
Date: Sun, 23 Dec 2012 12:51:33 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@alien8.de>, Andy Furniss <andyqos@ukfsn.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20121223115133.GA229@x4>
References: <20121222203547.GA5319@liondog.tnic>
 <CADnq5_MJzNdWVCauZj5Z7Monmsy4gWeYP3gJaPUPwHEgqhqOYw@mail.gmail.com>
 <20121223002507.GA12121@liondog.tnic>
 <CADnq5_Oe=_nOrsgUZvPc82F5CFAWecx=Uiqn0CAeK+YG3ns3AA@mail.gmail.com>
 <20121223105527.GA6230@liondog.tnic>
 <50D6E491.3030801@ukfsn.org>
 <20121223110730.GC6230@liondog.tnic>
 <50D6E8A4.1030204@ukfsn.org>
 <20121223113153.GA8918@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121223113153.GA8918@liondog.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.12.23 at 12:31 +0100, Borislav Petkov wrote:
> On Sun, Dec 23, 2012 at 11:19:00AM +0000, Andy Furniss wrote:
> > modinfo radeon
> > 
> > will give a list assuming you use modules, I think all of them need =<num>.
> 
> Yep, that is one way of getting that info, thanks. I always go and look
> at Documentation/kernel-parameters.txt and forget about modinfo.
> 
> As you say 'radeon' needs to be module but since this is the case with
> the distros, the majority of Linux installations out there have it this
> way so we're fine.

(If you don't use modules:
 git grep MODULE_PARM_DESC -- drivers/gpu/drm/radeon/
)

You may have hit the same issue as I, see:
http://thread.gmane.org/gmane.comp.video.dri.devel/78328

Reverting commit 2d6cc729 fixes the problem for me, setting
radeon.no_wb=1 doesn't help.

-- 
Markus
