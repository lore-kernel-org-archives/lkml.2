Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030588Ab2B2AO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:14:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64877 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab2B2AO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:14:28 -0500
MIME-Version: 1.0
In-Reply-To: <4F4B78CE.4010405@redhat.com>
References: <1329464338-8351-1-git-send-email-pbonzini@redhat.com> <4F4B78CE.4010405@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Feb 2012 16:14:07 -0800
X-Google-Sender-Auth: _vlg_TKzTKJ-1kSq67NVjd_IiRM
Message-ID: <CA+55aFyoTxFcHZXa=XfxrK1JB0cksHxQPsRUiJnhAFeE=-hynw@mail.gmail.com>
Subject: Re: [PATCH v2] block: avoid false positive warnings on ioctl to partition
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 4:36 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Ping.

So I'm still not convinced this is safe, and feel a bit worried about
us possibly silently missing some things. That

   default:
      return -ENOIOCTLCMD;

is what worries me.

Blocking the ones we *know* about and understand I'm perfectly fine
with. And the SG_IO case looks fine. It's the possibly unknown users
that still worry me.

                  Linus
