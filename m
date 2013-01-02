Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3ABXo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 18:44:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3ABXoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 18:44:23 -0500
Date: Wed, 2 Jan 2013 15:44:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        bug-track@fisher-privat.net
Subject: Re: [PATCH 2/2] fat: mark fs as dirty on mount and clean on umount
Message-Id: <20130102154422.53a84995.akpm@linux-foundation.org>
In-Reply-To: <87han7za23.fsf@devron.myhome.or.jp>
References: <87pq1vza3y.fsf@devron.myhome.or.jp>
	<87han7za23.fsf@devron.myhome.or.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2012 02:20:20 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> There is no documented methods to mark FAT as dirty. Unofficially MS
> started to use reserved Byte in boot sector for this purpose,
> at least since Win 2000. With Win 7 user is warned if fs is dirty
> and asked to clean it.
> Different versions of Win, handle it in different ways,
> but always have same meaning:
> - Win 2000 and XP, set it on write operations and
>   remove it after operation was finnished
> - Win 7, set dirty flag on first write and remove it on umount.
> 
> We will do it as fallow:
> - set dirty flag on mount. If fs was initially dirty, warn user,
>   remember it and do not do any changes to boot sector.
> - clean it on umount. If fs was initially dirty, leave it dirty.
> - do not do any thing if fs mounted read-only.
> - TODO: leave fs dirty if we found some error after mount.

The changelog doesn't describe why we're making this change.  Nor does
it describe the user-visible effects of this change.

AFAICT the effect is to issue a warning at mount-time to tell the
user that the fs wasn't cleanly unmounted and that the user should fsck
the volume, correct?

If so, why is this considered a desirable feature?  (I can guess, but
would prefer to hear it spelled out by the experts, please).

