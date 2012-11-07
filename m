Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2KGG0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:26:49 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32915 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2KGG0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:26:47 -0500
Date: Tue, 6 Nov 2012 22:26:41 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Sasha Levin <sasha.levin@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, linux-fbdev@vger.kernel.org,
        florianSchandinat@gmx.de
Subject: Re: tty, vt: lockdep warnings
In-Reply-To: <alpine.LNX.2.00.1211061950020.1712@eggly.anvils>
Message-ID: <alpine.LNX.2.00.1211062219470.1077@eggly.anvils>
References: <50899507.1040900@oracle.com> <20121026143754.50277bd8@pyramind.ukuu.org.uk> <CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com> <20121105175937.26f31d2a@pyramind.ukuu.org.uk> <5097FEA9.2090603@oracle.com>
 <alpine.LNX.2.00.1211051106590.1709@eggly.anvils> <20121105201507.79fe47d7@pyramind.ukuu.org.uk> <alpine.LNX.2.00.1211051231070.21645@eggly.anvils> <20121106161100.216c6d79@pyramind.ukuu.org.uk> <alpine.LNX.2.00.1211061950020.1712@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012, Hugh Dickins wrote:
> 
> Ah, now I actually scan through it, I see references to blank screen:
> I'll try taking off your patch and seeing if it came up at screen
> blanking time, then put on your patch back on and try again.
> I'll report back in an hour or two.

Yes, that was it.  When the console screen blanked on 3.7.0-rc3-mm1,
it generated that lockdep splat, visible once I unblanked.  But once I
applied your patch to the kernel, lockdep kept quiet across blank/unblank.

Thanks!
Hugh
