Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2JLUzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:55:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64628 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2JLUzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:55:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "'Namjae Jeon'" <linkinjeon@gmail.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
Date: Fri, 12 Oct 2012 20:55:02 +0000
Message-ID: <1715214.vxmSNGCbxl@wuerfel>
User-Agent: KMail/4.9 beta2 (Linux/3.5.0-7-generic; KDE/4.8.90; x86_64; ; )
In-Reply-To: <20121010045351.GE17429@thunk.org>
References: <1349553966.12699.132.camel@kjgkr> <alpine.LFD.2.00.1210091250590.11244@dhcp-1-104.brq.redhat.com> <20121010045351.GE17429@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:BJldioW73o8+8Y8v3VkS8E5bauZUEJB+yEGUaSd855K
 vahvWvlIPy6OC+CPWjYekT+AhMir3QhNuYlErHoorlHy682QaO
 JyJVH8PmxPyHctAAcg6S768zY8395kVu+sYjVCcru6xJox7Cbu
 Yql5ed3ZJbbABxvWDckHt+S87jretAecuOoSXF2g9E9o82HaWZ
 pUKWKmJnl6jaaONGbBp7pDamVVJLr96DVOt7N6rbqoiouvpvMy
 I9IoE81RJQFH9P9CCKdES+LiJh4jmTsBibiXREtMArM2GmmSiv
 vjuiDiOPzn/PipZ/bU/Vgb52W+tGJ0ahBsKOm8Hapg8q0QOehx
 Yrcsu7QsUL7LS4LdAyjw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2012 00:53:51 Theodore Ts'o wrote:
> On Tue, Oct 09, 2012 at 01:01:24PM +0200, Lukáš Czerner wrote:
> > Do not get me wrong, I do not think it is worth to wait for vendors
> > to come to their senses, but it is worth constantly reminding that
> > we *need* this kind of information and those heuristics are not
> > feasible in the long run anyway.
> 
> A number of us has been telling flash vendors exactly this.  The
> technical people do seem to understand.  It's management who seem to
> be primarily clueless, even though this information can be extracted
> by employing timing attacks on the media.  I've pointed this out
> before, and the technical people agree that trying to keep this
> information as a "trade secret" is pointless, stupid, and
> counterproductive.  Trying to get the pointy-haired bosses to
> understand may take quite a while.

For eMMC, I think we should start out defaulting to the characteristics
that are reported by the device, because they are usually correct
and those vendors for which that is not true can hopefully
come to their senses when they see how f2fs performs by default.

For USB media, the protocol does not allow you to specify the
erase block size, so we have to guess.

For SD cards, there is a field in the card's registers, but I've
never seen any value in there other than 4 MB, and in most cases
where that is not true, the standard does not allow encoding
the correct amount: it only allows power-of-two numbers up to
4 MB, and typical numbers these days are 3 MB, 6 MB or 8 MB.

	Arnd
