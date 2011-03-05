Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab1CEKAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:00:37 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54662 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab1CEKAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=xRVEssf3fST08MIR2nuev+w32KLc8HZ/oCi+hN7SZjVCtWrMi0eZv0R62BjxJNGVdb
         rjvv6FqT7mFscXtvMRfS7hktGFP92k7kh++f5dGwibhPJpqFxmJlI495Mm9LkRM/B+ME
         3rGMkyI/kd4RKgehkhnr8n+46BbpzsSvtDlhQ=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D720469.1010101@gmail.com>
References: <4D6221B8.9040303@gmail.com>
	<4D6F5473.2070709@gmail.com>
	<4D720469.1010101@gmail.com>
Date: Sat, 5 Mar 2011 11:00:35 +0100
Message-ID: <AANLkTinyK0G=tfZob4u7XBj7Gna3FbZnLrqswz2oajwn@mail.gmail.com>
Subject: Re: [PATCH v3] Check for immutable/append flag in fallocate path
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/11, Marco Stornelli <marco.stornelli@gmail.com> wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
>
> In the fallocate path the kernel doesn't check for the immutable/append
> flag. It's possible to have a race condition in this scenario: an
> application open a file in read/write and it does something, meanwhile
> root set the immutable flag on the file, the application at that point
> can call fallocate with success. In addition, we don't allow to do any
> unreserve operation on an append only file but only the reserve one.
>
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> Patch is against 2.6.38-rc7
>
> ChangeLog:
> v3: Modified do_fallocate instead of every single fs
> v2: Added the check for append-only file for XFS
> v1: First draft
>
> --- open.c.orig	2011-03-01 22:55:12.000000000 +0100
> +++ open.c	2011-03-04 15:28:43.000000000 +0100

Shouldn't that be sth like...?

--- linux-2.6.38-rc7.orig/fs/open.c
+++ linux-2.6.38-rc7/fs/open.c

- Sedat -
