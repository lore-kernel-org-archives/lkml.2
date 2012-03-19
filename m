Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030311Ab2CSWuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:50:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60953 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874Ab2CSWuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:50:50 -0400
Date: Tue, 20 Mar 2012 02:50:20 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new
 mm_struct::exe_file
Message-ID: <20120319225020.GL19594@moon>
References: <20120316205556.595309230@openvz.org>
 <20120316210343.925446961@openvz.org>
 <20120319151507.93bab32a.akpm@linux-foundation.org>
 <20120319223941.GJ19594@moon>
 <CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
 <20120319154649.0687f545.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319154649.0687f545.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 03:46:49PM -0700, Andrew Morton wrote:
> 
> Please send a patch with the updated changelog and improved comment?

Sure I'll resend.

> 
> > >
> > > Actually I liked multi-shot version more but Matt arguments convinced
> > > me that one-short fashion is more "secure" in terms of overall kernel
> > > state and potential transitions/changes of this /proc/pid/exe symlink.
> > >
> > > At least with one-shot version the admin may be sure that the symlink
> > > is never changed more than once, ever.
> > >
> > 
> > And changing it once does not harm security?
> > I'm sure that rootkit writers will like this feature...
> 
> Well, let's discuss this more completely.  In what ways could an
> attacker use this?  How serious is the problem?  What actions can be
> taken to lessen it?  etcetera.

It can use it iif CAP_SYS_RESOURCE is granted.
Otherwise you'll get -eaccess.

	Cyrill
