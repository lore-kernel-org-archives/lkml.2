Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab2KFQmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 11:42:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab2KFQmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 11:42:47 -0500
Date: Tue, 6 Nov 2012 11:42:15 -0500
From: Dave Jones <davej@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hugh Dickins <hughd@google.com>, Sasha Levin <sasha.levin@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, florianSchandinat@gmx.de
Subject: Re: tty, vt: lockdep warnings
Message-ID: <20121106164214.GA18246@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Hugh Dickins <hughd@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Sasha Levin <levinsasha928@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
	linux-fbdev@vger.kernel.org, florianSchandinat@gmx.de
References: <50899507.1040900@oracle.com>
 <20121026143754.50277bd8@pyramind.ukuu.org.uk>
 <CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com>
 <20121105175937.26f31d2a@pyramind.ukuu.org.uk>
 <5097FEA9.2090603@oracle.com>
 <alpine.LNX.2.00.1211051106590.1709@eggly.anvils>
 <20121105201507.79fe47d7@pyramind.ukuu.org.uk>
 <alpine.LNX.2.00.1211051231070.21645@eggly.anvils>
 <20121106161100.216c6d79@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106161100.216c6d79@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 04:11:00PM +0000, Alan Cox wrote:

 > > But a deadlock we have lived with for years.  Without reverting,
 > > we're prevented from discovering all the new deadlocks we're adding.
 > 
 > We lived with it locking boxes up on users but not knowing why.

Circa 3.5 we got a lot more reports of this happening too for some reason.
Turns out that races are awfully resistant to bisecting too.

 > The root
 > cause is loading two different framebuffers with one taking over from
 > another - that should be an obscure corner case and once the fuzz testing
 > can avoid.
 > 
 > I had a semi-informed poke at this and came up with a possible patch (not very tested)

If this fixes the real problems we've been seeing, I'll dance a jig.
 
	Dave

