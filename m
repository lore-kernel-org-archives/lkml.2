Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab2BIWJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:09:21 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34437 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753588Ab2BIWJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:09:20 -0500
Message-ID: <1328825357.29329.16.camel@joe2Laptop>
Subject: Re: [PATCH] SubmittingPatches: Increase the line length limit from
 80 to 100 colums
From: Joe Perches <joe@perches.com>
To: Jan Engelhardt <jengelh@medozas.de>, Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 09 Feb 2012 14:09:17 -0800
In-Reply-To: <alpine.LNX.2.01.1202092206040.11004@frira.zrqbmnf.qr>
References: <20120130140905.441199885@openvz.org>
	 <20120130141852.309402052@openvz.org> <20120203074656.GC30543@elte.hu>
	 <20120203083530.GD1968@moon> <20120203090929.GA23996@elte.hu>
	 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
	 <20120203095227.GA13162@elte.hu <20120203100743.GA3334@elte.hu>
	 <alpine.LNX.2.01.1202092206040.11004@frira.zrqbmnf.qr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 22:55 +0100, Jan Engelhardt wrote:
> I am throwing in the suggestion to augment checkpatch 
> such that it does not look at whether single lines are over $limit, but 
> whether a certain percentage of lines of a file is over $limit. That, 
> together with a badness value that is e.g. following some power law to 
> the amount of chars too much, but not when the line cannot be broken
> in the first place. Maybe along the lines of
> 
>  #perlish#
>  foreach (<>) {
>      /^\s+\S+/;
>      if (length($_) > length($&)) {
>          push @candidate, $_;
>          $badness += (length($_) - length($&)) ** 1.5;
>      }
>  }
>  if ($badness > $threshold) {
>      warn about @candidate_lines;
>  }

I'd be OK with something like this while making the
current line length check a --strict only option.


