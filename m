Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2ACQNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:13:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab2ACQNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:13:38 -0500
Date: Tue, 3 Jan 2012 11:13:10 -0500
From: Dave Jones <davej@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: serial ports now asserting DTR and RTS during boot; breaks
 connected hardware
Message-ID: <20120103161310.GA8727@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jiri Slaby <jslaby@suse.cz>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120103153707.GA12771@redhat.com>
 <4F03262D.8090506@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F03262D.8090506@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 05:00:45PM +0100, Jiri Slaby wrote:
 > On 01/03/2012 04:37 PM, Dave Jones wrote:
 > > Jiri,
 > > We got this report from a user who notes a change in behaviour for
 > > his serial hardware over the last few kernel versions.
 > 
 > Hi!
 > 
 > I'm busy right now, however just after a quick look, it may be related to:
 > https://lkml.org/lkml/2011/12/6/573
 > 
 > I'll take a look later.

thanks. I'll dig a little deeper. 

 > > https://bugzilla.redhat.com/show_bug.cgi?id=771010
 > > 
 > > This sounds like it might be related to your DTR/RTS changes back in March 2011 maybe ? 
 > 
 > What changes do you mean? In serial-core.c? Thaat one is not used by USB
 > serials. Hence this wouldn't occur with FTDI.

yeah, 303a7a1199c20f7c9452f024a6e17bf348b6b398 and c7d7abff40c27f82fe78b1091ab3fad69b2546f9
jumped out at me, as they were they only things that changed DTR/RTS handling
(at least mentioned in changelog) in recent times.

The user mentions that it also affects 8250, though your point may mean
that this is caused by something further up in the serial/tty code.

	Dave 

