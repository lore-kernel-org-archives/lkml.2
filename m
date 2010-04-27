Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab0D0MsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:48:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49064 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0D0MsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:48:09 -0400
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Apr 2010 08:48:09 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=C85zu6qRB+Fvv3IjKktyM3Mr4I1lArRQ7a+Ye88pZR5g1BeYJHd3LGlCnDPZaMT4UI
         wCD3INtYaG8cPk2Z7hkOJPvdLwOY5s6gH9tZi/csRZqVSW1lAVvrBYFdNfBqWDmkc/ZK
         JF8aCgVtqg2TAC6rpTxWCfCLMcy39U2NR98ZI=
MIME-Version: 1.0
In-Reply-To: <201004271331.58130.arnd@arndb.de>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
	 <201004271331.58130.arnd@arndb.de>
Date: Tue, 27 Apr 2010 14:40:36 +0200
Message-ID: <i2rc62985531004270540g42d99595rc7c83dfa172f18e4@mail.gmail.com>
Subject: Re: [PATCH 00/10] bkl: pushdowns from Arnd, and compile fixes
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/27 Arnd Bergmann <arnd@arndb.de>:
> On Tuesday 27 April 2010, John Kacur wrote:
>> These are bkl pushdowns from Arnd that conflicted with
>> Linus's "Preparation for BKL'ed ioctl removal patch". I fixed-up the merge
>> conflicts. In addition - during allyesconfig compile testing on x86_64 I found
>> a number of issues that I fixed-up
>
> Thanks for catching the scsi bugs! It was getting late yesterday night, so
> I didn't go through a full allyesconfig then.
>
>> I pushed these to my own new linus-bkl tree.
>> git://www.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git linux-bkl
>>
>> Frederic, if you want to grab those, pls do so. also, we might want to combine
>> my compile fixes with Arnd's push-down patches, for better git bisectability.
>
> Yes, your fixes (except the v4l2 patch, see comment there) should best be
> merged into the main patches.
>
> The idea was that if we manage to kill all fops->ioctl users right away,
> we wouldn't even need Linus' patch and move to dungeon level 2 directly.
> Either way works for me though.



Yeah. Since we are motivated enough to do the whole pushdown, I think we
should forget the .bkl_ioctl renaming.

This will let Greg take the staging part for example. I can take all
the unmainted rest
(basically most of the rest I guess).
