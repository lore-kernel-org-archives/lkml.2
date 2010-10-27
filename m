Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0J0Bfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 21:35:48 -0400
Received: from mail.perches.com ([173.55.12.10]:3625 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab0J0Bfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 21:35:47 -0400
Subject: Re: [PATCH 06/10] drivers/input/serio/i8042: Use pr_<level>,
 pr_fmt. Fix dbg and __FILE__ use
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4E27039C-DE6B-4C90-ADC5-68D3B30F75E6@gmail.com>
References: <cover.1288059486.git.joe@perches.com>
	 <20101026155028.GA13097@core.coreip.homeip.net>
	 <1288135531.4145.59.camel@Joe-Laptop>
	 <201010261740.13566.dmitry.torokhov@gmail.com>
	 <1288140416.4145.76.camel@Joe-Laptop>
	 <BFA186FD-32F7-4E1A-9193-CA1575248B73@gmail.com>
	 <1288141825.4145.83.camel@Joe-Laptop>
	 <4E27039C-DE6B-4C90-ADC5-68D3B30F75E6@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 18:35:45 -0700
Message-ID: <1288143345.4145.90.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 18:28 -0700, Dmitry Torokhov wrote:
> On Oct 26, 2010, at 6:10 PM, Joe Perches <joe@perches.com> wrote:
> > I think 2 defects in 16 uses is a pretty high error rate.
> But how not adding /n is it much better than having it if
> some later change will forget to add it to the message?

Adding \n is the default kernel style.

USB uses a similar dbg macro with a relatively
high error rate.

I fixed some in this commit below awhile ago,
but these keep creeping back in, so they _are_
error prone in actual use.

commit 759f3634267a67ac90f3fa7fc06510dfd43b4e45
Author: Joe Perches <joe@perches.com>
Date:   Fri Feb 5 16:50:08 2010 -0800

    USB: serial: Remove unnecessary \n's from dbg uses
    
    #define dbg adds the newline, messages shouldn't.
    Converted dbg("%s", "some string") to dbg("some string")
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


