Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab2BIQmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 11:42:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36537 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab2BIQmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 11:42:06 -0500
Message-ID: <1328805722.6099.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] Reduce the number of expensive division instructions
 done by _parse_integer()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: adobriyan@gmail.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Thu, 09 Feb 2012 17:42:02 +0100
In-Reply-To: <1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20120209154819.32070.93358.stgit@warthog.procyon.org.uk>
	 <1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 09 février 2012 à 17:28 +0100, Eric Dumazet a écrit :

> You could avoid the divide and have cleaner code I think.
> 
> 	unsigned long long next = *res * base + val;
> 
> 	if (next < *res)
> 		overflow = 1;
> 	*res = next;
> 

Oh well, this one is better.

        unsigned long long next = *res * base;

        if (next < *res)
                overflow = 1;
        *res = next + val;




