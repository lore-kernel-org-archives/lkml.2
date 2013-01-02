Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3ABSmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:42:22 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:45059 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3ABSmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:42:18 -0500
MIME-Version: 1.0
In-Reply-To: <20130102183351.GA28554@kroah.com>
References: <1357134877-27141-1-git-send-email-dreisner@archlinux.org>
	<20130102183351.GA28554@kroah.com>
Date: Wed, 2 Jan 2013 10:42:17 -0800
X-Google-Sender-Auth: 597mO0WejcPzjhzV5ppTK3xYYWU
Message-ID: <CAGXu5jJ1oGh-ExwQ6f0CMNQjF2cAcLrgWRCz8ho0v4Ve+GjOuw@mail.gmail.com>
Subject: Re: [PATCH] debugfs: convert gid= argument from decimal, not octal
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Reisner <dreisner@archlinux.org>, LKML <linux-kernel@vger.kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 10:33 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jan 02, 2013 at 08:54:37AM -0500, Dave Reisner wrote:
>> This patch technically breaks userspace, but I suspect that anyone who
>> actually used this flag would have encountered this brokenness, declared
>> it lunacy, and already sent a patch.
>
> Kees is the one that originally did this change (I think, right?)

I recommended the default change, but I think it was Vasiliy that
added the gid option, IIRC.

> Kees, any objection to this patch?  Will it break your existing systems?

Regardless, I have no objection -- this should be int, not octal.

-Kees

>
> thanks,
>
> greg k-h
>
>>
>> Signed-off-by: Dave Reisner <dreisner@archlinux.org>
>> ---
>>  fs/debugfs/inode.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
>> index 153bb1e..a5f12b7 100644
>> --- a/fs/debugfs/inode.c
>> +++ b/fs/debugfs/inode.c
>> @@ -176,7 +176,7 @@ static int debugfs_parse_options(char *data, struct debugfs_mount_opts *opts)
>>                       opts->uid = uid;
>>                       break;
>>               case Opt_gid:
>> -                     if (match_octal(&args[0], &option))
>> +                     if (match_int(&args[0], &option))
>>                               return -EINVAL;
>>                       gid = make_kgid(current_user_ns(), option);
>>                       if (!gid_valid(gid))
>> --
>> 1.8.0.3



--
Kees Cook
Chrome OS Security
