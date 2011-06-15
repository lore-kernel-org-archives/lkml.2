Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1FOTwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:52:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382Ab1FOTwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:52:11 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=BDChiJfvj+b5iVamWHELDuWCT-A@mail.gmail.com>
References: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com>
 <BANLkTim_bHKdZnykedzW4re6GMCg+1Ed2g@mail.gmail.com> <BANLkTi=MvvdTZAHG3N=HHTQd9v6uPNHfzw@mail.gmail.com>
 <20110615071555.GA26721@dspnet.fr> <4DF90801.4090904@mit.edu> <BANLkTi=BDChiJfvj+b5iVamWHELDuWCT-A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 12:51:16 -0700
Message-ID: <BANLkTi=K9SNVsDNShdneY1k4-3jCND9M0Q@mail.gmail.com>
Subject: Re: Linux 3.0-rc3
To: Andy Lutomirski <luto@mit.edu>
Cc: Olivier Galibert <galibert@pobox.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 12:44 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I really don't see why you should ever parse a version number.

Let me modulate that: I do see why you would ever say "is this version
xyz" - but then you don't have to be very smart about parsing things,
because a failure to parse just means "no". So there is never any case
where a failure to parse something means that you cannot answer the
question, and failure to parse it never becomes a failure for the
program itself.

So doing

  if (!strncmp(version, "v2.4", 4))
     workaround_for_old_version = true;

is valid. But only if you really have special code for those specific
old versions that you know, and have normal code for everything else.

So if you then confinue with

  else if (!strncmp(version, "v2.6", 4))
     error("unknown version");

then you're just being an ass.

Why? At that point you're no longer correcting for known bugs or
mis-features, at that point you're just being stupid and parsing the
version string for no good reason.

So "checking for _particular_ old versions that you know about" is
fine. Checking for versions you _don't_ know about or understand is
stupid.

                            Linus
