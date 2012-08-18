Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2HRQeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 12:34:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45503 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2HRQeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 12:34:06 -0400
Date: Sat, 18 Aug 2012 09:34:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jim Cromie <jim.cromie@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [bisected] Driver core fixes for 3.6-rc3 regression
Message-ID: <20120818163401.GA2013@kroah.com>
References: <20120817171354.GA14046@kroah.com>
 <20120818060934.GA255@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120818060934.GA255@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 08:09:34AM +0200, Markus Trippelsdorf wrote:
> On 2012.08.17 at 10:13 -0700, Greg KH wrote:
> > ----------------------------------------------------------------
> > Driver core fixes for 3.6-rc3
> > 
> > Here are two tiny patches, one fixing a dynamic debug problem that the printk
> > rework turned up, and the other one fixing an extcon problem that people
> > reported.
> > 
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ----------------------------------------------------------------
> > Axel Lin (1):
> >       extcon: extcon_gpio: Replace gpio_request_one by devm_gpio_request_one
> > 
> > Jim Cromie (1):
> >       drivers-core: make structured logging play nice with dynamic-debug
> 
> The commit af7f2158f above causes hundreds of "Failed to force enable
> HPET" messages to appear during boot on my system.
> Please also note the strange "^A0" character sequence that is also
> introduced by the same commit.

Ugh, I see the same thing here, debugging must be accidentally enabled
with this patch, and the ^A0 stuff is just a mess.  Sorry, I didn't
notice this in my testing, my fault.

Reverting this resolves the issue for me.

Jim, any thoughts on how to fix this?  Should I just revert this patch
for now?

greg k-h
