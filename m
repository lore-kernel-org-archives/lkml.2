Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1IPOlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:41:08 -0400
Received: from mail.anarazel.de ([217.115.131.40]:49114 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab1IPOlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:41:06 -0400
From: Andres Freund <andres@anarazel.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Improve lseek scalability v3
Date: Fri, 16 Sep 2011 16:41:04 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Matthew Wilcox <matthew@wil.cx>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <201109161616.50004.andres@anarazel.de> <20110916142319.GE7761@one.firstfloor.org>
In-Reply-To: <20110916142319.GE7761@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109161641.04321.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 Sep 2011 16:23:19 Andi Kleen wrote:
> > I sent an email containing benchmarks from Robert Haas regarding the
> > Subject. Looking at lkml.org I can't see it right now, Will recheck when
> > I am at home.
> I never saw that.
Hm. Not good. I see message in my imap folder marked as replied. I don't keep 
mail-server logs that long though...

> Thanks for the data.
Thats Roberts work though.

> > You likely won't be able to see the bottlenecks with any of the released
> > postgres versions as there are bottlenecks fixed in HEAD that throttle
> > way before that.
> FWIW we did some postgres testing on a 4 socket, but only with the heavily
> patched MOSBENCH version, which fixes various locking problems. Didn't run
> it with that patchkit though.
I don't really now what MOSBENCH changed but I think some of the fixes Robert 
are unlikely to be contained in there because they are more than just a rework 
of locking itself but algorithmic changes on another level.
(Should it interest you its its likely to be  
84e37126770dd6de903dad88ce150a49b63b5ef9, 
b4fbe392f8ff6ff1a66b488eb7197eef9e1770a4, 
3cba8999b343648c4c528432ab3d51400194e93b 
8e5ac74c1249820ca55481223a95b9124b4a4f95, ...)

I also think youre only likely to notice those problems if youre running a 
readonly test. The write-path is currently far to slow to see problems in that 
area.

Greetings,

Andres
