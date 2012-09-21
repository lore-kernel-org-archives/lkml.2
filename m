Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2IUPam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:30:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54139 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2IUPal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:30:41 -0400
Date: Fri, 21 Sep 2012 10:30:33 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Feng Hong <hongfeng@marvell.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] poweroff: fix bug in orderly_poweroff
Message-ID: <20120921153033.GB13764@sergelap>
References: <1348036677-28626-1-git-send-email-hongfeng@marvell.com>
 <20120920170647.GA26278@mail.hallyn.com>
 <E62404B31D39064FBDD0B843ADF05A7D2D395FCD2F@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E62404B31D39064FBDD0B843ADF05A7D2D395FCD2F@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Feng Hong (hongfeng@marvell.com):
> Hi, Serge,
> 
> I am just a graduate and it's my first time to send a patch to opensource, so thank you very much for reminding me the "changelog affairs", it seems this patch has been added to -mm tree as attached mail, and I have no chance to change the comments, right ? Then I must remember this and be careful next time. Thanks again for reminding me !

Sorry, your description was fine, what i meant was something below your
patch description that looks like

Change since v1:
	[date] Per Eric's sugestion, switch from UMH_WAIT_PROC to UMH_WAIT_EXEC.

> >Is this actually sufficient for you?  The exec will have started, but may for whatever (very unlikely) reason fail.  If you're happy with it,
> I think UMH_WAIT_EXEC is sufficient for me, as in our system there is no "/sbin/poweroff" existed. On the other hand, UMH_WAIT_PROC is not suitable here as Eric analysis; if using UMH_WAIT_EXEC, and the user application fail, I'd prefer to complain bad application. So using UMH_WAIT_EXEC and UMH_WAIT_PROC has a tradeoff here, what do you think so ?

Yup, that sounds fine to me, I just wanted to make sure you were ok with the
fact that application failure (after successful exec) will be ignored.

thanks,
-serge
