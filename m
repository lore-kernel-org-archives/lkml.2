Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2GaKQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:16:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60505 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab2GaKQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:16:09 -0400
Date: Tue, 31 Jul 2012 14:16:03 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "lwn@lwn.net" <lwn@lwn.net>, "criu@openvz.org" <criu@openvz.org>,
        "users@openvz.org" <users@openvz.org>,
        Containers <containers@lists.linux-foundation.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: [Announce] Checkpoint-restore tool v0.1
Message-ID: <20120731101603.GD2007@moon>
References: <500D09C9.7060903@parallels.com>
 <500D1116.7070301@parallels.com>
 <CAFLxGvwUhEPNdQvUnue2QFu_EipmBKD3nf0MfMWkqwLTf7jd5Q@mail.gmail.com>
 <50179CF0.7050200@parallels.com>
 <CAFLxGvygCxER3gHfj-onwnm_m6xugOVkynGyJU2CDheD3A2HOQ@mail.gmail.com>
 <5017A053.9000206@parallels.com>
 <CAFLxGvy396+BfYSaSnvAwJb0GO4WZCKbPXSbU7YfrOJTo6zk6A@mail.gmail.com>
 <5017AB41.60700@parallels.com>
 <CAFLxGvwu8-ii7hDbDfco3JrgKgOK+hsdTN_Q--AHbom0Ni8WYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvwu8-ii7hDbDfco3JrgKgOK+hsdTN_Q--AHbom0Ni8WYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 12:08:22PM +0200, richard -rw- weinberger wrote:
> On Tue, Jul 31, 2012 at 11:54 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
> >> Yeah, but I fear it's not that easy.
> >> We'd have to change crtools to work without ptrace().
> >
> > Well, this is hard. Using ptrace saved us from having many special-purpose
> > APIs for dumping various stuff (there will be an article about it). Thus I
> > don't know which way is simpler -- stop using ptrace or teach ptrece to allow
> > several tracers to attach to one task %)
> 
> Allowing multiple tracers in a safe way is IMHO even more harder.
> 
> BTW:  While reading prctl_set_mm() I noticed two things.
> 1.  Why isn't the return value of find_vma() verified?

prctl_set_mm
	vma = find_vma(mm, addr);
	...
	if (!vma) {
		error = -EFAULT;
		goto out;
	}

these values are used in procfs statistics only. So I don't get
which verify you mean here.

> It looks like one can set an addr which does not belong to any vma.
> 2. What will happen if addr is not page aligned?

you'll have a bit weird output in procfs stat (probably I should add
page alignment check here).

	Cyrill
