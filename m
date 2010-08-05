Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754Ab0HEGnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:43:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60257 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab0HEGnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:43:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=k7I4j56yaAJkvAxcMAXTTrALblGv5+XO8N0ddgdI0FXgok0xwB6u/OD+2+hdv/bLFv
         xZW1jzNK+OVbr6LlkNEyB+ybEvpfysh0eev+3a0NT/9xekt6IKnEHoeDk50XRt5tedtS
         1b2FBkjWxnhQ0D6/C1ArkzI9QxglX8IsiAGqo=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH] RFC: AMBA bus discardable probe() function
Date: Wed, 4 Aug 2010 23:43:26 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.35+; KDE/4.4.5; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        Viresh KUMAR <viresh.kumar@st.com>
References: <1280925543-6862-1-git-send-email-linus.walleij@stericsson.com> <20100804194319.GA30722@suse.de> <CEE6BB42CAD6E947908279175AF8470A0262E58F8B@EXDCVYMBSTM006.EQ1STM.local>
In-Reply-To: <CEE6BB42CAD6E947908279175AF8470A0262E58F8B@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008042343.27043.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 04, 2010 11:26:00 pm Linus WALLEIJ wrote:
> [Greg]
> 
> > [Me]
> > 
> > > +	spin_lock(&amba_bustype.p->klist_drivers.k_lock);
> > 
> > Ick, nope, you can't do this, sorry.  That's a "private" structure for
> > a reason.
> 
> Yeah I get it, but in the platform bus case what's that traversal of
> the klists actually for? I didn't get it, and was guessing that it
> was considering the case where devices spawn new devices.

It is to check if the driver actually bound to any devices and fail driver
registration if it did not - then, in case of modular build, entire driver
module might get unloaded from memory as well.

-- 
Dmitry
