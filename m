Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab0HQKI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:08:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37575 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab0HQKIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=iuCPxEgLo7tPKVpKM1YxKaOTSJ6IaJgXmiV10P1ErkF/+1Xu9BHGq4sTh0FUmGSynP
         N7MFhvXc0EM3CVyOLQHdwLGjkY1c8Ewt7LdCLxOVmv+b8gFpT7RdJ8x9HctRVTyX7c5q
         rJJs5NImgxHw1aY90dxBxPhwkAAmYYbCV8k+Q=
MIME-Version: 1.0
In-Reply-To: <AANLkTimC=VDH=m9SoDK3BGzk7eCKRj6dEVzU230_kFPH@mail.gmail.com>
References: <AANLkTik2VDPSZvMzQ8rv38jBDKmRaM9-TL9nhqxj_VSQ@mail.gmail.com>
	<AANLkTimC=VDH=m9SoDK3BGzk7eCKRj6dEVzU230_kFPH@mail.gmail.com>
Date: Tue, 17 Aug 2010 14:08:51 +0400
Message-ID: <AANLkTikJzEM2BjZVBBbK9gt1dyvv0CK0==s3hxq4ywy4@mail.gmail.com>
Subject: Re: bug LINUX_VERSION_CODE undefined
From: Sergey Naumov <sknaumov@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some update.

It seems that build script (and makefiles) uses it's own VERSION variable.
In the last standalone makefile where
> make uImage
executes, I have tried to
> override VERSION :=
> export VERSION
and execute make as
> VERSION= make uImage
but the only thing that helps is to prepend "override" keyword to
VERSION initialization in the main linux Makefile:

override VERSION = 2

2010/8/17 Sergey Naumov <sknaumov@gmail.com>:
> Hello. This is my first message to this list so please be patient.
>
> I have encountered compilation error due to
> #define LINUX_VERSION_CODE
> in include/linux/version.h
>
> This happens because $(VERSION) variable in the main Makefile has a
> value of 2.6.35.2 instead of 2,
> so "expr" utility fails to generate LINUX_VERSION_CODE value with an
> error "non-numeric argument" or smth.
>
> I have found only one link (
> http://www.spinics.net/lists/linux-kbuild/msg03230.html ) to this
> issue in the Internet,
> but there is no response to it, so I decided to post this message.
>
> Please subscribe me personally to answers to this post.
>
> Sergey Naumov.
>
