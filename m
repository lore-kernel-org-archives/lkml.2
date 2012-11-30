Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030861Ab2K3Pjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:39:40 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61595 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030715Ab2K3Pjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:39:36 -0500
MIME-Version: 1.0
In-Reply-To: <20121130064710.1bcd227b@tlielax.poochiereds.net>
References: <cover.1354217746.git.joe@perches.com>
	<7176cb20d420849d72aa004e40a404049362da7f.1354217746.git.joe@perches.com>
	<20121130064710.1bcd227b@tlielax.poochiereds.net>
Date: Fri, 30 Nov 2012 09:39:35 -0600
Message-ID: <CAH2r5mtbhZWJu1eoahDSo84Wr=6jrSDVdwEVnQWYxztU72T2nQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: Remove unused cEVENT macro
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Joe Perches <joe@perches.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't mind removing cEVENT (it is currently unused, and presumably
the older file systems that used EVENT logging, have moved to dtrace
or other tracing mechanisms).

But ... the need still remains for more tracing for cifs (I run into
this a few times a month at least when debugging) - does anyone have
any ideas for how to add dynamic trace points to cifs (has anyone even
done it for the vfs?) - is there any file system that does a good job
defining dynamic trace points?

On Fri, Nov 30, 2012 at 5:47 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Thu, 29 Nov 2012 11:37:18 -0800
> Joe Perches <joe@perches.com> wrote:
>
>> It uses an undefined KERN_EVENT and is itself unused.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>>  fs/cifs/cifs_debug.h |    7 -------
>>  1 files changed, 0 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
>> index c0c68bb..b0fc344 100644
>> --- a/fs/cifs/cifs_debug.h
>> +++ b/fs/cifs/cifs_debug.h
>> @@ -63,12 +63,6 @@ do {                                               \
>>  /* debug event message: */
>>  extern int cifsERROR;
>>
>> -#define cEVENT(fmt, arg...)                                          \
>> -do {                                                                 \
>> -     if (cifsERROR)                                                  \
>> -             printk(KERN_EVENT "%s: " fmt "\n", __FILE__, ##arg);    \
>> -} while (0)
>> -
>>  /* error event message: e.g., i/o error */
>>  #define cifserror(fmt, arg...)                                       \
>>  do {                                                         \
>> @@ -88,7 +82,6 @@ do {                                                \
>>   */
>>  #else                /* _CIFS_DEBUG */
>>  #define cERROR(set, fmt, arg...)
>> -#define cEVENT(fmt, arg...)
>>  #define cFYI(set, fmt, arg...)
>>  #define cifserror(fmt, arg...)
>>  #endif               /* _CIFS_DEBUG */
>
> Yay! More cruft removal!
>
> Reviewed-by: Jeff Layton <jlayton@redhat.com>



-- 
Thanks,

Steve
