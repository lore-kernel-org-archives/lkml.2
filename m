Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965138Ab2CSWrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:47:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45300 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799Ab2CSWrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:47:51 -0400
Date: Tue, 20 Mar 2012 02:47:46 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new
 mm_struct::exe_file
Message-ID: <20120319224746.GK19594@moon>
References: <20120316205556.595309230@openvz.org>
 <20120316210343.925446961@openvz.org>
 <20120319151507.93bab32a.akpm@linux-foundation.org>
 <20120319223941.GJ19594@moon>
 <CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 11:41:36PM +0100, richard -rw- weinberger wrote:
> >
> > Actually I liked multi-shot version more but Matt arguments convinced
> > me that one-short fashion is more "secure" in terms of overall kernel
> > state and potential transitions/changes of this /proc/pid/exe symlink.
> >
> > At least with one-shot version the admin may be sure that the symlink
> > is never changed more than once, ever.
> >
> 
> And changing it once does not harm security?
> I'm sure that rootkit writers will like this feature...

The one-shot limits the amount of transitions, but you still
have to obtain CAP_SYS_RESOURCE before you'll be able to change
this symlink (ie it's not 'anyone-can-change-it' feature).

	Cyrill
