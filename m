Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1FOToq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:44:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991Ab1FOTop convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:44:45 -0400
MIME-Version: 1.0
In-Reply-To: <4DF90801.4090904@mit.edu>
References: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com>
 <BANLkTim_bHKdZnykedzW4re6GMCg+1Ed2g@mail.gmail.com> <BANLkTi=MvvdTZAHG3N=HHTQd9v6uPNHfzw@mail.gmail.com>
 <20110615071555.GA26721@dspnet.fr> <4DF90801.4090904@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 12:44:23 -0700
Message-ID: <BANLkTi=BDChiJfvj+b5iVamWHELDuWCT-A@mail.gmail.com>
Subject: Re: Linux 3.0-rc3
To: Andy Lutomirski <luto@mit.edu>
Cc: Olivier Galibert <galibert@pobox.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 12:29 PM, Andy Lutomirski <luto@mit.edu> wrote:
>
> Well, the man page says that the version parameter is used to find
> /lib/modules/version.  So why not check if /lib/modules/version exists and,
> if not, try the filename?

Yeah, that's the only sane way to see if something is a filename: look
up the file. If you can find it, it's a filename.

It's what 'git' uses to decide between the ambiguity of a filename vs
a commit name, for example. It works really well. And sometimes, when
the ambiguity is not resolvable (ie you really meant a filename, but
there's a version that has the exact same format), then you are
fundamentally screwed - you need some other way to tell the difference
(which could be a simple priority decision - "filename overrides
version" - or it can be a command line thing).

So stop trying to parse the version number, and just see if
'/lib/modules/%s' exists for that (unparsed) version string. Or, if
you want to prioritize it the other way, just check for existence of
the file of the (again, unparsed) version string with a simple
"access(%s, F_OK)" or something.

I really don't see why you should ever parse a version number.

                               Linus
