Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2JCBlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 21:41:17 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48191 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2JCBlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 21:41:15 -0400
Date: Wed, 3 Oct 2012 10:41:06 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@zabbo.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@google.com,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [RFC, PATCH] Extensible AIO interface
Message-ID: <20121003014106.GC15806@localhost>
References: <20121001222341.GF26488@google.com>
 <20121001231222.GB14533@lenny.home.zabbo.net>
 <20121001232235.GH26488@google.com>
 <20121001234439.GC14533@lenny.home.zabbo.net>
 <20121002002216.GI26488@google.com>
 <20121002174323.GE14533@lenny.home.zabbo.net>
 <20121002214113.GV26488@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002214113.GV26488@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Tue, Oct 02, 2012 at 02:41:13PM -0700, Kent Overstreet wrote:
> Seems to me it'd be no different from security considerations when
> introducing new ioctls. I.e., messy, ad hoc, easy to get wrong, but
> sometimes no way around it.
> 
> It really has to be ad hoc if it's extensible, unfortunately.
> 
> The only way of getting around _that_ would be with some kind of
> reflective type system, so that generic code could parse (in some
> fashion) the types of the various attributes, and for pointers copy the
> user data into the kernel and do whatever access controls in generic
> code.

I'm not userland API expert by any stretch of imagination but the
basic mechanism to pass data around seems sane to me and aio as stinky
as it is seems to be the only logical stuff for IOs w/ extra
attributes although alignment is always painful with any form of
concatenated opaque structures.

However, I don't think it's a good idea to try to implement something
which is a neutral transport of opaque data between userland and lower
layers.  Things like that sound attractive with unlimited
possibilities but reality seems to have the tendancy to make a big
mess out of setups like that.

So, if we're gonna do this, let's define what attributes we want to
have and let them be processed at the interface layer and fed to lower
layers afterwards - e.g. for cgroup context association, associate the
resulting bios with the target cgroup from the aio layer.

I'm quite skeptical of general usefulness of having opaque knobs to
lower IO stack which don't have proper generic abstraction.  Nobody
can make proper use of things like that.  Well, not nobody, maybe if
the lower stack, the interface and the application are implemented by
a single organization over relatively short span of time, maybe it
would be useful for them, but that isn't something which generic
interface design should focus on.

It's okay to allow some side channel thing for specific hacky uses but
I really hope the general design were focused around properly
abstracted attributes which can be understood and handled by the upper
layer.

Thanks.

-- 
tejun
