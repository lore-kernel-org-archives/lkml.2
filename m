Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab1D0XQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:16:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48178 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab1D0XQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=e1fUr2DGEx3DPl3OiHYOKcxrKqSKSNsWWXs5r1dbqiRgV1k9SXR9ubsdswPoMx9JRq
         AaygkunUSB18dIdZInQXcjuJsmqwB14l3JtUT6tFZgqLITDRvo5VWUz+BXXAK8dQak9B
         HZ6leon2lB/Jlb3fmIPIF7zWT/+KG7RACfL3M=
MIME-Version: 1.0
In-Reply-To: <20110427102824.GI12436@dastard>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
	<20110424234655.GC12436@dastard>
	<alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
	<alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
	<20110427022655.GE12436@dastard>
	<alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
	<20110427102824.GI12436@dastard>
Date: Thu, 28 Apr 2011 08:16:29 +0900
Message-ID: <BANLkTimDoZueDWqB_LBndqPorCnTOZkNYQ@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
From: Minchan Kim <minchan.kim@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 7:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Apr 27, 2011 at 12:46:51AM -0700, Christian Kujau wrote:
>> On Wed, 27 Apr 2011 at 12:26, Dave Chinner wrote:
>> > What this shows is that VFS inode cache memory usage increases until
>> > about the 550 sample mark before the VM starts to reclaim it with
>> > extreme prejudice. At that point, I'd expect the XFS inode cache to
>> > then shrink, and it doesn't. I've got no idea why the either the
>>
>> Do you remember any XFS changes past 2.6.38 that could be related to
>> something like this?
>
> There's plenty of changes that coul dbe the cause - we've changed
> the inode reclaim to run in the background out of a workqueue as
> well as via the shrinker, so it could even be workqueue starvation
> causing the the problem...

RCU free starvation is another possibility?
https://lkml.org/lkml/2011/4/25/124

-- 
Kind regards,
Minchan Kim
