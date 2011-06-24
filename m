Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1FXVx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:53:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:46798 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab1FXVx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:53:26 -0400
Message-ID: <4E05073A.3030209@infradead.org>
Date: Fri, 24 Jun 2011 18:52:58 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jesper Juhl <jj@chaosbits.net>,
        LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        linux-media@vger.kernel.org, ceph-devel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Subject: Re: [RFC] Don't use linux/version.h anymore to indicate a per-driver
 version - Was: Re: [PATCH 03/37] Remove unneeded version.h includes from
 include/
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>	<4E04912A.4090305@infradead.org>	<BANLkTim9cBiiK_GsZaspxpPJQDBvAcKCWg@mail.gmail.com>	<201106241554.10751.hverkuil@xs4all.nl>	<4E04A122.2080002@infradead.org>	<20110624203404.7a3f6f6a@stein>	<BANLkTimj-oEDvWxMao6zJ_sudUntEVjO1w@mail.gmail.com> <20110624231028.7f03dcae@stein>
In-Reply-To: <20110624231028.7f03dcae@stein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-06-2011 18:10, Stefan Richter escreveu:
> On Jun 24 Devin Heitmueller wrote:
>> Really, this is all about applications being able to jam a hack into
>> their code that translates to "don't call this ioctl() with some
>> particular argument if it's driver W less than version X, because the
>> driver had a bug that is likely to panic the guy's PC".  Sure, it's a
>> crummy solution, but at this point it's the best that we have got.
> 
> The second best.  The best that we have got is that the user runs a fixed
> kernel.
> 
> Anyway; if this is the only purpose that this interface version¹ serves,
> then Mauro's subsystem-centralized solution has the benefit that it
> eliminates mistakes due to oversight by individual driver authors.
> Especially because the kind of implementation behavior changes that are
> tracked by this type of version datum are sometimes just discovered or
> documented in hindsight.  On the other hand, Mauro's solution is redundant
> to the uname(2) syscall.

Yes. That's why my initial proposal were to add some value to it by not associating
it with the kernel version, but with a number that will be incremented only if
the V4L2 API changes.

> 
> ¹) Yes, it is still an ABI version, nothing less.  With all its backwards
> and forwards compatibility ramifications.

