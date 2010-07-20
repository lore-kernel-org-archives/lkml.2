Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab0GTBMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 21:12:15 -0400
Received: from smtp107.rog.mail.re2.yahoo.com ([68.142.225.205]:47091 "HELO
	smtp107.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757005Ab0GTBMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 21:12:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=XRmWvlEgZcxR3tS8aUEI6UqP4d74UWLcZuFrwY1DgM9fLAI7FJ1QOiaK962n4tzbv4mR2ORVjesbZarj1XOBhQLbwQvkkfDNbHYKpZRprNnXbfioe9U0Q/DXpOgx8hHGUgXIkzuatDkDpkrCVr/X+gaW+RfTUZYiCzXYNe2uKpI=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: _cjAY.IVM1mktwY_XibzyoRrcFfKQHRVKHHd1gWqflOamaJ
 hgTv7wriPu3AfuGV2zdHx4SBx2NwYPGvrvJTw1656cRg8VGZ2ZfQLv3O2bOQ
 yALIksN2fXWuX8b9Ntux8uDDm_oUWiZ1ra44_5F_hUtq8cJa.l8yTwU2ZUga
 qVBA.USdioKDWZaC4c6qe6ErWlh1FhI2wPGJSdADJ5NkEFjKKpzoPOeIG_eH
 vxFU1UzI3qqNDsUqpyrgAmXIdQzVZvNr2FaEJXsZlYaTP3d2dBF.pkQ9QpxV
 jRsiWR9f_M2bhSI_mQthmVUg3aeayU9EEWc0pqjIyIX95JfkhSDhO720OK8B
 2FKmPOw1.mRghgsINnBqzMr3_aW5haumiVvW1LSXeCyAeqtYZLu81e1jJPox
 zCKd0NeIc7rrXwQra0mrxVqBqHqvs4fxc55vhXw--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc4-git3: Reported regressions from 2.6.34
Date: Mon, 19 Jul 2010 21:12:08 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.92; x86_64; ; )
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <201007082336.25201.shawn.starr@rogers.com> <201007192033.30849.shawn.starr@rogers.com>
In-Reply-To: <201007192033.30849.shawn.starr@rogers.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007192112.08468.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 19, 2010 08:33:30 pm Shawn Starr wrote:
> On Thursday, July 08, 2010 11:36:25 pm Shawn Starr wrote:
> 
> <snip>
> 
> > > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16311
> > > > Subject         : [REGRESSION][SUSPEND] 2.6.35-rcX won't suspend
> > > > Lenovo W500 laptop Submitter       : Shawn Starr
> > > > <shawn.starr@rogers.com> Date            : 2010-06-28 0:45 (11 days
> > > > old)
> > > > Message-ID      : <201006272045.17004.shawn.starr@rogers.com>
> > > > References      :
> > > > http://marc.info/?l=linux-kernel&m=127768633705286&w=2
> > > 
> > > I think this might be usefully bisected. Shawn?
> > 
> > I'll have to try bisecting this weekend. It continues in Linux sh0n.net
> > 2.6.35-rc4+ #1 SMP Wed Jul 7 23:58:41 EDT 2010 x86_64 x86_64 x86_64
> > GNU/Linux
> 
> This continues even with no USB devices plugged in. Will try with today's
> snapshot build from Linus's tree. If this still happens, I'll see about
> bisecting.
> 
> Thanks,
> Shawn.

I also am testing this patch I noticed in anholt's tree, this may be GPU 
suspend issue.

diff --git a/drivers/gpu/drm/i915/i915_suspend.c  
b/drivers/gpu/drm/i915/i915_suspend.c
index 60a5800..6e20252 100644 (file)
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -602,7 +602,9 @@ void i915_save_display(struct drm_device *dev)
 
        /* Only save FBC state on the platform that supports FBC */
        if (I915_HAS_FBC(dev)) {
-               if (IS_GM45(dev)) {
+               if (IS_IRONLAKE_M(dev)) {
+                       dev_priv->saveDPFC_CB_BASE = 
I915_READ(ILK_DPFC_CB_BASE);
+               } else if (IS_GM45(dev)) {
                        dev_priv->saveDPFC_CB_BASE = I915_READ(DPFC_CB_BASE);
                } else {
                        dev_priv->saveFBC_CFB_BASE = I915_READ(FBC_CFB_BASE);
@@ -706,7 +708,10 @@ void i915_restore_display(struct drm_device *dev)
 
        /* only restore FBC info on the platform that supports FBC*/
        if (I915_HAS_FBC(dev)) {
-               if (IS_GM45(dev)) {
+               if (IS_IRONLAKE_M(dev)) {
+                       ironlake_disable_fbc(dev);
+                       I915_WRITE(ILK_DPFC_CB_BASE, dev_priv-
>saveDPFC_CB_BASE);
+               } else if (IS_GM45(dev)) {
                        g4x_disable_fbc(dev);
                        I915_WRITE(DPFC_CB_BASE, dev_priv->saveDPFC_CB_BASE);
                } else {

