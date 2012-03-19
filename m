Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965027Ab2CSXRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:17:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44998 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758841Ab2CSXRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:17:13 -0400
Date: Tue, 20 Mar 2012 03:17:09 +0400
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
Message-ID: <20120319231709.GM19594@moon>
References: <20120316205556.595309230@openvz.org>
 <20120316210343.925446961@openvz.org>
 <20120319151507.93bab32a.akpm@linux-foundation.org>
 <20120319223941.GJ19594@moon>
 <CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
 <20120319154649.0687f545.akpm@linux-foundation.org>
 <CAFLxGvyCRAq6t8_ni+VFUVpOGJ4-iz0i=PRFEFpVJ+ZaPEb3-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFLxGvyCRAq6t8_ni+VFUVpOGJ4-iz0i=PRFEFpVJ+ZaPEb3-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 12:02:44AM +0100, richard -rw- weinberger wrote:
> On Mon, Mar 19, 2012 at 11:46 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > Well, let's discuss this more completely.  In what ways could an
> > attacker use this?  How serious is the problem?  What actions can be
> > taken to lessen it?  etcetera.
> 
> After considering the problem a bit more I think it's not a big problem.
> We must not trust /proc/pid/exe in anyway.

Well, Richard, we probably do not trust it anyway but sysadmins might do
(and this was another reason for one-shot behaviour -- to not bring
 heart attacks to sysadmins, and everyone would know this link might
 be changed only one time ;)

> An attacker can always execute another binary without calling execve().

That's what c/r basically does :)

> 
> So, why makes that one-short fashion the feature more secure?
> Let the user change the exe symlink as often as he wants.
> From a security point of view the exe symlink is anyway useless.

Maybe better to call it 'predictable' then rather than 'secure'?

	Cyrill
