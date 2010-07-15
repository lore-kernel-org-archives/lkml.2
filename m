Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab0GOBHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 21:07:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43985 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0GOBHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 21:07:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sb/p/9ppdTOD3tfbfC0CaL148j9NuQVto6uwHmah2b3GFq0iLuw9VorYImAixnqRpN
         lPmSazovq/B2TBbIj48e2uDThxyTCMP7q1BwNnWDQ0EJLxwiPCKgqTg1x4CcdDTRO+yp
         z9hHuy6CVR+oQwVxCE8pxBiW4kU0XazqbxAl4=
Date: Wed, 14 Jul 2010 18:07:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bugzilla # 16395: Regression in 2.6.35-rc4 since commit
 0b28bac5aef7bd1ab213723df031e61db9ff151a on HP Mini 110 Netbook
Message-ID: <20100715010735.GA22418@core.coreip.homeip.net>
References: <4C3E4F2F.3090404@lwfinger.net>
 <201007141707.37234.dmitry.torokhov@gmail.com>
 <4C3E59CD.7050901@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3E59CD.7050901@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 07:43:57PM -0500, Larry Finger wrote:
> On 07/14/2010 07:07 PM, Dmitry Torokhov wrote:
> >On Wednesday, July 14, 2010 04:58:39 pm Larry Finger wrote:
> >>Since the commit in the title, a kernel built on an HP Mini 110 Netbook no
> >>longer has keyboard input. The main difference is that CONFIG_SERIO_I8042
> >>is no longer defined. When this equal yes, the keyboard works. The faulty
> >>commit was located by bisection and has been verified by reverting the
> >>patch.
> >>
> >>Further investigation shows that the faulty hunk is
> >>
> >>diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
> >>index 3bfe8fa..256b9e9 100644
> >>--- a/drivers/input/serio/Kconfig
> >>+++ b/drivers/input/serio/Kconfig
> >>@@ -22,7 +22,7 @@ config SERIO_I8042
> >>          tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
> >>          default y
> >>          depends on !PARISC&&  (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST)&&  \
> >>-                  (!SUPERH || SH_CAYMAN)&&  !M68K&&  !BLACKFIN
> >>+                  (!SUPERH || SH_CYes, AYMAN)&&  !M68K&&  !BLACKFIN&&
> >>!X86_MRST help
> >>            i8042 is the chip over which the standard AT keyboard and PS/2
> >>            mouse are connected to the computer. If you use these devices,
> >>
> >>Reverting this one hunk alone results in a working system. Obviously, this
> >>Netbook does not have X86_MRST set.
> >
> >
> >You meant to say "does have CONFIG_X86_MRST set", right?
> 
> Yes. I got lost in the negative logic. Since !X86_MRST is false,
> then X86_MRST has to be defined. In fact, .config has
> CONFIG_X86_MRST=y.
> 

Good. HPA posted a patch series that should fix the problem, in the mean
time just disable Moorestown support - you do not need it anyway.

-- 
Dmitry
