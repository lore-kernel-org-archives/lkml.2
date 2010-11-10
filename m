Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0KJWiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:38:07 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:35607 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab0KJWiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:38:06 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [bisected] i915 regression in post 2.6.36 kernels
Date: Wed, 10 Nov 2010 23:39:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.3; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <201011100802.20332.johannes.hirte@fem.tu-ilmenau.de> <0d30dc$k4n8nm@orsmga001.jf.intel.com>
In-Reply-To: <0d30dc$k4n8nm@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011102339.36590.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 November 2010 08:46:40 Chris Wilson wrote:
> On Wed, 10 Nov 2010 08:02:19 +0100, Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de> wrote:
> > With the latest kernel, I don't get any windows in KDE displayed. After
> > starting kdm, I get the background picture and the mouse cursor but not the
> > login window. I can login blindly and a ps on console shows me that the
> > expected KDE processes are started but still nothing is displayed. 
> > I've bisected this to:
> > 
> > 5c12a07e8073295ce8b57a822f811ac34e4f8420 is the first bad commit
> > commit 5c12a07e8073295ce8b57a822f811ac34e4f8420
> > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > Date:   Wed Sep 22 11:22:30 2010 +0100
> > 
> >     drm/i915: Drop ring->lazy_request
> >     
> >     We are not currently using it as intended, so remove the complication.
> > 
> >     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> 
> May I ask you to recheck your bisection, since that was later reverted.
> -Chris

Did so. I've started with v2.6.36 for bisect good and 
f6614b7bb405a9b35dd28baea989a749492c46b2 for bisect bad (was HEAD) in this
case. Again I ended in 5c12a07e8073295ce8b57a822f811ac34e4f8420 as the first
bad commit. The regression was introduced there, as the commit before is fine.
If it was reverted, the regression should be fixed by this. But I don't find
neither the fix/revert nor the reintroduction of the regression.

regrards,
  Johannes
