Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab0HWX0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 19:26:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33473 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0HWX0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 19:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ZIIew7ptTh/SESzH4X9zw7RsevcW+HHupcrLU3+P0ThWwv5/Kl78rDYB9gI6GTQyR6
         h6q8aZRsQH7Qrn2BzYf4ICPuQGnEOeDtYZevjZZ/l7SpK/XuSZchenrxNHxbmaMEeU0+
         kiWIPe/UCfqjVg0HjkH+ipTkWoWcGb+48lyGw=
Date: Tue, 24 Aug 2010 00:27:08 +0100 (BST)
From: Nikitas Angelinas <nikitasangelinas@gmail.com>
X-X-Sender: nikitas@localhost.localdomain
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Nikitas Angelinas <nikitasangelinas@googlemail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "21cnbao@gmail.com" <21cnbao@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: time: use ARRAY_SIZE macro in timecompare.c
In-Reply-To: <815E5C3B-CAB4-4BA0-8D41-301F512D13D3@gmail.com>
Message-ID: <alpine.LNX.2.00.1008240024360.2452@localhost.localdomain>
References: <1282520629-6542-1-git-send-email-nikitasangelinas@googlemail.com> <815E5C3B-CAB4-4BA0-8D41-301F512D13D3@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Aug 2010, Dmitry Torokhov wrote:

> On Aug 22, 2010, at 4:43 PM, Nikitas Angelinas
> <nikitasangelinas@googlemail.com> wrote:
> 
> >Replace sizeof(buffer)/sizeof(buffer[0]) with ARRAY_SIZE(buffer) in
> >kernel/time/timecompare.c
> >
> >Signed-off-by: Nikitas Angelinas <nikitasangelinas@googlemail.com>
> >---
> >kernel/time/timecompare.c |    5 +++--
> >1 files changed, 3 insertions(+), 2 deletions(-)
> >
> >diff --git a/kernel/time/timecompare.c b/kernel/time/timecompare.c
> >index ac38fbb..a9ae369 100644
> >--- a/kernel/time/timecompare.c
> >+++ b/kernel/time/timecompare.c
> >@@ -21,6 +21,7 @@
> >#include <linux/module.h>
> >#include <linux/slab.h>
> >#include <linux/math64.h>
> >+#include <linux/kernel.h>
> >
> >/*
> >* fixed point arithmetic scale factor for skew
> >@@ -57,11 +58,11 @@ int timecompare_offset(struct timecompare *sync,
> >   int index;
> >   int num_samples = sync->num_samples;
> >
> >-    if (num_samples > sizeof(buffer)/sizeof(buffer[0])) {
> >+    if (num_samples > ARRAY_SIZE(buffer)) {
> >       samples = kmalloc(sizeof(*samples) * num_samples, GFP_ATOMIC);
> 
> That should be kcalloc while you are at it.
> 
> Thanks.
> 
> -- 
> Dmitry
> 
> 

Thanks for pointing that out; however, the code as is does not do a
memset to 0; is it worth using kcalloc in this case considering it has
to go through an 'unlikely' and a subsequent memset?

If required, I guess I should post a patch on a separate thread so that
Git picks up the correct patch title?

Kind Regards,
Nikitas
