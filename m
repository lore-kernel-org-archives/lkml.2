Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab0JGDiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 23:38:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38471 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab0JGDiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 23:38:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=O3vkFaQPRLsgToYf+noU4z0nMRlsgCPGSb8vzjWufb6AKzZrxSzaTMUBDwo7y0k19i
         yIt3rq94rJratSFWqpBMRRMLySel8gRyB69Wbt9X6/tab4JtfBW2IMcfO1bt2+9rScnV
         64McNW7HeQtGl7ByxflSep7hxNoJcq2T3XgN4=
Subject: Re: System freeze on shutdown - bisected to commit 29d08b3efddc
From: Ben Skeggs <skeggsb@gmail.com>
Reply-To: skeggsb@gmail.com
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimR4JYmA4n0kGZ+mHqEfNUrxoLMAC6hW6s4-YhF@mail.gmail.com>
References: <AANLkTikBXb-QZ2twFUZHzzYSHyZz1Kca4GRLu_6bo+Oo@mail.gmail.com>
	 <1286324509.2505.0.camel@clockmaker-el6>
	 <AANLkTimR4JYmA4n0kGZ+mHqEfNUrxoLMAC6hW6s4-YhF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 13:38:26 +1000
Message-ID: <1286422706.2468.1.camel@nisroch>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v	gOn Wed, 2010-10-06 at 23:29 -0400, Marc Dionne wrote:
> On Tue, Oct 5, 2010 at 8:21 PM, Dave Airlie <airlied@redhat.com> wrote:
> > On Tue, 2010-10-05 at 18:24 -0400, Marc Dionne wrote:
> >> Hi,
> >>
> >> My system has been crashing these past few days when issuing "reboot"
> >> or hitting the Shut Down button in gnome.  I get a series of stack
> >> traces scrolling on the console before things freeze up completely.
> >> The traces that I do see at the end point to kmem_cache_alloc called
> >> from get_empty_filp, but there are typically various other traces
> >> above it.
> >
> > cc'ing Ben.
> >
> > Dave.
> 
> Some more testing shows that what causes the crash is when
> drm_gem_object_unreference_unlocked gets called in
> nouveau_notifier_takedown_channel.  The refcount on the object is
> always 1 at that point - on entry to nouveau_notifier_takedown I see a
> handle_count of 0 and a refcount of 1 in most cases, and sometimes a
> handle_count of 1 and a refcount of 2.  Either way the call to
> drm_gem_object_unreference_unlocked will bring the refcount to 0.
> Not sure if that's normal at that point.
> 
> Commenting out that particular call to
> drm_gem_object_unreference_unlocked gets rid of the crash.
How about if you remove the drm_get_object_handle_unreference_unlocked()
call from that function instead?

Ben.
> 
> Marc


