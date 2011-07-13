Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965227Ab1GMJsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 05:48:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34450 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965091Ab1GMJs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 05:48:28 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Ian Kent <ikent@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Union mount and lockdep design issues
References: <1310305703.13309.7.camel@twins> <4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<4DA5DCB8.3040101@gmail.com>
	<BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
	<4DA5F569.9020309@gmail.com>
	<BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
	<24792.1302808448@redhat.com> <2477.1309342656@redhat.com>
	<4E1962BE.8010204@redhat.com> <1408.1310382069@redhat.com>
	<1310385651.18678.59.camel@twins>
	<CAOMqctQoO7zKojoEuYri8ZWDDMM3Ef6VRtPYzsf-02xhJ8e6jA@mail.gmail.com>
	<1310392232.4276.14.camel@perseus.themaw.net>
	<CAOMqctSDxauVLw5OisAeCaFa7DvZDgg_1YCmHaWdJZm60JDVtg@mail.gmail.com>
	<1310405033.4276.28.camel@perseus.themaw.net>
	<CAOMqctSZcAuA8r=Bdtg1hhM9xzDmDuOPn376HXuQ0Tb8xrRwzw@mail.gmail.com>
	<87tyar6gv8.fsf@tucsk.pomaz.szeredi.hu>
	<CAOMqctQauGk0XszoUo61k4GQ5gWWWgyRXY9x9J=D+K4kMJ_CUw@mail.gmail.com>
	<87liw367uj.fsf@tucsk.pomaz.szeredi.hu>
	<CAOMqctSYVuzpCUN+QjB7n7rZrrH4c-hHz=iC7kX70JED_dbLyA@mail.gmail.com>
Date: Wed, 13 Jul 2011 11:49:15 +0200
In-Reply-To: <CAOMqctSYVuzpCUN+QjB7n7rZrrH4c-hHz=iC7kX70JED_dbLyA@mail.gmail.com>
	(Michal Suchanek's message of "Tue, 12 Jul 2011 20:49:13 +0200")
Message-ID: <87liw24ijo.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Suchanek <hramrach@centrum.cz> writes:

> You can still do
>
> mount --bind /lower1 /lower2/lower1
> mount --bind /lower2 /lower1/lower2
>
> Which is technically not against usage guidelines, unlike mount --bind
> /upper /lower1/upper

Overlayfs will take the directory you specify as upperdir and lowerdir
and will clone those mounts internally.

This means that any present or future submounts are ignored and the
mount containting those directories may be moved or umounted and
overlayfs will still function.

None of the bind mounts above will have any effect on an overlayfs that
uses /lower[12] and /upper.

> If crossing mount boundaries is forbidden try with symlinks or hardlinks.

I'm not sure what you mean here.

Thanks,
Miklos
