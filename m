Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab2CISA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:00:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab2CISAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:00:24 -0500
Date: Fri, 9 Mar 2012 13:00:15 -0500
From: Dave Jones <davej@redhat.com>
To: Yang Bai <hamo.by@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>, kernel@tesarici.cz
Subject: Re: inode->i_wb_list corruption.
Message-ID: <20120309180015.GA3862@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Yang Bai <hamo.by@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>,
	kernel@tesarici.cz
References: <20120306185137.GA15881@redhat.com>
 <20120306210307.GC8781@quack.suse.cz>
 <20120307072608.GA24087@localhost>
 <20120307104240.GB18658@quack.suse.cz>
 <CAO_0yfNt2jgiTPZn5NkwBAjQZtk+377gG71d6QOuXQrDHjdkEg@mail.gmail.com>
 <20120309145713.GA21543@redhat.com>
 <20120309151951.GA30160@redhat.com>
 <CAO_0yfMYOOTvRg9=8_eYP09o0BpzSEk=8vqgNk_vV_u3-biAYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_0yfMYOOTvRg9=8_eYP09o0BpzSEk=8vqgNk_vV_u3-biAYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(trimmed cc)

On Sat, Mar 10, 2012 at 12:14:37AM +0800, Yang Bai wrote:
 > On Fri, Mar 9, 2012 at 11:19 PM, Dave Jones <davej@redhat.com> wrote:
 > > And with that, this arrived..
 > > https://bugzilla.redhat.com/show_bug.cgi?id=788433#c3
 > >
 > > I'm leaning strongly towards believing this is yet another case of i915
 > > corrupting memory on resume.
 > 
 > Nice catch. I am wondering
 > 1) why all lists being affected and
 > 2) why all list_head's prev being set to NULL.
 > 
 > Any ideas?

This is probably the same bug: https://bugzilla.kernel.org/show_bug.cgi?id=37142
Petr noticed that the corruption is 32 bytes getting zeroed at the beginning
of a page.

I think this may be responsible for a lot of different bugs that we've
had reported.

i915_drm_thaw is a deep nest of functions though, so this is going to be
hard to track down where that write is coming from. Because the corruption
seems to happen to pages that are already allocated, we probably can't
even rely on DEBUG_PAGEALLOC, though it might be worth trying.

	Dave

