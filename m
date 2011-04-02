Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1DBJpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 05:45:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56504 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab1DBJo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 05:44:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qYqUD2ESivfU2v7TwEa8Hix0MnbAIHocn/7avRfCmSOol1GccoJauiIs+TK85ay0Io
         TwGvg3TwxFlZnPZxR6dYMOJEc14z7brzsP6q+6376lOEr666NeS7NBiEynlLcLKZYD7R
         vraam0fBw60lx/dtGlrSbwcL7UoB5knSlCeKs=
MIME-Version: 1.0
In-Reply-To: <20110401172241.GA26851@srcf.ucam.org>
References: <AANLkTi=1xtjEZc2C1=W-v2oYbvvcGH9k_DGGXvJ8=swq@mail.gmail.com>
	<20110401172241.GA26851@srcf.ucam.org>
Date: Sat, 2 Apr 2011 11:44:57 +0200
Message-ID: <BANLkTikPjwowBge82viT+Ma5UnP0fA-pew@mail.gmail.com>
Subject: Re: Regression 2.6.39-rc1 for sony-laptop
From: Andrea Gelmini <andrea.gelmini@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: anssi.hannula@iki.fi, linux-acpi@vger.kernel.org, axel.lin@gmail.com,
        trenn@suse.de, len.brown@intel.com, error27@gmail.com,
        malattia@linux.it, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/1 Matthew Garrett <mjg59@srcf.ucam.org>:
> touch any Sony code. I'll take a look at the Sony patches, thanks for
> the report!

Hi Matthew,
   and thanks a lot for your quick answer.
   Maybe I messed up with bisect trying to find the origin of two regression.
   One was this. The other one is this one.

   Hibernation (to disk, of course) doesn't work no more.
   Screen blanks and nothing happens. No HD activity, and so on. I also
   waited some minutes.

   Well, bisect blame this commit:

commit 2a4f0c81adcd1f812a63bc9106be2fd26f437730
Author: Mattia Dongili <malattia@linux.it>
Date:   Sat Feb 19 11:52:30 2011 +0900

    sony-laptop: cache handles and report them via sysfs

    Avoid calling into acpi each time we need to lookup a method handle
    and report the available handles to ease collection of information when
    debugging issues. Also move initialization of the platform driver
    earlier to allow adding files from other setup functions.

    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Matthew Garrett <mjg@redhat.com>

 drivers/platform/x86/sony-laptop.c |   97 ++++++++++++++++++++++++++++++------
 1 files changed, 81 insertions(+), 16 deletions(-)

   Do you have any suggestion to better track down this issue?
   It's not possibile to simply revert it.

Thanks a lot for your time,
Andrea
