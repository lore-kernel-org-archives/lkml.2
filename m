Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab2CWGlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 02:41:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58609 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2CWGlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 02:41:42 -0400
Date: Fri, 23 Mar 2012 10:41:36 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new
 mm_struct::exe_file
Message-ID: <20120323064136.GA6766@moon>
References: <20120316205556.595309230@openvz.org>
 <20120316210343.925446961@openvz.org>
 <20120319151507.93bab32a.akpm@linux-foundation.org>
 <20120319223941.GJ19594@moon>
 <CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
 <20120319154649.0687f545.akpm@linux-foundation.org>
 <20120320065543.GB14269@moon>
 <m14ntgxl30.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14ntgxl30.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 04:38:43PM -0700, Eric W. Biederman wrote:
> >
> > Andrew, take a look please, will the changelog and comments look
> > better?
> 
> Can you change this to take an actual address and get the exe_file
> from an mmapped area and make certain that the mmaped_area is already
> mapped MAP_EXEC.
> 
> That will prevent out-right lies.
> 
> At least then we will know that exe_file will at least be a file that is
> mapped executable in the process's address space.  It's not a lot better
> but it makes /proc/<pid>/exe at almost as trustable as it is now.

This won't work for all cases. When we restore a program we map new
VM_EXEC areas _without_ vma::vm_file field.

	Cyrill
