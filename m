Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab0CaRVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 13:21:55 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:52242 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab0CaRVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 13:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=AfvCsTnDBQuMJDgNMMVMhnQ0wqKaSCnx908KuzYiXkd+dB1eWr0a5yrOCYR7oOuLn6
         vU3CyNxagjqSGeBC10u1M7cfZmU3Onl2kAZE/vOiB32ipY9Qa06JczOR53kT4afEfgZi
         DHQgvXSK02clMQczxFwNdffOIpBcO33FJfYGI=
MIME-Version: 1.0
In-Reply-To: <201003311654.38020.arnd@arndb.de>
References: <1270044578-4291-1-git-send-email-abogani@texware.it>
	 <201003311654.38020.arnd@arndb.de>
Date: Wed, 31 Mar 2010 19:21:47 +0200
X-Google-Sender-Auth: a6b3dbc2482bed99
Message-ID: <63a49ef41003311021x4f73609bj7b4275f67914b3db@mail.gmail.com>
Subject: Re: [PATCH] USB: Remove BKL from remount() function in usbfs
From: Alessio Igor Bogani <abogani@texware.it>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mr Bergmann,

2010/3/31 Arnd Bergmann <arnd@arndb.de>:
[...]
>> The function update_sb(), invoked by remount(), seems already well serialized
>> with &root->d_inode->i_mutex. Moreover don't seems there are others
>> super_operations functions in USB core for usbfs that should access to
>> super_block in a way which require BKL.
>
> There is a patch from Jan Blunck pending in the bkl-removal tree that pushes
> down the BKL into usbfs_fill_super. Can you confirm that this BKL usage does
> not interfere with the one you just removed, and that it can go the same way?

I can confirm that this certainly interfere: So please ignore my patch.

I'll elaborate a new patch when Blunck's works is merged.

Thanks!

Ciao,
Alessio
