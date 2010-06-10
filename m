Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199Ab0FJSiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:38:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47291 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab0FJSiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KfV6ZR8WhC93xi/jEtqTnH+0Ypd2PBceLaMMXGxsc6ycKc0lKXV5aiDuFG2IsAZHaa
         sE2fITyl6u+jKJy8FMA2Shjzbd5JK459amhx+aNx+hUTLDWGkS2Qmsp6NE85HOzahCoI
         t2shZwjvD67MOWp9nbE3dT/5/Dvl6TIjBC6lY=
MIME-Version: 1.0
In-Reply-To: <877hm64ui4.fsf@basil.nowhere.org>
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>
	<877hm64ui4.fsf@basil.nowhere.org>
Date: Thu, 10 Jun 2010 12:38:10 -0600
Message-ID: <AANLkTik3XiOjYM67RdPG-3RM3rY-0vondiMmJsETAHfX@mail.gmail.com>
Subject: Re: Aerospace and linux
From: Brian Gordon <legerde@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's also a serious consideration for standard servers.
Yes. Good point.

> On server class systems with ECC memory hardware does that.

> Normally server class hardware handles this and the kernel then reports
> memory errors (e.g. through mcelog or through EDAC)

Agreed.  EDAC is a good and sane solution and most companies do this.
Some do not due to naivity or cost reduction.   EDAC doesn't cover
processor registers and I have fairly good solutions on how to deal
with that in tiny "home-grown" tasking systems.

On the more exotic end, I have also seen systems that have dual
redundant processors / memories.  Then they add compare logic between
the redundant processors that compare most pins each clock cycle.   If
any pins are not identical at a clock cycle, then something has gone
wrong (SEU, hardware failure, etc..)

> Lower end systems which are optimized for cost generally ignore the
> problem though and any flipped bit in memory will result
> in a crash (if you're lucky) or silent data corruption (if you're unlucky)

Right!  And this is the area that I am interested in.  Some people
insist on lowering the cost of the hardware without considering these
issues.  One thing I want to do is to be as diligent as possible (even
in these low cost situations) and do the best job I can in spite of
the low cost hardware.

So, some pages of RAM are going to be read-only and the data in those
pages came from some source (file system?).   Can anyone describe a
high level strategy to occasionaly provide some coverage of this data?

So far I have thought about page descriptors adding an MD5 hash
whenever they are read-only and first being "loaded/mapped?" and then
a background daemon could occasionaly verify.   Does tripwire
accomplish this kind of detection by monitoring the underlying
filesystem (I dont think so)?
