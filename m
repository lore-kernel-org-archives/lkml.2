Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab0GTCNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 22:13:08 -0400
Received: from smtp102.rog.mail.re2.yahoo.com ([206.190.36.80]:40424 "HELO
	smtp102.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754981Ab0GTCNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 22:13:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Yl2h1PMRVF2zbmRJOK/n/1JUjrxu/Mt0PEiZ+c5yoq5OHL+/ojf4/Em8d/JqIogUekjwkZ6sBbjcS7L4RDjqxNS4cWz3qBl25qikc7zfvkpJdEO6UtDvJtM9kVuRuLOFU9Sal+IhGVcxPXneCPkAueJ0Ysfyt1CLFMcsG483TvU=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: 4kaIkAwVM1kc3VhfQzh98.rAV7tTa7YsIMgI09io5U9d7dD
 QC3SC39rHLDlLi.giIbZGXqrY4ipzZ6fogkOZptlX26JnYp0EEu0zna76Tul
 FO5Lx5zUqkmJ9mieAbzg476Vrxdhr5.fZrQv7zBjSN.opJv9YitC9j6afoYJ
 2_fVGIIJyYD.sxmiRZQUdni65pF7ADGOsDQ7IcbHqvLs9vxpVd9.Bhh7zJHg
 rMQQSkKSa.e0sctvVHpXscBMugN3rUbrLYCTd_qxpoVrFv99EPfeBtAI7FOX
 y47jqrudsl8TJy6l5LkY.pbc9Trv0QQfYB_KYlyLKdyGxbjALDW1YxPPLBAn
 auKn_Kqt350QyLmRWcuUou7H7TJNXlHPoS_2Wr7uylUqaGusM2zKC1chDLRo
 jisn1QEH99g9R7WDjP310a3j.VZ24RaM2w62BpQ--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc4-git3: Reported regressions from 2.6.34
Date: Mon, 19 Jul 2010 22:13:01 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc5; KDE/4.4.92; x86_64; ; )
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <201007192033.30849.shawn.starr@rogers.com> <201007192112.08468.shawn.starr@rogers.com>
In-Reply-To: <201007192112.08468.shawn.starr@rogers.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007192213.01304.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 19, 2010 09:12:08 pm Shawn Starr wrote:
> On Monday, July 19, 2010 08:33:30 pm Shawn Starr wrote:
> > On Thursday, July 08, 2010 11:36:25 pm Shawn Starr wrote:
> > 
> > <snip>
> > 
> > > > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16311
> > > > > Subject         : [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend
> > > > > Lenovo W500 laptop Submitter       : Shawn Starr
> > > > > <shawn.starr@rogers.com> Date            : 2010-06-28 0:45 (11 days
> > > > > old)
> > > > > Message-ID      : <201006272045.17004.shawn.starr@rogers.com>
> > > > > References      :
> > > > > http://marc.info/?l=linux-kernel&m=127768633705286&w=2
> > > > 
> > > > I think this might be usefully bisected. Shawn?
> > > 
> > > I'll have to try bisecting this weekend. It continues in Linux sh0n.net
> > > 2.6.35-rc4+ #1 SMP Wed Jul 7 23:58:41 EDT 2010 x86_64 x86_64 x86_64
> > > GNU/Linux
> > 
> > This continues even with no USB devices plugged in. Will try with today's
> > snapshot build from Linus's tree. If this still happens, I'll see about
> > bisecting.
> > 
> > Thanks,
> > Shawn.
> 
> I also am testing this patch I noticed in anholt's tree, this may be GPU
> suspend issue.
> 
> diff --git a/drivers/gpu/drm/i915/i915_suspend.c
> b/drivers/gpu/drm/i915/i915_suspend.c
> index 60a5800..6e20252 100644 (file)
> --- a/drivers/gpu/drm/i915/i915_suspend.c
> +++ b/drivers/gpu/drm/i915/i915_suspend.c
> @@ -602,7 +602,9 @@ void i915_save_display(struct drm_device *dev)
> 
>         /* Only save FBC state on the platform that supports FBC */
>         if (I915_HAS_FBC(dev)) {
> -               if (IS_GM45(dev)) {
> +               if (IS_IRONLAKE_M(dev)) {
> +                       dev_priv->saveDPFC_CB_BASE =
> I915_READ(ILK_DPFC_CB_BASE);
> +               } else if (IS_GM45(dev)) {
>                         dev_priv->saveDPFC_CB_BASE =
> I915_READ(DPFC_CB_BASE); } else {
>                         dev_priv->saveFBC_CFB_BASE =
> I915_READ(FBC_CFB_BASE); @@ -706,7 +708,10 @@ void
> i915_restore_display(struct drm_device *dev)
> 
>         /* only restore FBC info on the platform that supports FBC*/
>         if (I915_HAS_FBC(dev)) {
> -               if (IS_GM45(dev)) {
> +               if (IS_IRONLAKE_M(dev)) {
> +                       ironlake_disable_fbc(dev);
> +                       I915_WRITE(ILK_DPFC_CB_BASE, dev_priv-
> 
> >saveDPFC_CB_BASE);
> 
> +               } else if (IS_GM45(dev)) {
>                         g4x_disable_fbc(dev);
>                         I915_WRITE(DPFC_CB_BASE,
> dev_priv->saveDPFC_CB_BASE); } else {


Made no difference, today's git snapshot, 2.6.35-rc5-git4 w/ airlied + anholt 
drm git trees still hangs attempting to suspend. in Fedora, it drops to the 
Fedora logo w/ KMS mode then fails to finish suspending (moon light flashes 
off and on), I do hear the disk heads parking though.

I will look at bisecting this week when time permits. If anyone else might 
know what might be the issue it would save some time in the bisecting.


Thanks,
Shawn.
