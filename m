Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab2HHOl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:41:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758134Ab2HHOl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:41:57 -0400
Message-ID: <50227AB0.6010301@suse.cz>
Date: Wed, 08 Aug 2012 16:41:52 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: David Cullen <David.Cullen@koe-americas.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] ARM Fix /usr/bin/xargs: etags: Argument list too
 long
References: <50227893.7070600@koe-americas.com>
In-Reply-To: <50227893.7070600@koe-americas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 8.8.2012 16:32, David Cullen napsal(a):
> Patch applies to
> 
>     commit 42a579a0f960081cd16fc945036e4780c3ad3202
> 
> When running "make ARCH=arm TAGS" in a chroot using qemu-arm-static,
> the following message is emitted:
> 
>     [user@host:/home/work/linux]: make ARCH=arm TAGS
>       GEN     TAGS
>     /usr/bin/xargs: etags: Argument list too long
> 
> This can be fixed by by passing "-L 1024" to xargs in scripts/tags.sh.
> 
> The "1024" was a guess. A value of "3862" changes the message to
> 
>     /usr/bin/xargs: argument list too long
> 
> Using "2048" also fixes the problem. However, I don't know how much
> headroom that leaves
> 
> Does anyone know why the argument lists must be shorter for ARM? All
> of the documentation I have available says that 4096 should be the
> limit.

This looks like a bug in xargs, it should make sure that the commandline
fits into ARG_MAX. BTW, a better workaround would be to use the -s
option, which limits the size of the argument list.

Michal
