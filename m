Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1LLRms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:42:48 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35666 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203Ab1LLRmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:42:45 -0500
Message-ID: <1323711754.2583.14.camel@edumazet-laptop>
Subject: Re: [PATCH] kref: add function for reading kref value
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, adobriyan@gmail.com
Date: Mon, 12 Dec 2011 18:42:34 +0100
In-Reply-To: <CAEnQRZAt0X6cxGLgLUVTB9rzLKVYLEnh=azS9WOyKAkUZEpj4g@mail.gmail.com>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
	 <20111212150255.GA7506@kroah.com>
	 <CAEnQRZBiVDAHH+uZ=Ugk=UP5qSvvMViGTM-bRWr+E27zivOUug@mail.gmail.com>
	 <1323703934.1765.15.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CAEnQRZCZdPw9eWVmdvhtF7KCQkYpLMrkhv5qd5xYckxWksN+0w@mail.gmail.com>
	 <1323704494.1765.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CAEnQRZAt0X6cxGLgLUVTB9rzLKVYLEnh=azS9WOyKAkUZEpj4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 décembre 2011 à 18:42 +0200, Daniel Baluta a écrit :

> Yes, but you have to do this each time you start debugging, for a
> particular referenced counted object.
> 

What a big deal.

> We must find a clever solution to avoid the noise. (e.g use
> /proc, /sysfs, /debugfs options to trigger dumping info for
> some/all objects with a certain state).
> 
> Usecase:
> 
> At some point we need to know all objects with refcount X,
> and their history of get/put operations.
> 
> For us it would have been very useful when debugging dev
> refcnts problems. With the current implementation kernel
> only dumped info at dev.c:5429:
> 

current on your git repo maybe, not on ours :(

> printk(KERN_EMERG "unregister_netdevice: "
>        waiting for %s to become free. Usage "
>        count = %d\n",
>        dev->name, atomic_read(&dev->refcnt));
> 

This is a very good example where you _cannot_ use kref, since we now
use a percpu refcnt fot netdevice.



