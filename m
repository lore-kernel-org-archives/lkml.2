Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab0FYUqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 16:46:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33225 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab0FYUql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 16:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=MKmb+rCJTRwoJ3ODuqU7ttJkSXca5u16PVXBeRzhJtjNzE8Wy2rdS+cX+HBddWT7mm
         /uyeiRnlqwtYgkH1n7hS5ySPtv3gL02AN3PVa7o3mR0jejSdb32oeiIBV1XoxkGKs+yq
         DHd8zgcdCYVSeXbgAnSMPQd8o5j5Hobv03uiU=
MIME-Version: 1.0
In-Reply-To: <AANLkTikH-jOOOzJ7xium-O3jwHpgh_czAFlkFkwnxpkK@mail.gmail.com>
References: <AANLkTila2rrYcBUZKwywHTP6g8rsj7Z1ck6LSoC9GaUY@mail.gmail.com>
	<AANLkTikbQLTC8HLB2m8LoPtZ0JVUzRl6PvRL5yTC0pZV@mail.gmail.com>
	<1277496077.6141.30.camel@heimdal.trondhjem.org>
	<AANLkTikH-jOOOzJ7xium-O3jwHpgh_czAFlkFkwnxpkK@mail.gmail.com>
Date: Fri, 25 Jun 2010 13:41:03 -0700
Message-ID: <AANLkTikJ8-nIwiNSqBxY8HP7zWmK4OM42nJo4G0myG5u@mail.gmail.com>
Subject: Fwd: Fwd: fs/exec.c core dumping on NFS mounted directory
From: Lei Sun <leisun124@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lei Sun <leisun124@gmail.com>
Date: Fri, Jun 25, 2010 at 1:39 PM
Subject: Re: Fwd: fs/exec.c core dumping on NFS mounted directory
To: Trond Myklebust <trond.myklebust@fys.uio.no>


On Fri, Jun 25, 2010 at 1:01 PM, Trond Myklebust
<trond.myklebust@fys.uio.no> wrote:
> On Fri, 2010-06-25 at 12:32 -0700, Lei Sun wrote:
>>   In 2.6.3x, I am logging in as a root and running app from NFS
>> mounted directory. The app crashed with 0 bytes core file (I have set
>> "ulimit -c unlimited", so it's not an issue).
>>
>> Proposed patch:
>>
>> --- exec.c 2010-05-19 17:33:16.000000000 -0700
>> +++ exec.c.new 2010-05-19 17:33:07.000000000 -0700
>> @@ -1859,7 +1859,7 @@
>>      * Dont allow local users get cute and trick others to coredump
>>      * into their pre-created files:
>>      */
>> - if (inode->i_uid != current_fsuid())
>> + if (inode->i_bytes != 0 && inode->i_uid != current_fsuid())
>>         goto close_fail;
>>
>>     if (!file->f_op)
>>
> ... which would go ahead and reintroduce bugzilla entry 3043, but only
> for those filesystems that set inode->i_bytes to zero:
>           https://bugzilla.kernel.org/show_bug.cgi?id=3043
>
> NACKed...
>
> Trond
>
>

If existing core file size is 0, it will be replaced, otherwise it
won't , is this a problem?  The 0 bytes core file is not useful
anyway.
