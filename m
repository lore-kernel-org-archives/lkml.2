Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab0KDLbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 07:31:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52665 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0KDLbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 07:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MLoBhKHBfs0/SNeZURM1OQjrRXw68zyTtShjQdiP2yRooLq9F0xLvBwB8PbP+iq8Tv
         oFEDISTwXXWR+tJLcGhWdATS5NFCQbZ9SEb+9Szru+nK9XRj3x1eDXYFjkXDSZWWTIB0
         RNpXZ8fGhW5uf3Mo2/DbEf9QppkjOcRJWBIF8=
Date: Thu, 4 Nov 2010 04:31:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Arce, Abraham" <x0066660@ti.com>
Cc: Naveen Kumar GADDIPATI <naveen.gaddipati@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCHv1] staging: Synaptics RMI4 touchpad driver support
Message-ID: <20101104113108.GA27223@core.coreip.homeip.net>
References: <1288699725-14405-1-git-send-email-naveen.gaddipati@stericsson.com>
 <20101102140337.GC9387@kroah.com>
 <4CD01CD8.3090206@stericsson.com>
 <20101102154029.GH11778@core.coreip.homeip.net>
 <20101103181058.GE7441@kroah.com>
 <20101103190752.GA4552@core.coreip.homeip.net>
 <20101103191958.GA9912@kroah.com>
 <27F9C60D11D683428E133F85D2BB4A530468A82B1A@dlee03.ent.ti.com>
 <81C3A93C17462B4BBD7E272753C105791945AAD82C@EXDCVYMBSTM005.EQ1STM.local>
 <27F9C60D11D683428E133F85D2BB4A530468A82CF3@dlee03.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27F9C60D11D683428E133F85D2BB4A530468A82CF3@dlee03.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arce,

On Thu, Nov 04, 2010 at 12:45:45AM -0500, Arce, Abraham wrote:
> Hi Naveen, Dmitry,
> 
> > From: Naveen Kumar GADDIPATI [mailto:naveen.gaddipati@stericsson.com]
> > 
> > Hi Arce,
> > 
> > I'm also the GPIO pin for interrupt with request threaded irq .
> > I'm passing the irq_type from the platform data.
> > Which irq_type are you using for your platform?
> > 
> 
> I am using the following flags
> 
>   IRQF_DISABLED | IRQF_TRIGGER_LOW | IRQF_TRIGGER_FALLING
> 
> Should I get rid of the first one, IRQF_DISABLED?
> 
>   IRQF_DISABLED - keep irqs disabled when calling the action handler
> 

You probably want IRQF_TRIGGER_LOW | IRQF_ONESHOT if your interrupt is
level tiggered.

IRQF_TRIGGER_LOW | IRQF_TRIGGER_FALLING mixes edge and level options and
thus I don't think is proper.

-- 
Dmitry
