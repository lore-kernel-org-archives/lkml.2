Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab0LHGCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 01:02:10 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:39066 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab0LHGCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 01:02:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qXj6YzysRu/gGvkW85Bo1qLS8JwyObyuShm+ABt8ujqSP2fHUlqPFh6cWCJAD6jP1M
         JMioOhq6NOmfAbTU5Zcs5xVodnaY/+DV4pNjKFHVmlOW9iU0GVbN04YBqOhw9l9gftUn
         dk3Rhw6hH2R3lyxjadk2nyslTKeh/lrm/M19M=
Date: Tue, 7 Dec 2010 22:02:00 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
Message-ID: <20101208060200.GD4140@core.coreip.homeip.net>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
 <20101207091653.GA22416@core.coreip.homeip.net>
 <4CFE919A.1040704@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFE919A.1040704@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 08:57:14PM +0100, Henrik Rydberg wrote:
> On 12/07/2010 10:16 AM, Dmitry Torokhov wrote:
> 
> > Hi Henrik,
> > 
> > On Tue, Dec 07, 2010 at 08:25:26AM +0100, Henrik Rydberg wrote:
> >> Today, userspace sets up an input device based on the data it emits.
> >> This is not always enough; a tablet and a touchscreen may emit exactly
> >> the same data, for instance, but the former should be set up with a
> >> pointer whereas the latter does not need to. Recently, a new type of
> >> touchpad has emerged where the buttons are under the pad, which changes
> >> handling logic without changing the emitted data. This patch introduces
> >> a new ioctl, EVIOCGDEVINFO, which allows userspace to extract information
> >> about the device resulting in proper setup.
> > 
> > If we agree that the new ioctl is suitable we'llalso need to wireit up
> > through sysfs. Also, can we keep all definitions to INPUT_ namespace?
> > 
> > Thanks.
> > 
> 
> 
> Thanks all for the comments, this is what I extract from them:
> 
> * Split struct into separate calls, although this still seems debated.
> 
> * Use INPUT_ namespace
> 
> * Add sysfs version
> 
> * Keep bitmask for types. Is the list of types complete?

Most likely not but it can be easily extended on as-needed basis.

> 
> * Still only one data point for capabilities. Anything else?

Again, no need to define everything upfront.

One concern is that while 32 distinct device types should be enough
should we plan for larger capability array? Should we use variable
length ioctl - like EVIOCGKEY(len) - even though Arnd does not like
them?

Also, we already have /sys/class/input/input0/capabilities/ so should we
call new data item something else? Quirks maybe?

-- 
Dmitry
