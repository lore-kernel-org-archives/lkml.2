Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab1EJBHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 21:07:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37378 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1EJBHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 21:07:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dB6OMbpDwy1uDpKA9EA5nXaRw0REqUUksqrE7iedmGIiWDELOiP/6R7y2Msp1Jc8x6
         LlNlC3rlDyH1uQFKjlxH1v2WNpiUs+UHQ0eIqzF6Z0J+MWJMk+ohLCuv3nBS0GFsOthq
         HQam7bQDDvIcBwSX71DDGuzJoQhIct8cqIuzM=
MIME-Version: 1.0
In-Reply-To: <m1ei48zhyz.fsf@fess.ebiederm.org>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com> <m1ei48zhyz.fsf@fess.ebiederm.org>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Tue, 10 May 2011 03:06:15 +0200
Message-ID: <BANLkTik2Y+Yy4kaa2cNUEvTMygXH6btWUg@mail.gmail.com>
Subject: Re: [v2 000/115] faster tree-based sysctl implementation
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 5:11 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> With respect to review and merging.  The priorities should be:
> 1) Figure out what the users really need to do, before we change
>   everything so we only need one sweeping pass through the users
>   that hopefully simplifies them.


The users of the API should not rely on the .child field of 'struct
ctl_table' because we don't use that to encode the tree structure any
more.
That's absolutely the only thing that's changed in the API.

Most of the sysctl users in the tree don't need any change and will
work with the new sysctl just fine.

For the few that do, the first path of the series (the patches with
"no-child" in the name) get's rid of the .child field by:
a) replacing register_sysctl_table with register_sysctl_paths (very
straight forward change and the new code is cleaner)
b) registering files in multiple directories separately



That part of the patch series does not disturb the current
functionality and does not depend of the later patches; it uses the
current sysctl API to achieve the same goal.



> 2) Ensure you have a version of the new interfaces ready at the
>   start of the patchset, so the sweeping changes can be made
>   incrementally.
>
> 3) Clean up the users.
>
> 4) Make simplifications because you don't have any old users left.


Hmm. I'm not sure if I understand you correctly.

You want this so that the cleanup patches get in through the affected
subsystems, and not in a big series that would possibly create merge
problems with those trees?

This wouldn't be too hard to do and wouldn't uglify the new interface
too much, but I have limited time available to do this in the near
future (exams and school projects). I'll see how I can squeeze this
in.

-- 
 .
..: Lucian
