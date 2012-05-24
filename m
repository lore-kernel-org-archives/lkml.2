Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab2EXUgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:36:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57368 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2EXUgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:36:53 -0400
Date: Thu, 24 May 2012 13:36:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 3.5-rc0
Message-ID: <20120524203647.GA16024@core.coreip.homeip.net>
References: <20120524083216.GD10562@core.coreip.homeip.net>
 <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
 <20120524180154.GA15036@core.coreip.homeip.net>
 <CA+55aFx0ww=BtYAj9WEbqMT2R30ZZpjd014cYCpC=b+HRtUf_A@mail.gmail.com>
 <20120524195851.GA15306@core.coreip.homeip.net>
 <CA+55aFxX+xidcuVXb1h4oFTemtHo+ANECaoOw=vxtKN231N+cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxX+xidcuVXb1h4oFTemtHo+ANECaoOw=vxtKN231N+cA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 01:11:14PM -0700, Linus Torvalds wrote:
> On Thu, May 24, 2012 at 12:58 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> >  Considering your
> >
> >        dev_set_name(&dev->dev, "input-%s", dev_name(dev->dev.parent));
> >
> > what happens if I unplug and replug my wacom tablet while event node is
> > still opened and therefore all kobjects are still pinned into memory?
> 
> I'll let you think about just how stupid that comment was for a moment.

Hmm, I guess we are better now with cleaning and turning devices into
zombies waiting to be reaped. Still have to handle parent have several
input devices (HID devices quite often do it). And I still do not see
the point why we want to bother, the proper layer to report driver
errors is driver and object it is bound to.

-- 
Dmitry
