Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab2DDRtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:49:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52864 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab2DDRts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:49:48 -0400
MIME-Version: 1.0
In-Reply-To: <4F7C7FCE.3090105@gmail.com>
References: <20120401125741.GA7484@p183.telecom.by> <CAHGf_=pgpRrQA3-YVtS=h-Bjq2LyTFmYtKGxxWgwP0XWexnh2g@mail.gmail.com>
 <4F7A3CC2.1040200@zytor.com> <CAOPLpQebqKED5G1nti6i=JLZ+A6df2UdA86RVEv1Er7hw7KFpQ@mail.gmail.com>
 <4F7C7907.3090808@gmail.com> <CAOPLpQfowVbAfY5utOa4pYDkA+AtLGU0zMLC5Eq5oH=zVrVC6Q@mail.gmail.com>
 <4F7C7FCE.3090105@gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 4 Apr 2012 13:49:26 -0400
Message-ID: <CAOPLpQdZc9m5ZpGgJtPBEvJUqeaqRneUkQx5NgXiXhvtXctDrg@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 13:07, KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:
> Umm... I'm sorry. I haven't catch why OOM is related topic. Could you please
> elaborate more?

With fork you always have some copy-on-write (and worse for
overcommit) just to then execute exec.  With a real spawn
implementation you wouldn't have that.  A big problem if you, for
instance, have to spawn a small helper from a gigantic process.
