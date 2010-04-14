Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab0DNVHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:07:00 -0400
Received: from pegasus.tknet.eu ([83.169.4.101]:32896 "EHLO pegaus.tknet.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755749Ab0DNVG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:06:59 -0400
Message-ID: <4BC62E0B.3090006@plzk.org>
Date: Wed, 14 Apr 2010 23:05:15 +0200
From: Tobias <mailing54@plzk.org>
Reply-To: mailing54@plzk.org
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34-rc4
References: <alpine.LFD.2.00.1004121859480.3647@i5.linux-foundation.org> <4BC57F10.8080002@plzk.org> <alpine.LFD.2.00.1004140733310.15116@i5.linux-foundation.org> <alpine.LFD.2.00.1004141645440.3932@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004141645440.3932@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:

> 
> It is likely that this is already bisected
> and fixed by the patch here:
> https://bugzilla.kernel.org/show_bug.cgi?id=15749
> 

Doh, indeed it looks like it. So far I have

git bisect start
# good: [2eaa9cfdf33b8d7fb7aff27792192e0019ae8fc6] Linux 2.6.34-rc3
git bisect good 2eaa9cfdf33b8d7fb7aff27792192e0019ae8fc6
# bad: [0d0fb0f9c5fddef4a10242fe3337f00f528a3099] Linux 2.6.34-rc4
git bisect bad 0d0fb0f9c5fddef4a10242fe3337f00f528a3099
# good: [14e71e4fb94c340273534a6d7f210aa82a3ca717] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog
git bisect good 14e71e4fb94c340273534a6d7f210aa82a3ca717
# bad: [2f10ffcfb28beb35137d9e86992c771b4a6c5f2a] Merge branch 
'drm-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
git bisect bad 2f10ffcfb28beb35137d9e86992c771b4a6c5f2a
# good: [fb1ae635772d679eb312fa447290fc02cd0e4cf1] Merge branch 
'x86-fixes-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip
git bisect good fb1ae635772d679eb312fa447290fc02cd0e4cf1
# bad: [d620a7cf05d4f12f5bbb1060d766e8139ab31458] Merge branch 
'upstream-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev
git bisect bad d620a7cf05d4f12f5bbb1060d766e8139ab31458
# good: [f5284e7635787224dda1a2bf82a4c56b1c75671f] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus
git bisect good f5284e7635787224dda1a2bf82a4c56b1c75671f
# bad: [c25f7cf2032aaac9bd50d6eee982719878538082] Merge branches 
'battery', 'bugzilla-14667', 'bugzilla-15096', 'bugzilla-15480', 
'bugzilla-15521', 'bugzilla-15605', 'gpe-reference-counters', 'misc', 
'pxm-fix' and 'video-random-key' into release
git bisect bad c25f7cf2032aaac9bd50d6eee982719878538082

At least I got a free bisect turorial and will know my way next time.

Thanks and sorry for the noice.

Tobias

