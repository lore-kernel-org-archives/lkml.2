Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab1K2GT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:19:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34281 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1K2GTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:19:54 -0500
Date: Tue, 29 Nov 2011 10:19:49 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] prctl: Add PR_ codes to restore vDSO and tune up mm_struct
 entires
Message-ID: <20111129061949.GQ1775@moon>
References: <20111124120051.GV1820@moon>
 <20111128225606.GD3858@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128225606.GD3858@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 02:56:06PM -0800, Tejun Heo wrote:
> On Thu, Nov 24, 2011 at 04:00:51PM +0400, Cyrill Gorcunov wrote:
> > +		case PR_SETUP_VDSO_AT:
> > +			if (arg3 | arg4 | arg5)
> > +				return -EINVAL;
> > +
> > +			if (!capable(CAP_SYS_ADMIN))
> > +				return -EPERM;
> > +
> > +#ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
> > +			error = arch_setup_additional_pages_at((void *)arg2);
> > +#else
> > +			error = -ENOSYS;
> > +#endif
> > +			break;
> 
> Hmmm... I'm not sure this is the best approach.  vdso is supposed to
> be able to be dependent on binprm too, so the proposed solution could
> work but I'm not sure whether it's a good one.  For now, can't we just
> copy the vdso and unmap it at the orignal address?
> 

Hi Tejun,

yeah, it might be not that good solution (RFC it was(c) ;) but I actually
failed to find some more elegant way of handling it. So you propose to handle
all the things directly in userspatce, ie unmap current, map previous vdso)?
(I fear mapping vsyscall is not allowed from userspace but I'll check)
