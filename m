Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab0H3Qe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:34:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63731 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab0H3Qe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:34:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m79gg94DVDcyIHcjxs9zjs7k3g4a4fN3UG/tnqtwqLwRaWnbiJ6McLtWKyLdHdInp5
         rTdq04mne5vszDSTi39t1RAF3Fko67MkzeFeQdi54MsrlpMCz7SdQLPbhV5iugGuiEjp
         vvf/yDVdtiXNogNrjoFjU0JK6TyNEMxe++Okk=
Date: Mon, 30 Aug 2010 09:34:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Xing Wei <weixing@hanwang.com.cn>
Cc: jkosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] input: Add support for Hanwang tablet
Message-ID: <20100830163446.GB17325@core.coreip.homeip.net>
References: <201008302133119064558@hanwang.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008302133119064558@hanwang.com.cn>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 09:33:12PM +0800, Xing Wei wrote:
> On Mon, 30 Aug 2010, Jiri Kosina Wrote: 
> > > On Mon, 30 Aug 2010, Xing Wei wrote:
> > >  
> > > +config TABLET_USB_HANWANG
> > > +	tristate "Hanwang Art Master III tablet support (USB)"
> > > +	depends on USB_ARCH_HAS_HCD
> > > +	select USB
> > > +	help
> > > +	  Say Y here if you want to use the USB version of the Hanwang Art
> > > +	  Master III tablet.  Make sure to say Y to "Mouse support"
> > > +	  (CONFIG_INPUT_MOUSEDEV) and/or "Event interface support"
> > > +	  (CONFIG_INPUT_EVDEV) as well.
> > 
> > Is there any reason why you don't have these (MOUSEDEV and EVDEV) as 
> > explicit Kconfig dependencies?
> > 
> > Thanks,
> > 
> 
> I just reference the other USB tablet on this Kconfig,like aiptek,acecad,wacom.
> Actually it depends on EVDEV at least now.
> I can submit another patch if necessarry.
> 

Actually I think we should just drop references to particular input
handlers in the Kconfig as, strictly speaking, the driver does not
depend on either of them.

The text in other tablets came from time when whole input layer was a
novelty and nobody was sure what should be enabled. Nowadays every
distribution (I hope) has evdev enabled as it becomes main interface
between X and kernel and the legacy mouse and keyboard interfaces
(MOUSEDEV) are fading away.

While we are talking about the patch - I am usually OK with extending past
80 column limit, but some of the lines are pretty excessive. I'd prefer
not going above 95-100 unless it is a message string - we do not want to
break those.

Thanks.

-- 
Dmitry
