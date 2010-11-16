Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0KPRmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:42:08 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50330 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab0KPRmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:42:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ucuDduD1CjCWMJ9g2+UpVlVMxJVGbBag0ml/1X8uGaqpcGPiFDMWo8tEOFJTAD8CfX
         1qsYV3UQc4h8eAiYijZh3Y3l50VXg1pnMpPJKuSAIe2ueft+0WprRtAD33dU6f4ayzIq
         fanQo41GSqpRXEpkvYxxLa81ch7V9d8qcBf+w=
Date: Tue, 16 Nov 2010 09:41:50 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mattia Dongili <malattia@linux.it>
Cc: Norbert Preining <preining@logic.at>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101116174150.GA31851@core.coreip.homeip.net>
References: <20101110035833.GB3029@kamineko.org>
 <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
 <20101112034423.GA7407@srcf.ucam.org>
 <20101112035027.GD26742@gamma.logic.tuwien.ac.at>
 <20101112035732.GB7574@srcf.ucam.org>
 <20101112042243.GE2852@kamineko.org>
 <20101112043922.GA19889@gamma.logic.tuwien.ac.at>
 <20101112121742.GA17690@kamineko.org>
 <20101116051642.GA24410@gamma.logic.tuwien.ac.at>
 <20101116141849.GB2111@kamineko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116141849.GB2111@kamineko.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:18:50PM +0900, Mattia Dongili wrote:
> On Tue, Nov 16, 2010 at 02:16:42PM +0900, Norbert Preining wrote:
> > On Fr, 12 Nov 2010, Mattia Dongili wrote:
> > > You will need an updated input-kbd to set the scancode map.
> > 
> > Ouch.
> > 
> > > > Does that mean that 2.6.37rc is too new for the user space?
> > > 
> > > Maybe. Anyway if evtest reacts positively to key presses then it's a
> > > userspace issue and not the driver's.
> > 
> > What is strange that there *WAS* a change in the kernel that triggered
> > that. Old kernels still work fine. I just tried 2.6.36 and it was working.
> > 
> > I always thought that kernel changes should not break user space
> > (well, without good reason).
> 
> it's the same as this:
> https://bugzilla.kernel.org/show_bug.cgi?id=23022
> 

Right, we up-revved evdev protocol version to reflect the fact that it
supports large scancodes but the procotocl is backwards-compatible and
older userspace should have no problems talking with evdev and do
remaps. For example, udev's keymap utility workds just fine here.
Unfortunately input-kbd insists on working with only one version of the
protocol instead if checking if the protocol "at least N". This shoudl
be fixed in input-kbd.

Thanks.

-- 
Dmitry
