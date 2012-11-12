Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2KLPUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 10:20:25 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58440 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab2KLPUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 10:20:20 -0500
MIME-Version: 1.0
In-Reply-To: <20121111235001.a3gqhaijmec0gk0g-cebfxv@webmail.spamcop.net>
References: <20121025101416.v1wilj95q8wkk0os-cebfxv@webmail.spamcop.net>
	<20121111235001.a3gqhaijmec0gk0g-cebfxv@webmail.spamcop.net>
Date: Mon, 12 Nov 2012 10:20:18 -0500
Message-ID: <CACLa4pu4FFwKdoA8ATfmviOj0e0mAQ3U2FNEiJHCv4RfDY4ZoQ@mail.gmail.com>
Subject: Re: Bisected regression: iterate_fd() selinux change affects flash plugin
From: Eric Paris <eparis@parisplace.org>
To: Pavel Roskin <proski@gnu.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        SE-Linux <selinux@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMG this +1 -1 stuff is nuts...

iterate_fd passes fd+1 instead of the fd for the file?  seriously?
ewwww.  I see how this patch fixes it, but still, wouldn't some magic
or negative value for no entries found be better than having to
understand the crazy logics?

/me pokes Al.

On Sun, Nov 11, 2012 at 11:50 PM, Pavel Roskin <proski@gnu.org> wrote:
> Quoting Pavel Roskin <proski@gnu.org>:
>
>> Hello, Al!
>>
>> I have noticed that Mozilla Firefox gets stuck for seconds or minutes
>> on some sites, in particular on Facebook with Linux 3.7-rc1 and newer
>> mainline kernels.  Disabling flash plugin fixes the delays.
>>
>> This is a Fedora 17 system with SELinux enabled, on x86_64
>> architecture, with all updates, with LXDE desktop.  It's not the Fedora
>> 16 system I mentioned before, it has never had LXDE login problems due
>> to replace_fd().
>>
>> Bisecting lead me to the patch that introduced iterate_fd():
>>
>> commit c3c073f808b22dfae15ef8412b6f7b998644139a
>> Author: Al Viro <viro@zeniv.linux.org.uk>
>> Date:   Tue Aug 21 22:32:06 2012 -0400
>>
>>     new helper: iterate_fd()
>>
>>     iterates through the opened files in given descriptor table,
>>     calling a supplied function; we stop once non-zero is returned.
>>     Callback gets struct file *, descriptor number and const void *
>>     argument passed to iterator.  It is called with files->file_lock
>>     held, so it is not allowed to block.
>>
>>     tty_io, netprio_cgroup and selinux flush_unauthorized_files()
>>     converted to its use.
>>
>>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>>
>> I have found that reverting the changes to security/selinux/hooks.c is
>> sufficient to restore the correct behavior.
>>
>> --
>> Regards,
>> Pavel Roskin
>
>
> I've made a bugzilla entry for the bug and put a preliminary patch there.
> https://bugzilla.kernel.org/show_bug.cgi?id=50401
>
>
> --
> Regards,
> Pavel Roskin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
