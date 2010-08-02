Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab0HBNVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 09:21:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58540 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0HBNVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 09:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I6fJ++U5du1qsXq36lFAryQ6N6VTnVqGQSlHlWm8bvCjA7X30ArD9luW5nLXYyOPc0
         WHAW5UNg/sDMKXDJ0s+pRx6+5XfMzqpr4OPuEQqZfZeZtwn1FDnwv2X5MRVaSFi2x8nl
         jG4vmOi/y+6xKud6cx6irT2v0OGnx2jqjuZsY=
MIME-Version: 1.0
In-Reply-To: <215565.1280754056@localhost>
References: <20100802111955.025275647@szeredi.hu>
	<20100802112024.851698363@szeredi.hu>
	<215565.1280754056@localhost>
Date: Mon, 2 Aug 2010 15:21:48 +0200
Message-ID: <AANLkTimpYoFmGoy_he0vND9FwixcuhBrz2a8NUbhoO4w@mail.gmail.com>
Subject: Re: [PATCH 6/7] vfs: only add " (deleted)" where necessary
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 3:00 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Mon, 02 Aug 2010 13:20:01 +0200, Miklos Szeredi said:
>
>> Index: linux-2.6/fs/dcache.c
>> ===================================================================
>> --- linux-2.6.orig/fs/dcache.c        2010-07-06 18:08:16.000000000 +0200
>> +++ linux-2.6/fs/dcache.c     2010-07-06 18:08:19.000000000 +0200
>> @@ -1977,8 +1977,7 @@ global_root:
>>   * @buffer: buffer to return value in
>>   * @buflen: buffer length
>>   *
>> - * Convert a dentry into an ASCII path name. If the entry has been deleted
>> - * the string " (deleted)" is appended. Note that this is ambiguous.
>> + * Convert a dentry into an ASCII path name.
>>   *
>>   * Returns a pointer into the buffer or an error code if the
>>   * path was too long.
>
> I'd prefer the comment about it being ambiguous remain.  I'm waiting to see how
> long it takes for somebody to create a security hole by creating a file called
> '/etc/some/thing/important (deleted)' and having some software Do The Wrong
> Thing instead to /etc/some/thing/important.
>

In order to close this kind of hole why not creating a deleted
directory on /proc and redirect symbolic link to this directory.
And do the same for unreachable. If we use the good permission it will
work from a backaward compatibily point of view

bastien
