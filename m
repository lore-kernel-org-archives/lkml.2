Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0IOTOC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:14:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59411 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab0IOTN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:13:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: memory barrier question
Date: Wed, 15 Sep 2010 21:12:42 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Ovt6F-0005CS-RU@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201009152112.42925.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 15, 2010, Miklos Szeredi wrote:
> Hi,
> 
> I'm trying to understand memory barriers but not quite succeeding.
> 
> Consider the following example:
> 
> Start:
> 	p = NULL;
> 	x = 0;
> 
> CPU1:
> 	atomic_inc(&x);
> 	p = &x;
> 
> CPU2:
> 	if (p)
> 		z = atomic_read(p);
> 
> Is it possible to end up with z == 0?

Yes, it is.  CPU1 can reorder the two instructions in theory and if
the atomic_read() on CPU2 happens between them, it may return 0 in theory.

> What if there's a lock/unlock before setting "p"?  What if there's a write
> barrier before setting "p"?

A write barrier should help and locking functions are implicit memory barriers.

Thanks,
Rafael
