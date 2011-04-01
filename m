Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab1DAQKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:10:41 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51984 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab1DAQKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=BBPHYU6VN+s3udgCzOfZFbQCaTZrhu9G9IPr6FONL0yGhY+/e9AMtF///ujE16WI5z
         RVFhG2YtNF9Ev1VX0Z0gDsBmvmIl56TEqZO80Ysoe0rVK83PqXHoDWiPQ/pqbcDF1tqi
         hPmsbme/xDdsxNuq6W8JNp0JKaEIfooZQlmqc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110402030628.36a0b822.sfr@canb.auug.org.au>
References: <AANLkTi=td3J2duwv9RuXJHquA6=wRRq8vWLkJY97xtP9@mail.gmail.com>
	<20110402030628.36a0b822.sfr@canb.auug.org.au>
Date: Fri, 1 Apr 2011 18:10:38 +0200
Message-ID: <AANLkTin6dXV1bvgzwGuKKq_o08Wnz6Ddm38vFP4us4fC@mail.gmail.com>
Subject: Re: linux-next: Tree for April 1 [BROKEN ubifs when CONFIG_DEBUG_SECTION_MISMATCH=y]
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 6:06 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Cc'ing Artem,
>
> On Fri, 1 Apr 2011 17:55:52 +0200 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>
>> With CONFIG_DEBUG_SECTION_MISMATCH=y set, I see in my build.log:
>> ...
>> MODPOST 2742 modules
>> ...
>> ERROR: "empty_aops" [fs/ubifs/ubifs.ko] undefined!
>> make[5]: *** [__modpost] Error 1
>> make[4]: *** [modules] Error 2
>> make[3]: *** [sub-make] Error 2
>> make[2]: *** [all] Error 2
>> make[2]: Leaving directory
>> `/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/build_i386_none_686-iniza'
>>
>> - Sedat -
>>
>
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

Speculative patch (untested).

- Sedat -

$ diff -uprN fs/ubifs/xattr.c.orig fs/ubifs/xattr.c
--- fs/ubifs/xattr.c.orig       2011-04-01 15:56:08.471082117 +0200
+++ fs/ubifs/xattr.c    2011-04-01 18:08:27.355276827 +0200
@@ -81,6 +81,7 @@ enum {

 static const struct inode_operations none_inode_operations;
 static const struct file_operations none_file_operations;
+static const struct address_space_operations empty_aops;

 /**
  * create_xattr - create an extended attribute.
