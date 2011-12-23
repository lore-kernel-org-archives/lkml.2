Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab1LWRET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:04:19 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53164 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1LWREQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:04:16 -0500
MIME-Version: 1.0
In-Reply-To: <20212.37458.896503.997111@quad.stoffel.home>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
 <CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
 <CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
 <20211.28256.111279.27933@quad.stoffel.home> <CAOh0hwPeveaEaNv_mjNVLM36JSbObX4n5y1jC_Yp5MwdBA0Sxw@mail.gmail.com>
 <20212.37458.896503.997111@quad.stoffel.home>
From: Gaurav Saxena <grvsaxena419@gmail.com>
Date: Fri, 23 Dec 2011 22:33:45 +0530
Message-ID: <CAOh0hwOO3iMmP5kKUvN6cexHU0dUPra1qD-_UCP_4_qSVx7Euw@mail.gmail.com>
Subject: Re: Intercepting system calls
To: John Stoffel <john@stoffel.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all , thanks for your reply.

On Fri, Dec 23, 2011 at 8:08 PM, John Stoffel <john@stoffel.org> wrote:
>>>>>> "Gaurav" == Gaurav Saxena <grvsaxena419@gmail.com> writes:
>
> Gaurav> Hello John,
> Gaurav> On Thu, Dec 22, 2011 at 11:22 PM, John Stoffel <john@stoffel.org> wrote:
>>>>>>>> "Gaurav" == Gaurav Saxena <grvsaxena419@gmail.com> writes:
>>>
>>>>> Intercepting system calls is very bad, don't do it.
>>>
> Gaurav> Oh. I will not do it then, could you suggest me something so
> Gaurav> that I could prevent unlink on some file say using kernel
> Gaurav> support. I want to save file on unlink how could I do that
> Gaurav> without kernel support, or how could I do that using a kernel
> Gaurav> module.
>>>
>>> Write a FUSE module to mount the filesystem through, inside your FUSE
>>> module you can intercept the unlink/truncate/write calls and decide
>>> what you want to have happen.
>
> Gaurav> I would like to write it differently for each type of filesystem ?
> Gaurav> Because what operations to call after my function depends on this.
> Gaurav> Also Can I mount "/" in this way ?
>
> Sounds like you really want to use inotify() then, but intercepting
> calls to write/truncate/unlink isn't going to be easy to handle across
> a large spectrum of filesystems without a bunch of hacking.
>
> Maybe if you can explain your requirements more clearly, with an
> example of what you're trying to accomplish, then people could help
> you more.
>
> Also, it might be more appropriate to talk to the 'fs-devel' mailing
> list.  I think it's on kernel.org, but not sure.
>
> John
>

I am trying to write an application which would create a backup for
the system so that it could be restored as it is. For example I create
a backup using my application. I just do nothing at time of backup so
it would be fast. Now whenever I see any deletion I would save that
file so that I could restore it. Also I would like to see for
modification/rename. I cannot do this using inotify as I would be
notified after actual deletion/write. I don't want to use SELinux
because I want to implement this on existing installed system. I was
earlier thinking of replacing system calls for open/unlink with my
custom calls which will call my functions before actual work and then
I would decide what to do I would also want to reject unlink request
for some of the files. But as I now know that its not working in
linux>3.0 . I had also seen dazuko which is not supporting linux>3.0
yet. Also there used to be a redirfs which used to work earlier but
the latest kernel is not supported yet. So I asked this question so
that I could get some solution/method of doing this.
I will try finding fs-devel list.
Thanks to you all for your help.


-- 
Thanks and Regards ,
Gaurav
