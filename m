Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1HDXci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 19:32:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63246 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab1HDXcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 19:32:36 -0400
MIME-Version: 1.0
In-Reply-To: <20110804225418.GA2505@suse.de>
References: <1312497371-25685-1-git-send-email-grant.likely@secretlab.ca> <20110804225418.GA2505@suse.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 5 Aug 2011 00:32:15 +0100
X-Google-Sender-Auth: mDaZ5VYe9wSeoCuiW0SOYYjOLhU
Message-ID: <CACxGe6sQ2hQr4XTZ72mU-jMv1G4xO_NHp54L_c04L08pscaG9g@mail.gmail.com>
Subject: Re: [PATCH] devtmpfs: Fix section mismatch on devtmpfsd()
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 11:54 PM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Aug 04, 2011 at 11:36:11PM +0100, Grant Likely wrote:
>> devtmpfsd_init() references setup_done which is __initdata, but
>> devtmpfsd() is not an __init function.  The code is fine, because it
>> is never referenced after discarding __init sections, but it leaves
>> some additional code that can be discarded with the rest of __init and
>> it causes gcc to complain with a section mismatch warning.
>
> I have a simpler patch here that just removes the __initdata function,
> which is simpler.
>
> I hate the initdata stuff, it's almost always pointless...

initdata I don't mind.  Discarding stuff that is no longer necessary
isn't a bad thing and I don't find it that onerous.  __devinit* seems
less useful since I've never worked on a system that can actually
discard it.

> Would that solve the problem for you as well?

Sure.  I was just doing random sparc builds and fixing up the bugs I
ran into.  I'm happy with that solution too.

g.

g.
