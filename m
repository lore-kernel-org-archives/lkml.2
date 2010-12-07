Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab0LGQvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:51:10 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49352 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0LGQvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P7RxHK3q/eIoEmKf8LIFwR7XIxzyhfKhy/JJsTFVgLPIEm3lnV2M8qGeQ/BLdBJDHy
         qFYGgWgOHOYqbsUqL1Phi8gqY+A1fK4mbRFVsknQxc1NVCeyqFtCqeGU5EJ3ifaQlC1X
         cIp5WoNPtT0hf5GvHXnlPeNOdxJ8TTl4LLVSw=
Date: Tue, 7 Dec 2010 08:51:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Henrik Rydberg <rydberg@euromail.se>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
Message-ID: <20101207165101.GB25344@core.coreip.homeip.net>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
 <20101207091653.GA22416@core.coreip.homeip.net>
 <AANLkTimnSsfCG0WtDpa-qEu3N1uMOeo+CzzZ8wsaZN1v@mail.gmail.com>
 <201012071340.26244.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012071340.26244.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 01:40:26PM +0100, Arnd Bergmann wrote:
> On Tuesday 07 December 2010, Kay Sievers wrote:
> > On Tue, Dec 7, 2010 at 10:16, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > Hi Henrik,
> > >
> > > On Tue, Dec 07, 2010 at 08:25:26AM +0100, Henrik Rydberg wrote:
> > >> Today, userspace sets up an input device based on the data it emits.
> > >> This is not always enough; a tablet and a touchscreen may emit exactly
> > >> the same data, for instance, but the former should be set up with a
> > >> pointer whereas the latter does not need to. Recently, a new type of
> > >> touchpad has emerged where the buttons are under the pad, which changes
> > >> handling logic without changing the emitted data. This patch introduces
> > >> a new ioctl, EVIOCGDEVINFO, which allows userspace to extract information
> > >> about the device resulting in proper setup.
> > >
> > > If we agree that the new ioctl is suitable we'llalso need to wireit up
> > > through sysfs. Also, can we keep all definitions to INPUT_ namespace?
> > 
> > Please don't add new ioctls which are not extensible. The ioctl should
> > carry the length or the version of the structure it asks for, so it
> > can be extended in the future. Sysfs should be good enough for such
> > interface though.
> 
> Please never add any ioctls that have a version or length field!
> 
> Ideally ioctls should have only scalar arguments, not structures,
> so I'd recommend splitting it into two, so you can read type and
> capability parameters separately.

Yes, I think it is a good idea to turn it into 2 scalar ioctls.

-- 
Dmitry
