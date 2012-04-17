Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2DQQ2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:28:39 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57459 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241Ab2DQQ2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:28:38 -0400
Date: Tue, 17 Apr 2012 20:28:32 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH c/r -mm] c/r: prctl: Simplify PR_SET_MM on mm::code/data
 assignment
Message-ID: <20120417162832.GM1906@moon>
References: <20120416225520.GD9756@moon>
 <CAGXu5jKHZSXXxWQdkQ2d0-soaUkQys85XjQ1M2Fx_hg5vTrs2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKHZSXXxWQdkQ2d0-soaUkQys85XjQ1M2Fx_hg5vTrs2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 09:26:07AM -0700, Kees Cook wrote:
> On Mon, Apr 16, 2012 at 3:55 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > The mm::start_code, end_code, start_data, end_data members
> > are set during startup of executable file and are not changed
> > after.
> >
> > But the program itself might map new executable or/and data areas in
> > time so the original values written into mm fields mentioned above
> > might not have correspond VMA area at all, thus if one try to
> > use this prctl codes without underlied VMA, the error will be
> > returned.
> 
> Hrm, what is the utility of these fields then? If they're not "real",
> should the kernel even bother tracking it at all? (Or, should it be
> fixed to actually do something useful?)

As far as I see they are used to print statistics on /proc. Maybe
here some hidden meaning in them I missed that's why I asked for
review ;)

	Cyrill
