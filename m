Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2DDLvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 07:51:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45850 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab2DDLvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 07:51:38 -0400
MIME-Version: 1.0
In-Reply-To: <4F7A3CC2.1040200@zytor.com>
References: <20120401125741.GA7484@p183.telecom.by> <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com>
 <4F7A3CC2.1040200@zytor.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 4 Apr 2012 07:51:17 -0400
Message-ID: <CAOPLpQebqKED5G1nti6i=JLZ+A6df2UdA86RVEv1Er7hw7KFpQ@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 19:56, H. Peter Anvin <hpa@zytor.com> wrote:
>
> You can deal with this in one of two ways:
>
> 2. Fix your malloc().
> 1. Use the low level open()/getdents()/close() functions instead of
>   opendir()/readdir()/closedir().

And if their is concern about using opendir() then we can add
something to posix_spawn.  And attribute like POSIX_SPAWN_CLOSEALL and
you then would have to explicitly add dup and open requests for the
descriptors you want to have open.
