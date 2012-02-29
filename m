Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2B2T5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:57:22 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57058 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab2B2T5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:57:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of madrabbit@gmail.com designates 10.60.7.70 as permitted sender) smtp.mail=madrabbit@gmail.com; dkim=pass header.i=madrabbit@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4DDE14.8050406@redhat.com>
References: <1329464338-8351-1-git-send-email-pbonzini@redhat.com>
 <4F4B78CE.4010405@redhat.com> <CA+55aFyoTxFcHZXa=XfxrK1JB0cksHxQPsRUiJnhAFeE=-hynw@mail.gmail.com>
 <4F4DDE14.8050406@redhat.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Wed, 29 Feb 2012 11:56:47 -0800
X-Google-Sender-Auth: fd6nnctJx6nTwEx4IFEJ0S1pxZA
Message-ID: <CADU53JUvh1a=0NgN87jV24PLY6GJma2bW=kFK_5ejFEp1djwEQ@mail.gmail.com>
Subject: Re: [PATCH v2] block: avoid false positive warnings on ioctl to partition
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 12:13 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Il 29/02/2012 01:14, Linus Torvalds ha scritto:
> > So I'm still not convinced this is safe, and feel a bit worried about
> > us possibly silently missing some things. That
> >
> >    default:
> >       return -ENOIOCTLCMD;
> >
> > is what worries me.
> >
> > Blocking the ones we *know* about and understand I'm perfectly fine
> > with. And the SG_IO case looks fine. It's the possibly unknown users
> > that still worry me.
>
> I understand.
>
> But being 100% sure that nothing breaks is
> impossible, unfortunately, so does it make sense to aim at 100%?  And it
> should be extremely easy to bisect failures.  Even with all the
> differences, it reminds me of the recent change to poll.

You can help avoid the bisect entirely by silently dropping the ones
you're sure about, and noisily dropping the ones you aren't.
