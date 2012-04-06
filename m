Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab2DFP1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 11:27:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51771 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757371Ab2DFP1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 11:27:40 -0400
X-Sasl-enc: trkOMaKaRRHEKcJF53E4hDHZgq99KgqheFtYIhfASmZ0 1333726059
Message-ID: <1333726029.4077.42.camel@lenny>
Subject: Re: [PATCH] nextfd(2)
From: Colin Walters <walters@verbum.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Fri, 06 Apr 2012 11:27:09 -0400
In-Reply-To: <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
References: <20120401125741.GA7484@p183.telecom.by>
	 <4F78D0BA.9040709@zytor.com>
	 <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-06 at 12:54 +0300, Alexey Dobriyan wrote:

> But I find it little hypocritical that kernel developers add CONFIG_PROC_FS,
> fix compilation problems associated with it, do not mount proc by default,
> do not mark it unmountable somehow and
> then say procless setups aren't worth it.
> 
> I haven't seen personally procless environments
> but several people mentioned them including on this very list.

Now that the kernel has CLONE_NEWNS, it's possible to mount proc
"privately" just for a specific process tree.  It meshes nicely with
CLONE_NEWPID.  Previously if you mounted proc in a chroot, it cluttered
the mount list and leaked information about outside the root.
With modern clone/unshare, that's no longer a concern, so there's
much less reason to use "bare" chroots.


