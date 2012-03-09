Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031526Ab2CIUIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:08:15 -0500
Received: from home.keithp.com ([63.227.221.253]:60186 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031009Ab2CIUIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:08:12 -0500
From: Keith Packard <keithp@keithp.com>
To: Dave Jones <davej@redhat.com>, Yang Bai <hamo.by@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>, kernel@tesarici.cz
Subject: Re: inode->i_wb_list corruption.
In-Reply-To: <20120309180015.GA3862@redhat.com>
References: <20120306185137.GA15881@redhat.com> <20120306210307.GC8781@quack.suse.cz> <20120307072608.GA24087@localhost> <20120307104240.GB18658@quack.suse.cz> <CAO_0yfNt2jgiTPZn5NkwBAjQZtk+377gG71d6QOuXQrDHjdkEg@mail.gmail.com> <20120309145713.GA21543@redhat.com> <20120309151951.GA30160@redhat.com> <CAO_0yfMYOOTvRg9=8_eYP09o0BpzSEk=8vqgNk_vV_u3-biAYA@mail.gmail.com> <20120309180015.GA3862@redhat.com>
User-Agent: Notmuch/0.11.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 09 Mar 2012 12:08:07 -0800
Message-ID: <868vj97d20.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<#part sign=pgpmime>
On Fri, 9 Mar 2012 13:00:15 -0500, Dave Jones <davej@redhat.com> wrote:

> i915_drm_thaw is a deep nest of functions though, so this is going to be
> hard to track down where that write is coming from. Because the corruption
> seems to happen to pages that are already allocated, we probably can't
> even rely on DEBUG_PAGEALLOC, though it might be worth trying.

I'm worried that the write is coming through the GTT, which would make
sense as these look like pixel values. If this is on Ironlake (core
I3-I7 first gen), we know there are issues when VT-d is enabled, and
the work-around for that doesn't appear to be in place for the hibernate
resume case.

-- 
keith.packard@intel.com
