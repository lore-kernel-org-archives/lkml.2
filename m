Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab2JIM14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:27:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62065 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab2JIM1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:27:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/16] vfs: bogus warnings in fs/namei.c
Date: Tue, 9 Oct 2012 12:27:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
References: <1349448930-23976-1-git-send-email-arnd@arndb.de> <1349448930-23976-6-git-send-email-arnd@arndb.de> <20121008115116.GA9243@quack.suse.cz>
In-Reply-To: <20121008115116.GA9243@quack.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210091227.46324.arnd@arndb.de>
X-Provags-ID: V02:K0:fFqnY5mWnTncU7Y+evbYjqdYheObY6tAYm2ISrFvKKx
 qaUdCLpBkdiQbAUxZVcDfLW0x8Jw3DMUJmKFYnAHpyo0SXW/gP
 mBAeipxoAMzx4ik5EjVWvjwQd1Wgy3ffzRkOJYQp9iBVQfc4Q7
 oDsRKz32ISMl/IaCz83Y/suJ6YuGldXjdp4ONXF1XzqeA+vd3J
 KPX6wdNT5qJPihQeqFk8E8IviXlMhqGpXNMgFe239GEbXtkK5B
 rTIgYGTDO+WNoM0+S8ySyWotdeUg4rDxciuDppTm9U9JdPleka
 bX/Ri+vfa0TnESzwPhbqkcUvtoxKjkCgoNSRaM92eld+jm46H+
 x/gqosNLsDIJzJ/sBb0U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 October 2012, Jan Kara wrote:
> On Fri 05-10-12 16:55:19, Arnd Bergmann wrote:
> > The follow_link() function always initializes its *p argument,
> > or returns an error, but not all versions of gcc figure this
> > out, so we have to work around this using the uninitialized_var()
> > macro.
>   Well, I'm somewhat sceptical to this approach. I agree that bogus
> warnings are not nice but later when the code is changed and possibly real
> use without initialization is added, we won't notice it. Without changing
> anything, we'd at least have a chance of catching it with gcc versions
> which were clever enough to not warn with the original code. Or
> alternatively if we unconditionally initialized the variable that would get
> rid of the warning and made the code more future-proof (that's what I
> usually end up doing)... I don't really care that much about the chosen
> solution, Al is the one to decide. But I wanted to point out there are
> downsides to your solution.

I'll drop the patch for now and won't send it from my tree then. I agree
that uninitialized_var() is not ideal, but none of the alternatives seemed
better.

With my latest compiler, I don't actually see the warnings any more, so
maybe someone fixed gcc instead, or this went away after another change.
I'll let you know if it comes back so we can discuss about a better fix then.

	Arnd
