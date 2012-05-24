Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933Ab2EXSVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:21:44 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36152 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab2EXSVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:21:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120524180154.GA15036@core.coreip.homeip.net>
References: <20120524083216.GD10562@core.coreip.homeip.net>
 <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com> <20120524180154.GA15036@core.coreip.homeip.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 May 2012 11:21:20 -0700
X-Google-Sender-Auth: jusR0oFDArm-V5EiRm0bmyQ3vPM
Message-ID: <CA+55aFx0ww=BtYAj9WEbqMT2R30ZZpjd014cYCpC=b+HRtUf_A@mail.gmail.com>
Subject: Re: [git pull] Input updates for 3.5-rc0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:01 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> A couple of points:

*NEITHER* of your points actually address my issue.

If the "inputX" name is useless (and dammit, I agree), then why do you
continue to use it then?

IOW, why the hell do you set a name that is so useful that no sane
person would ever want to use it?

Basically, my complaint is that the input layer drivers end up doing
stupid things ("dev_dbg(input->dev.parent..") because the input layer
has done stupid things (dev_set_name(&dev->dev, "input%ld").

So let me be more blunt and direct: which part of "that's f*cking
stupid" do you disagree with?

So instead of making drivers do stupid things because you've made the
input layer names so damn useless, why don't you make the input layer
use better naming? Doesn't that seem to be the *smart* thing to do?

Wouldn't everybody be much happier if they saw useful names in the
device tree? And then the drivers could actually *use* those useful
names, instead of clearly saying "our names are so shitty that we have
to look up the parent name just to get a useful printout"?

Do people really *want* to see names like "input2" when working with a
keyboard? Do we have some stupid userlevel interface that requires
these useless and nondescriptive names that are so useless that even
the input layer itself doesn't want to use them?

Wouldn't it be *much* nicer if the input layer would, for example, do
something like

   dev_set_name(&dev->dev, "input-%s", dev_name(dev->dev.parent));

or whatever? Better yet, make it easy for the driver to say what it
is, so that it really can just say "wacom %s" or whatever.

Because the basic reason you seem to want to use "dev.parent" instead
of just "dev" *all* seem to boil down to a very simple reason:

 - other subsystems name their devices better, so you want to use
those better names

Fix the underlying *reason*, instead of the symptoms. That's what I'm saying.

              Linus
