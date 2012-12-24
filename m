Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2LXScY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 13:32:24 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54066 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2LXScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 13:32:20 -0500
MIME-Version: 1.0
In-Reply-To: <20121224173937.GB14754@kroah.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-13-git-send-email-sasha.levin@oracle.com>
 <20121221075909.GA15739@amit.redhat.com> <201212241155.46866.arnd@arndb.de> <20121224173937.GB14754@kroah.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 24 Dec 2012 13:24:52 -0500
Message-ID: <CA+1xoqdd3DN6ApCnQh=8fQBvFh40O2BJPf4mAA_L17cRH8kShQ@mail.gmail.com>
Subject: Re: [PATCH] virtio_console: correct error message on failure of debugfs_create_dir
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Amit Shah <amit.shah@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 12:39 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Dec 24, 2012 at 11:55:46AM +0000, Arnd Bergmann wrote:
>> On Friday 21 December 2012, Amit Shah wrote:
>> > On (Thu) 20 Dec 2012 [14:11:21], Sasha Levin wrote:
>> > > debugfs_create_dir() returns NULL if it fails, there's little point in
>> > > calling PTR_ERR on it.
>> >
>> > debugfs_create_dir() does return an error value if debugfs is not
>> > enabled.
>> >
>> > This check for !pdrvdata.debugfs_dir should infact use
>> > IS_ERR_OR_NULL().  Care to submit a patch for that?
>>
>> How about we fix the stub instead to return NULL when debugfs is disabled?
>
> No, please read debugfs.h for why I decided to not do this (i.e. we try
> to learn from our mistakes...)

Why won't we fix it the other way around and return an actual error
code instead of a NULL on failure?


Thanks,
Sasha
