Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab0LOXxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:53:13 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:17976 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080Ab0LOXxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:53:12 -0500
Date: Wed, 15 Dec 2010 15:53:12 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Show version information for built-in modules in sysfs
Message-ID: <20101215235312.GA15328@dtor-ws.eng.vmware.com>
References: <20101215220019.GA6560@dtor-ws.eng.vmware.com>
 <AANLkTikuWubUkGp2nESWTLz+kQsczznh7fuixdLzMfdO@mail.gmail.com>
 <20101215221454.GB6560@dtor-ws.eng.vmware.com>
 <AANLkTindv4GUp3E8Vzkzm_JzGxxOP+TdaAsVhxrEVOw6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTindv4GUp3E8Vzkzm_JzGxxOP+TdaAsVhxrEVOw6@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 03:25:27PM -0800, Alexey Dobriyan wrote:
> On Thu, Dec 16, 2010 at 12:14 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
> > On Wed, Dec 15, 2010 at 02:06:03PM -0800, Alexey Dobriyan wrote:
> >> On Thu, Dec 16, 2010 at 12:00 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
> >> > Currently only drivers that are built as modules have their versions
> >> > shown in /sys/module/<module_name>/version, but this information might
> >>
> >> Can you create just /sys/module/x?
> >> Module version info is quite useless by itself.
> >
> > It is as useful as in the case where driver is built as a module. I am
> > just trying to unify the behavior a bit.
> >
> > Code-wise it is almost as cheap to add /sys/module/x/version as adding
> > just the directory.
> 
> OK.
> 
> Still, people are using /sys/module/x presence as indicator of modular
> built (unsurprisingly).
> 
> http://codesearch.google.com/codesearch/p?hl=en#wZuuyuB8jKQ/src/third_party/autotest/files/client/profilers/powertop/src/bluetooth.c&q=/sys/modules&sa=N&cd=3&ct=rc&l=105

Yeah, I hate to disappoint them but it will break as soon as someone
adds a module_param() to one of the objects... That's even without my
changes.

-- 
Dmitry
