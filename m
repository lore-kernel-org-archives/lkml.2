Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1FBXk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 19:40:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38549 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1FBXkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 19:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :mime-version:content-type;
        b=utGZj0ZyCIMmViV4L9slAjqMWuui3+b+7v6UCBN2LLluA05YDf2nJyb0UBlyTK21J2
         rO1+aZgADIenNnXlbHwWp4Tt8x3+HDveSyGpPoGHsHud4OfJTdK+XnbS0RQGHeCxWM6h
         IYEagKaTz2lW8q1/VUsrlitsn9EUPFn8Thmww=
From: Luis Henriques <luis.henrix@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] "mustnotsleep"
References: <1af7a43d-84fa-47c4-a145-409e5bac585b@default>
Date: Fri, 03 Jun 2011 00:36:19 +0100
In-Reply-To: <1af7a43d-84fa-47c4-a145-409e5bac585b@default> (Dan Magenheimer's
	message of "Thu, 2 Jun 2011 14:46:23 -0700 (PDT)")
Message-ID: <87hb87lsb0.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Magenheimer <dan.magenheimer@oracle.com> writes:

> In development of RAMster, I have frequently been bitten
> by indirect use of existing kernel subsystems that
> unexpectedly sleep.  As such, I have hacked the
> following "debug" code fragments for use where I need to
> ensure that doesn't happen.
>
> DEFINE_PER_CPU(int, mustnotsleep_count);
>
> void mustnotsleep_start(void)
> {
> 	int cpu = smp_processor_id();
> 	per_cpu(mustnotsleep_count, cpu)++;
> }
>
> void mustnotsleep_done(void)
> {
> 	int cpu = smp_processor_id();
> 	per_cpu(mustnotsleep_count, cpu)--;
> }
>
> and in schedule.c in schedule():
>
> if (per_cpu(mustnotsleep_count))
> 	panic("scheduler called in mustnotsleep code");
>
> This has enabled me to start identifying code that
> is causing me problems.  (I know this is a horrible
> hack, but that's OK right now.)

I'm pretty sure I'm missing something here but... what if you just use
CONFIG_DEBUG_PREEMPT?  Isn't that good enough?

Cheers,
--
Luis Henriques
