Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab2DRP4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:56:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49381 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2DRP4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120418153225.GA6589@ZenIV.linux.org.uk>
References: <4F8ED911.90309@dreamhost.com>
	<20120418153225.GA6589@ZenIV.linux.org.uk>
Date: Wed, 18 Apr 2012 08:56:01 -0700
X-Google-Sender-Auth: GoKpQfILJtAOKTLTq4YmB0B6LIs
Message-ID: <CAC-hyiHfVH5C6CS43kCBQ1LO9JUN-rqxrS-UvtJQ_YyWxUWp6w@mail.gmail.com>
Subject: Re: osd_req_encode_op() breakage?
From: Yehuda Sadeh Weinraub <yehuda.sadeh@dreamhost.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alex Elder <elder@dreamhost.com>, Sage Weil <sage@newdream.net>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 8:32 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Wed, Apr 18, 2012 at 10:09:05AM -0500, Alex Elder wrote:
>
> > Yes, you are absolutely correct.
> >
> > We have obviously not done endianness checks in this code for
> > some time.
> >
> > I will commit a fix and credit you for it.  I'll also make sure
> > we are doing proper testing for this sort of thing on a regular
> > basis.
>
> FWIW, that got caught by sparse, but I would really recommend _testing_
> on big-endian - getting an emulated headless e.g. mips box is fairly
> easy with qemu; I'd done that with debian big-endian mips userland on
> emulated malta and it didn't take much work to set up.
>
> Speaking of sparse, I think we simply ought to add -D__CHECK_ENDIAN__
> to CHECKFLAGS in top-level Makefile.  It's not _that_ much noise
> these days...  Not sure which tree should that go through, though...

Definitely. I've run sparse on that code from time to time, but
completely forgot about this flag and assumed everything was ok.

Yehuda
