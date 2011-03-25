Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1CYQON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:14:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35579 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1CYQOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:14:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=t635tMPpWo+9gG5Csv0SZXe287WNCG4f+P2+bu4Z0XenulRDI3F4wqUo9krEYiU07+
         Z2gkDruwAHGlq+mebU4reTI6Zcn+03qLQGX5mz1BB2LhEJDKesOJLXrehc8SCRuwccel
         VJZIoivX1iVz9lEHzfrbLO9pjFlQSURCaXWxs=
Date: Fri, 25 Mar 2011 09:14:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH 2/2] eeepc-wmi: Add support for T101MT Home/Express Gate
 key
Message-ID: <20110325161405.GC5099@core.coreip.homeip.net>
References: <20110324195720.GB31713@thinkpad-t410>
 <1300997035-14104-2-git-send-email-seth.forshee@canonical.com>
 <AANLkTimF2UR8BVQW-3YJaGFEz39q8ydESAiMOjmdM1X7@mail.gmail.com>
 <20110325135311.GA14328@thinkpad-t410>
 <AANLkTin3MDYdL6x1Qs8Q9oMMgDMfsoO2GjWMJO_65GAR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin3MDYdL6x1Qs8Q9oMMgDMfsoO2GjWMJO_65GAR@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 02:05:18PM +0000, Corentin Chary wrote:
> On Fri, Mar 25, 2011 at 1:53 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> >
> > I guess it depends on what key events we want on a press-and-hold.
> > Remember that you're going to get a scan code sequence like "0xe4 0xea
> > 0xea ... 0xea 0xe5", so with my implementation you get
> >
> >  KEY_PROG2 press
> >  KEY_PROG2 release
> >
> > With yours
> >
> >  KEY_HOME press
> >  KEY_PROG2 press
> >  KEY_PROG2 release
> >  // KEY_PROG2 press/release repeats every 0.5 secs while button held
> >  KEY_HOME release
> >
> > At minimum I'd think we'd want to only send a single PROG2 press/release
> > for button hold. My thought was that you'd only want to get the code for
> > 0xe4 or 0xea, not both, but I suppose that's debatable.
> 
> If you keep a keyboard key pressed, you want multiple events, not one right ?
> I think it's important not to loose informations. If someone keep this
> key pressed more than 1.5 second, I think it's good idea to send
> multiple KEY_PROG2.

You can have input autorepeat facilities do that for you. If you want to
do this yourself then the proper value for repeated events is _2_, not
1, or they will be dropped as duplicates.

> 
> About KEY_HOME press / release, and filtering KEY_HOME after
> KEY_PROG2, I'm not sure. So if you really want it, and nobody
> complains, I'll be happy to accept your patch.
> 
> > And back to the question of KEY_HOME -- that's not really what you want,
> > is it? As in "move cursor to start of line"?
> 
> Ho .. right, that's what mean KEY_HOME :/. So no, I don't want that...
> What about:
> - KEY_CYCLEWINDOWS
> - KEY_COMPUTER
> - KEY_HOMEPAGE
> - KEY_DASHBOARD
> 
> I think KEY_HOMEPAGE is the best choice.

No, KEY_HOMEPAGE should cause your browser to go to your home page. What
you want is either:

#define KEY_CONFIG         171     /* AL Consumer Control Configuration */
#define KEY_DASHBOARD      204     /* AL Dashboard */

("AL" stands for "Application Launcher", "AC" for 'Application Control",
matched loosely to HUT tables).

Thanks.

-- 
Dmitry
