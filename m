Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0IVRbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:31:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:58583 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0IVRbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:31:40 -0400
Date: Wed, 22 Sep 2010 18:31:37 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Subject: Re: [Patch, RFC] Make struct fb_info ref-counted with kref
In-Reply-To: <20100921090255.410da2d7@pluto.restena.lu>
Message-ID: <alpine.LFD.2.00.1009221829590.25874@casper.infradead.org>
References: <20100919172833.14bf291e@neptune.home> <4C963E99.9080207@gmx.de> <20100919190240.65762511@neptune.home> <4C97B079.8050707@gmx.de> <20100920213258.1218b284@neptune.home> <4C97BF40.6030708@gmx.de> <20100920223608.19b4d177@neptune.home>
 <4C97E00B.6090103@gmx.de> <20100921075610.1c016c12@pluto.restena.lu> <4C985309.5020205@gmx.de> <20100921090255.410da2d7@pluto.restena.lu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1985284609-1077275912-1285176697=:25874"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1985284609-1077275912-1285176697=:25874
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


> > Bruno Prémont schrieb:
> > > On Tue, 21 Sep 2010 00:28:27 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> > >>> Tracking if/how often framebuffer is opened as such is a separate thing (though
> > >>> all users that have the framebuffer opened hold a reference to fb_info).
> > >> That's what I said. So as long as refcount <= 1 it does not matter whether you 
> > >> just count on open/release or additionally on every framebuffer operation, just 
> > >> that the later produces more noise.
> > > 
> > > Hm, I don't count on every framebuffer operation... in most cases
> > > fb_info is provided as function argument, in which case no further
> > > counting is needed as the caller has a valid reference.
> > > 
> > > With my patch applied refcount for registered but unsed framebuffer was
> > > 2 (once for the driver, once for registered_fb entry) and went up to 3
> > > when userspace opened framebuffer. fbcon's usage only incremented
> > > refcount for very short timeframes when effectively using fb_info.
> > > 
> > > When starting with the FB minor I have to take a new reference.
> > > (though I maybe should check if file's private data is set and use
> > > that reference instead of looking up fb_info by minor as is currently
> > > done)
> > > 
> > > For fbcon all the references are taken by FB minor (I wondered why
> > > fbcon only remembers index into registered_fb aka minor instead of
> > > fb_info itself)
> > 
> > True, I guess fb infrastructure and fbcon both could use a lot of work. At the 
> > moment I am more at fixing my driver but once that's done to an acceptable level 
> > I think I'll give it a try, too.
> 
> This year someone said he/she would look at making it possible to have
> multiple concurrently active consoles on distinct framebuffers.
> Hopefully something is happening on that front (that would certainly
> also include some fbcon cleanup)

That would be me. I have a tree at

http://git.infradead.org/users/jsimmons/linuxconsole-2.6.git

but currently fbcon is broken so I'm tracing down the problem.
--1985284609-1077275912-1285176697=:25874--
