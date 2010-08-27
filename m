Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0H0Hh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:37:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44871 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab0H0HhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D1Jse4PKwLroKBOH8VKJTZjyZzPiSa+hwnggNEI/W7zQ6/K83Ds2xTA7ze5koKqCeM
         YQoju1alPvrir0cq5pMEbLLzApvUAiwNXrvcFCxqRpATH6gsISuAiSBTlME8TDiXRrHt
         qa7PJMrbciNEvXYq6pv8A6vIj4jr+q8W3qbxk=
Date: Fri, 27 Aug 2010 00:37:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nikitas Angelinas <nikitasangelinas@gmail.com>
Cc: Nikitas Angelinas <nikitasangelinas@googlemail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "21cnbao@gmail.com" <21cnbao@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: time: use ARRAY_SIZE macro in timecompare.c
Message-ID: <20100827073717.GA9120@core.coreip.homeip.net>
References: <1282520629-6542-1-git-send-email-nikitasangelinas@googlemail.com>
 <815E5C3B-CAB4-4BA0-8D41-301F512D13D3@gmail.com>
 <alpine.LNX.2.00.1008240024360.2452@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1008240024360.2452@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 12:27:08AM +0100, Nikitas Angelinas wrote:
> 
> 
> On Sun, 22 Aug 2010, Dmitry Torokhov wrote:
> 
> > On Aug 22, 2010, at 4:43 PM, Nikitas Angelinas
> > <nikitasangelinas@googlemail.com> wrote:
> > 
> > >Replace sizeof(buffer)/sizeof(buffer[0]) with ARRAY_SIZE(buffer) in
> > >kernel/time/timecompare.c
> > >
> > >Signed-off-by: Nikitas Angelinas <nikitasangelinas@googlemail.com>
> > >---
> > >kernel/time/timecompare.c |    5 +++--
> > >1 files changed, 3 insertions(+), 2 deletions(-)
> > >
> > >diff --git a/kernel/time/timecompare.c b/kernel/time/timecompare.c
> > >index ac38fbb..a9ae369 100644
> > >--- a/kernel/time/timecompare.c
> > >+++ b/kernel/time/timecompare.c
> > >@@ -21,6 +21,7 @@
> > >#include <linux/module.h>
> > >#include <linux/slab.h>
> > >#include <linux/math64.h>
> > >+#include <linux/kernel.h>
> > >
> > >/*
> > >* fixed point arithmetic scale factor for skew
> > >@@ -57,11 +58,11 @@ int timecompare_offset(struct timecompare *sync,
> > >   int index;
> > >   int num_samples = sync->num_samples;
> > >
> > >-    if (num_samples > sizeof(buffer)/sizeof(buffer[0])) {
> > >+    if (num_samples > ARRAY_SIZE(buffer)) {
> > >       samples = kmalloc(sizeof(*samples) * num_samples, GFP_ATOMIC);
> > 
> > That should be kcalloc while you are at it.
> > 
> > Thanks.
> > 
> > -- 
> > Dmitry
> > 
> > 
> 
> Thanks for pointing that out; however, the code as is does not do a
> memset to 0; is it worth using kcalloc in this case considering it has
> to go through an 'unlikely' and a subsequent memset?
> 

Ah, I see. Ignore me then.

Thanks.

-- 
Dmitry
