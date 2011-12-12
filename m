Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1LLQnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 11:43:03 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:63220 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1LLQnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 11:43:00 -0500
MIME-Version: 1.0
In-Reply-To: <1323704494.1765.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
	<20111212150255.GA7506@kroah.com>
	<CAEnQRZBiVDAHH+uZ=Ugk=UP5qSvvMViGTM-bRWr+E27zivOUug@mail.gmail.com>
	<1323703934.1765.15.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CAEnQRZCZdPw9eWVmdvhtF7KCQkYpLMrkhv5qd5xYckxWksN+0w@mail.gmail.com>
	<1323704494.1765.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Mon, 12 Dec 2011 18:42:59 +0200
X-Google-Sender-Auth: 73i49780ew_hhqOHDydPkUZ9P5k
Message-ID: <CAEnQRZAt0X6cxGLgLUVTB9rzLKVYLEnh=azS9WOyKAkUZEpj4g@mail.gmail.com>
Subject: Re: [PATCH] kref: add function for reading kref value
From: Daniel Baluta <dbaluta@ixiacom.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, adobriyan@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 5:41 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le lundi 12 décembre 2011 à 17:39 +0200, Daniel Baluta a écrit :
>
>> Ok, for the moment it seems to be a bad idea. But my intention is
>> to integrate kref to networking code, and then to write a general
>> debugging tool for refs.
>>
>> Tracking down reference count problems is hard, and this tool can
>> really help everyone.
>
> I dont think kref will help you that much, because its used everywhere.
>
> Adding a general debugging tool will provide too much noise.
>
> Instead, we (network dev) add debugging points where we want.

Yes, but you have to do this each time you start debugging, for a
particular referenced counted object.

We must find a clever solution to avoid the noise. (e.g use
/proc, /sysfs, /debugfs options to trigger dumping info for
some/all objects with a certain state).

Usecase:

At some point we need to know all objects with refcount X,
and their history of get/put operations.

For us it would have been very useful when debugging dev
refcnts problems. With the current implementation kernel
only dumped info at dev.c:5429:

printk(KERN_EMERG "unregister_netdevice: "
       waiting for %s to become free. Usage "
       count = %d\n",
       dev->name, atomic_read(&dev->refcnt));

Daniel.
