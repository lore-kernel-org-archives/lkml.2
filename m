Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0LXUpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 15:45:15 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:35023 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab0LXUpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 15:45:13 -0500
X-Auth-Info: RTBUjTpThAdwvSrbPM/Mi8uM7oTyYwkcxdh7Gqh6F9k=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [PATCH][RFC] HPFS: Don't use pointer to out-of-scope array
References: <alpine.LNX.2.00.1012242020090.28973@swampdragon.chaosbits.net>
X-Yow: But was he mature enough last night at the lesbian masquerade?
Date: Fri, 24 Dec 2010 21:45:09 +0100
In-Reply-To: <alpine.LNX.2.00.1012242020090.28973@swampdragon.chaosbits.net>
	(Jesper Juhl's message of "Fri, 24 Dec 2010 20:32:33 +0100 (CET)")
Message-ID: <m2mxnuew8a.fsf@whitebox.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl <jj@chaosbits.net> writes:

> Secondly I fail to see how this code inside the while loop can even work:
>
>   if (hpfs_ea_read(s, a, ano, pos + 4, ea->namelen + 1 + (ea->indirect ? 8 : 0), ex + 4))
>
> There is nothing initializing 'ex' which 'ea' points to, so 
> 'ea->namelen' and 'ea->indirect' are uninitialized.

The preceding hpfs_ea_read should do it (it reads the first 4 bytes of
ex which aliases ea->namelen and ea->indirect).

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
