Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab0HYJNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:13:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58078 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab0HYJNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pL5YaRqaS5xizahTndDY3ynHigzCKTeBS10YF5zX2cozuvV/FRV+O6zPvH1SgLG1KV
         kks3OH+5k9uim0vats4zbMGYuojBmxKSIOPCmx2EF4RAJDNql6+LLA0Rq8Nv6XJyfIK+
         jhiln7eHTQrM/zvwiM1fycyC0K8/Tiuj0hf00=
MIME-Version: 1.0
In-Reply-To: <20100825120413.7d5c5994@notabene>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100820083057.GA10039@infradead.org>
	<20100820195303.20b17210@notabene>
	<20100820115135.GQ31363@ZenIV.linux.org.uk>
	<20100821100900.4b15fe08@notabene>
	<17761610-AFA9-4BB5-AF62-CD54D67F5C79@oracle.com>
	<20100823090604.6c735c80@notabene>
	<AANLkTi=vYJDT_6YrfugE1N-k0Sj+abQBw7vQeG1GPhUP@mail.gmail.com>
	<20100825120413.7d5c5994@notabene>
Date: Wed, 25 Aug 2010 11:13:07 +0200
Message-ID: <AANLkTimiW0_+qsVQo2gb2hi_=tGsvuYkiG38dLMqYr3+@mail.gmail.com>
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: Andreas Dilger <andreas.dilger@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "adilger@sun.com" <adilger@sun.com>, "corbet@lwn.net" <corbet@lwn.net>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>,
        "hooanon05@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "sfrench@us.ibm.com" <sfrench@us.ibm.com>,
        "philippe.deniel@CEA.FR" <philippe.deniel@cea.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 4:04 AM, Neil Brown <neilb@suse.de> wrote:
> On Tue, 24 Aug 2010 11:41:10 +0200
>>
>> Why ot creating a special file system for this kind of operation ?
>> I mean a vfsmnt filesystem, with each directory on the root is a
>> symlink to the root of the real vfsmnt root ?
>>
>> I could be even be in proc space like /proc/self/vfsmnt
>>
>> path_to_handle will return a relative path from this directory like
>> 0x75843558/somehandle (if X is on /usr/bin/X and usr is mounted by
>> filesystem 0x75843558)
>> path_to_fshandle() will return 0x75843558
>>
>> opening file handle will be just a matter to thus open
>> /proc/self/vfsmount/0x75843558/somehandle
>>
>> Permission will be determined by vfsmount filesystem.
>>
>> No need to create new syscall all te handle to filename will be handle
>> by the vfsmount filesystem
>>
>> We could even use at existing command. The dirfd will need to be only
>> /proc/self/vfsmnt (and if you need to get a fd without mounting /proc
>> create a syscall to get this fd).
>>
>> Does sound plausible ?
>>
>
> I don't think so.
>
> I'm not 100% certain what you are proposing, but I think the basic idea is a
> virtual filesystem where giving a textual filehandle as a name gives access
> to the file with that filehandle.

Exactly

> This could only work by creating a virtual symlink from the name to the
> object in whichever filesystem - somewhat like /proc/self/fd/*.
> This could be used to open the file, not to create a hard-link or read a
> symlink which are two of the issues we are struggling with.

This issue could be raised by the open O_NODE patch
(http://lwn.net/Articles/364735/).
For symlink it will allow to read the symlink.

For hard link some bsd have fsdb that allow this kind of stuff. in our
case the security implication are huge, We could undelete a removed
file. In fact you need a flink(fd, "new path"). I could be useful in
some context note but seriously restricted.

Bastien
