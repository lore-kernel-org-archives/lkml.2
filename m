Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab1EMNjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:39:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52877 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092Ab1EMNjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:39:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=g8smaR+x9vmYW3WJSZxpg//lDRMp99nMqYsat5AXonzeUkGi4YkefvBOTuDaRPIuhl
         NDwM0VkflDLxT1niqALV1fxjjZtLAczDlfzT5kULskOPkJWxH9kTPGwh68rhPZrNVouN
         NgD5Hvues8lvHGoY2JFOyzOCmr6Wt4qrolEqw=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=YDZa+BRaG90vJsjrT9VxgySrDRQ@mail.gmail.com>
References: <BANLkTi=kb_m-CfrpnD8qQTVYLGaDdgy_tg@mail.gmail.com> <BANLkTi=YDZa+BRaG90vJsjrT9VxgySrDRQ@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 13 May 2011 09:39:14 -0400
X-Google-Sender-Auth: v-59R5pg1k7NOho4jAexC06Mqxk
Message-ID: <BANLkTinoGfj1NUzTveSH0vgwZczCaFr8HA@mail.gmail.com>
Subject: Re: AAARGH bisection is hard (Re: [2.6.39 regression] X locks up hard
 right after logging in)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, git@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend because the Android gmail client apparently generates HTML
emails even for plain text]

On Thu, May 12, 2011 at 1:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, May 12, 2011 at 10:15 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>>
>> OK, this sucks.  In the course of bisecting this, I've hit two other
>> apparently unrelated bugs that prevent my from testing large numbers
>> of kernels.  Do I have two questions:
>>
>> 1. Anyone have any ideas from looking at the log?
>
> Nope, that doesn't look very helpful.
>
>> 2.  The !&$#@ bisection is skipping all over the place.  I've seen
>> 2.6.37 versions and all manner of -rc's out of order.
>
> That's the _point_ of bisection. It jumps around. You can start off
> trying to pick points on my development tree, but I only have a
> hundred merges or so. You're going to start delving into the actual
> development versions very quickly. And if you don't do it early,
> bisection is going to be much much slower, because it's not going to
> pick half-way points.
>
> So bisection works so well exactly because it picks points that are
> far away from each other, and you should just totally ignore the
> version number. It's meaningless. Looking at it just confuses you.
> Don't do it.
>

I actually had better results looking at the version number, saying
"blech", and running git merge v2.6.38.  (git bisect good gets a
little confused if I feed it the merge result, but I can just lie.)

Anyway, I must have made a mistake somewhere.  The regression is in
drm (presumably i915) and it has a new thread now.

--Andy
