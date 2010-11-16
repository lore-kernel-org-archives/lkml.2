Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409Ab0KPMhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 07:37:42 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53769 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052Ab0KPMhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 07:37:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hi+OKM5sVs0In9p7tPNe5UwvrQAi9ft3Kpy3d8F/zdSjkhAM0s8RMpIZPkl6dl7eFO
         bcnFRszRssx/KftXXgIJuUL5ps1149/yJNvWZ7e/TLfxdfPxwqW3pDCkGxdE6nihovqy
         7NI5ky44KBkjprlevVZIMxBE+3R7TUJLutuEM=
MIME-Version: 1.0
In-Reply-To: <20101116122503.GF4757@quack.suse.cz>
References: <20101115004134.9618.6393.stgit@zaytsev.su>
	<20101116122503.GF4757@quack.suse.cz>
Date: Tue, 16 Nov 2010 15:37:39 +0300
Message-ID: <AANLkTi=EtGgXcGEKvoCQZRO+Ru6Yj7ARfEyrzCWcbDD_@mail.gmail.com>
Subject: Re: [PATCH] [RFC] fsnotify: Tell the user what part of the file might
 have changed
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>, linux-fsdevel@vger.kernel.org,
        tvrtko.ursulin@sophos.com, stefan@buettcher.org,
        linux-kernel@vger.kernel.org, agruen@linbit.com,
        Scott Hassan <hassan@dotfunk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 15:25, Jan Kara <jack@suse.cz> wrote:
>  Hello,
>
> On Mon 15-11-10 00:44:08, Alexey Zaytsev wrote:
>> Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
>> ---
>>
>> Hi.
>>
>> The patch adds fschange-like [1] modification ranges to
>> fsnotify events. Fanotify is made to pass the range
>> to the users.
>  What I always found a bit awkward about inotify/fanotify is that you get
> no notification if the file modification happens via mmap(). For backup
> programs this is certainly unacceptable so you have to track open events
> and check mtime anyway because of this.
>
> We could start sending MODIFY events when writeable mmap happens (IMHO a
> sensible thing to do) but with ranges you have to watch out to send a
> range like 0..((1<<64)-1) to accommodate future file changes.
>
>                                                                Honza

Actually, it should be possible to monitor the mmaps. Not individual
writes, of course, but you should be able to get the write-mapped
range from close_write. Have not implemented this in the first
version, but it's possible to do. By the way, splice also is not
handled by fsnotify yet. Not sure, are there any other ways to modify
a file?
