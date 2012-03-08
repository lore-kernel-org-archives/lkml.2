Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab2CHTdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:33:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab2CHTdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:33:13 -0500
Date: Thu, 8 Mar 2012 20:25:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120308192559.GA20782@redhat.com>
References: <20120308165112.GF21812@moon> <20120308182623.GA17221@redhat.com> <20120308190303.GG21812@moon> <20120308190534.GA19827@redhat.com> <20120308192504.GH21812@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308192504.GH21812@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Cyrill Gorcunov wrote:
>
> On Thu, Mar 08, 2012 at 08:05:34PM +0100, Oleg Nesterov wrote:
> ...
> > >
> > > Yes, exactly, I need to remove old mappings first (because VMAs
> > > we're about to restore may intersect with current map the host
> > > program has). And yes, once they all are removed I don't have
> > > /proc/pid/exe anymore. That's why I need num_exe_file_vmas == 0
> > > case.
> >
> > OK, in this case PR_SET_MM_EXE_FILE should probably fail if
> > mm->num_exe_file_vmas != 0 ? This way it would be more or less
> > consistent or at least understandable. Just we add the new
> > special case: num_exe_file_vmas == 0 but exe_file != NULL
> > because c/r people are crazy.
> >
>
> Sure, I can drop num_exe_file_vmas != 0 case and refuse to
> setup new exe symlink if there some VM_EXECUTABLE remains
> unmapped. Sounds good?

Personally I like this. This is simple and _understable_, even
if ->num_exe_file_vmas has no meaning after PR_SET_MM_EXE.

But please-please document the new special case in the changelog.

Oleg.

