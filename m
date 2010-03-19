Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab0CSAbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:31:07 -0400
Received: from mail-iw0-f196.google.com ([209.85.223.196]:57988 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab0CSAbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KEdYs/8IJ8nYwW68Ia2UbIPhMxVDNRk0x1J/T6Ua+ys0ie8JUIaeP80HzsXQGJy4dC
         bQaa/kzQ/DKz/9/Gbsct5tDBjXMMZAq5W9E0T/Mi0UADPWpTjcG6FjY/Xr4CTtpJp42X
         DOMCRMSqAoemZzIuo0r787b9sj1jusXruFIXM=
Date: Thu, 18 Mar 2010 17:30:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC] Input: implement sysrq as an input handler
Message-ID: <20100319003054.GA5825@core.coreip.homeip.net>
References: <20100317061952.GA19789@core.coreip.homeip.net>
 <4BA2C1AF.7010205@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA2C1AF.7010205@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 05:13:35PM -0700, Randy Dunlap wrote:
> On 03/16/10 23:19, Dmitry Torokhov wrote:
> > Instead of keeping SysRq support inside of legacy keyboard driver split
> > it out into a separate input handler (filter). This stops most SysRq input
> > events from leaking into evdev clients (some events, such as first SysRq
> > scancode - not keycode - event, are still leaked into both legacy keyboard
> > and evdev).
> > 
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > ---
> > 
> >  drivers/char/keyboard.c |   40 +-------
> >  drivers/char/sysrq.c    |  222 +++++++++++++++++++++++++++++++++++++++++------
> >  include/linux/sysrq.h   |   23 +----
> >  kernel/sysctl.c         |   23 +++++
> >  4 files changed, 224 insertions(+), 84 deletions(-)
> 
> 
> > +/* Simple translation table for the SysRq keys */
> > +static const unsigned char sysrq_xlate[KEY_MAX + 1] =
> > +        "\000\0331234567890-=\177\t"                    /* 0x00 - 0x0f */
> > +        "qwertyuiop[]\r\000as"                          /* 0x10 - 0x1f */
> > +        "dfghjkl;'`\000\\zxcv"                          /* 0x20 - 0x2f */
> > +        "bnm,./\000*\000 \000\201\202\203\204\205"      /* 0x30 - 0x3f */
> > +        "\206\207\210\211\212\000\000789-456+1"         /* 0x40 - 0x4f */
> > +        "230\177\000\000\213\214\000\000\000\000\000\000\000\000\000\000" /* 0x50 - 0x5f */
> > +        "\r\000/";                                      /* 0x60 - 0x6f */
> 
> We are running out of these precious sysrq keys.
> Do you have any ideas of how to have a larger xlate table?
> 

When we run out we could add shift modifiers I guess.

-- 
Dmitry
