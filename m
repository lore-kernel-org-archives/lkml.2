Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab1LFJy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:54:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932955Ab1LFJy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:54:58 -0500
Date: Tue, 6 Dec 2011 10:54:56 +0100
From: Michal Hocko <mhocko@suse.cz>
To: zhihua che <zhihua.che@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Page Allocator] when is init_per_zone_wmark_min called to first
 initialize the watermarks, reserved memory etc?
Message-ID: <20111206095456.GB1342@tiehlicka.suse.cz>
References: <CABexPfE84OgdGQtKUm2JQ9_5ZBFs_pr3gdxMLYmxd=wVyBZhpQ@mail.gmail.com>
 <CABexPfFZ8LJxmsuiSOtejfVebrTRM3=ppW5hxbQgmgX04VdAOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABexPfFZ8LJxmsuiSOtejfVebrTRM3=ppW5hxbQgmgX04VdAOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-12-11 03:25:29, zhihua che wrote:
> 2011/12/6 zhihua che <zhihua.che@gmail.com>:
> > Hi, everyone
> >
> >        I'm reading the linux kernel codes, and now focusing on memory
> > management. I came across a simple problem:).
> >        I know the every zone keeps three water marks to control the
> > allocator's behavior and I find the three watermarks is initialized in
> > init_per_zone_wmark_min.
> > Unfortunately, I can't find when this function is called FIRSTduring
> > the kernel booting process. I searched the source codes using LXR and
> > cscope and got nothing.
> > I guess I missed something but I have no any idea.
> >
> > harvey.
> 
> 
> Maybe I'm closer the truth:-)
> I find this function is defined as a module entry function (I should'v
> found this earlier). As far as I know module entry functions are
> called at the end of start_kernel() by rest_init(), whereas page
> allocator / buddy system is used before they are called. For example,
> __get_free_pages() is called in kmem_cache_init() which in turn is
> called in start_kernel() earlier than rest_init().

Yes, this is correct. We do live without watermarks (resp. with 0) for
some time and we rely that we have sufficient memory for that time (who
we would reclaim from when no processes exist - apart from init and few
kernel threads).
kswapd is started around the same time.

HTH
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
