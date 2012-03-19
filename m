Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab2CSW7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:59:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab2CSW7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:59:31 -0400
Date: Mon, 19 Mar 2012 15:59:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new
 mm_struct::exe_file
Message-Id: <20120319155926.8d1d8f0e.akpm@linux-foundation.org>
In-Reply-To: <20120319225020.GL19594@moon>
References: <20120316205556.595309230@openvz.org>
	<20120316210343.925446961@openvz.org>
	<20120319151507.93bab32a.akpm@linux-foundation.org>
	<20120319223941.GJ19594@moon>
	<CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
	<20120319154649.0687f545.akpm@linux-foundation.org>
	<20120319225020.GL19594@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2012 02:50:20 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On Mon, Mar 19, 2012 at 03:46:49PM -0700, Andrew Morton wrote:
> > 
> > Please send a patch with the updated changelog and improved comment?
> 
> Sure I'll resend.
> 
> > 
> > > >
> > > > Actually I liked multi-shot version more but Matt arguments convinced
> > > > me that one-short fashion is more "secure" in terms of overall kernel
> > > > state and potential transitions/changes of this /proc/pid/exe symlink.
> > > >
> > > > At least with one-shot version the admin may be sure that the symlink
> > > > is never changed more than once, ever.
> > > >
> > > 
> > > And changing it once does not harm security?
> > > I'm sure that rootkit writers will like this feature...
> > 
> > Well, let's discuss this more completely.  In what ways could an
> > attacker use this?  How serious is the problem?  What actions can be
> > taken to lessen it?  etcetera.
> 
> It can use it iif CAP_SYS_RESOURCE is granted.
> Otherwise you'll get -eaccess.

A rootkit already obtained CAP_SYS_RESOURCE.  What we're concerned
about here is its ability to hide itself from view and its ability to
obscure the way in which it obtained elevated privs.

How much this patch worsens the situation is unclear to me, so let's
think it through.
