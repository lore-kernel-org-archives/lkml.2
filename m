Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab1EJQae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:30:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50566 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab1EJQad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=BaACPRZaOhnkS6cIKP9UNl0Lbvt0IY6NM3xFeDKWIiVesSwf4hxpDrT/9eK3FIjdVH
         UuFqG8xml1b2itXFV90FesvzKaOjki1y35A1i5ikevvNnAvboCR2zCRs0dViT4wK1rQ0
         +IHEBDUsSyF0nLBhNzuz645hWPxXMdBJXA7tc=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de
Subject: Re: [PATCH 0/6] overlay filesystem
References: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
	<BANLkTinNk=8F5qf13DJsKObJGLtQiRyA7A@mail.gmail.com>
Date: Tue, 10 May 2011 18:30:41 +0200
In-Reply-To: <BANLkTinNk=8F5qf13DJsKObJGLtQiRyA7A@mail.gmail.com> (Michal
	Suchanek's message of "Mon, 9 May 2011 21:14:44 +0200")
Message-ID: <87vcxijz66.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Suchanek <hramrach@centrum.cz> writes:

> Hello
>
> On 18 April 2011 18:00, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> Here's an updated version of the overlay filesystem.
>>
>> Git tree is here:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v8
>>
>> Changes from v7 to v8:
>>
>> - split overlayfs.c into smaller files
>>
>> - fix locking for copy up (reported by Al Viro)
>>
>> - locking analysis of copy up vs. directory rename added as a comment
>>
>> - tested with lockdep, fixed one lock annotation
>>
>> - other bug fixes
>>
>> To be done:
>>
>> - redo i_op->open, waiting for status of atomic_open() from Al
>>
>> - look into xattr support for tmpfs
>>
>
> What's still required for overlayfs to get into the kernel?
>
> With the additional patches posted in the v8 branch (the modular build
> fix and the xattr for tmpfs patch) overlayfs works for me.
>
> I rebuilt my linux rescue system to use
> overlayfs/tmpfs+squashfs/loop/fuse.httpfs and used it a few times
> without any issues.
>
> This system has about 1.6G data in 68599 files, 6960 directories and
> 7634 symlinks (compressed to about 630M squashfs).

Great, thanks for reporting on your test results.

Before posting v9 I'd like to clear up the bug observed by Jordi.  Then
it will need to be acked by Al Viro before going into mainline.

Thanks,
Miklos
