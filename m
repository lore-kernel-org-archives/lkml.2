Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965226Ab2CGUDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:03:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759790Ab2CGUDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:03:23 -0500
Date: Wed, 7 Mar 2012 20:51:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        adobriyan@gmail.com, ebiederm@xmission.com, keescook@chromium.org,
        kosaki.motohiro@jp.fujitsu.com, matthltc@us.ibm.com, tj@kernel.org,
        xemul@parallels.com
Subject: Re: + mm-exec-rename-mm-exe_file-to-mm-exe_path.patch added to -mm
	tree
Message-ID: <20120307195104.GA5071@redhat.com>
References: <20120306231325.D4B26A0395@akpm.mtv.corp.google.com> <20120307162630.GG20558@moon> <20120307174113.GA25366@redhat.com> <20120307193433.GP20619@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307193433.GP20619@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please drop this (trivial as I thought) patch :/

On 03/07, Cyrill Gorcunov wrote:
>
> On Wed, Mar 07, 2012 at 06:41:13PM +0100, Oleg Nesterov wrote:
> ...
> > I do not think I really need it, but just in case... could you send me
> > (privately) the result of "make fs/dcache.s" ?
> >
>
> yes, just sent.
>
> > I'll try to recheck the patch and think.
> >
> > But if you can _explain_ why do you think that "struct path" can't work,
> > please explain ;)
>
> OK, the best way to prove myself that I was wrong is to try to
> explain why it can't work. So I prepared a call trace to point
> where we can get a reference to non-existing path and... found
> that it's simply impossible.

It is possible, and you even explained this in the private email
with asm you sent me.

> OOPs. Sorry for false alarm, Oleg!

No, thanks for the report and analysis.

Indeed, the patch is deadly wrong. Somehow I missed that ->f_path
is not the pointer! So set_mm_exe_path(&bprm->file->f_path) is
is obvioulsy wrong. I didn't bother to think about "&" think call
needs.

Thanks!

Oleg.

