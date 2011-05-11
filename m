Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab1EKQUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:20:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62362 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab1EKQUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fbM/Eak/HcNVMhaF30aaYl1vrIZ2p/P+dP9kVR8uzih1MYxudbdqnGLWO0g+suTPi5
         bL7yriBK0d/JxvrKseNtnmL3q8b9IUMq8/Gl58SfBAnRariNu10/Uq3n5de7yZ1h5UKJ
         LWTISTRM3Bx+X2Rex+i/OpaAJ4Z7wXKEEPBc4=
Date: Wed, 11 May 2011 15:35:00 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, alan@linux.intel.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Add option to disable LVDS
Message-ID: <20110511133500.GA5358@Boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <20110510212038.GA3279@patrik-macbook>
 <20110510224602.73b24d0a@lxorguk.ukuu.org.uk>
 <BANLkTikz+PrQY2egkPTiacDSH5-Gkqkbww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BANLkTikz+PrQY2egkPTiacDSH5-Gkqkbww@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 01:18:07AM +0200, Patrik Jakobsson wrote:
> On Tue, May 10, 2011 at 11:46 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > On Tue, 10 May 2011 23:20:38 +0200
> > Patrik Jakobsson <patrik.r.jakobsson@gmail.com> wrote:
> >
> >> This patch adds the option to load the driver without LVDS support. Some platforms with the gma500 have nothing hooked up to LVDS but only uses SDVO. LVDS is still detected and added as an encoder which causes SDVO mode-setting to fail.
> >>
> >> Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
> >
> > What platform is this - I'd really like to keep such things automatic and
> > also if possible make the code handle the case not blow up. The user
> > shouldn't have to deal with such funnies.
> >
> > Alan
> >
> 
> This is for the FIT-PC2.
> 
> I agree, it's not a good way to handle it, but since I haven't been
> able to pinpoint the problem (and this is staging) it's something that
> works for now. Perhaps a nicer way to get around it is by checking
> against the dmi system id. That way it would be transparent to the
> user. But you might prefer we fix the real problem instead of hacking
> around it.
> 
> When both LVDS and SDVO is enabled the driver tries to set up both
> pipes and LVDS only finds a bogus mode of 0x0 pixels. Not sure why
> LVDS takes over instead of SDVO since it has valid modes, but my
> screen just goes into powersave when no proper PLL can be set for the
> bogus mode.
> 
> I'll do some more debugging tomorrow.

Im getting similiar problems although not to that extreme. It defaults back to
lowest common resolution which seems to be 1024x768, so in that sense I would
appreciate being able to turn it off. That being said, its an issue which will
eventually go away and therefore theres little point in implementing a workaround.

Best wishes
Kristoffer

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
