Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab2BDPRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 10:17:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47160 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2BDPRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 10:17:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120204100342.GA2626@osiris.boeblingen.de.ibm.com>
References: <20120203154411.GB2471@osiris.boeblingen.de.ibm.com>
 <20120203160454.GA3092@redhat.com> <CA+55aFx0SxW5ST2H1TL6K-457nP1qtAva0+YcnJLNoUUz_PCdg@mail.gmail.com>
 <20120204100342.GA2626@osiris.boeblingen.de.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 4 Feb 2012 07:16:51 -0800
X-Google-Sender-Auth: btbxuPR1rq014BT0QGlgElT3EJk
Message-ID: <CA+55aFzMm8oGB55GMK4GkzNViVLqWbNjgCkuFpFvG0EExbFQHA@mail.gmail.com>
Subject: Re: cgroup_release_agent() with call_usermodehelper() with
 UMH_WAIT_EXEC may crash
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        Sebastian Ott <sebott@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 4, 2012 at 2:03 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
>
> Something like the patch below? Still boots...

Yes, except that if we touch the comm copying code, let's do what Oleg
suggested and make it a helper function to create the "comm[]" data
array instead of open-coding it and adding new random local variables
to prepare_binprm().

But looks good otherwise. I'm a *bit* nervous that some
prepare_binprm() caller hasn't set up bprm->filename that early yet,
though. It seems like we expect that to be set up by the caller, which
seems a bit odd, actually.

                    Linus
