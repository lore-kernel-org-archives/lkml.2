Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab2HAWUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 18:20:07 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:57241 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2HAWTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 18:19:38 -0400
X-Auth-Info: w9C+Pbs0gEN6ugirvSTE/GJok+sTQWE1QlkczZKAVZc=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: fix personality handling in ppc64_personality()
References: <alpine.LNX.2.00.1208012201520.14910@pobox.suse.cz>
X-Yow: ..  are the STEWED PRUNES still in the HAIR DRYER?
Date: Thu, 02 Aug 2012 00:19:27 +0200
In-Reply-To: <alpine.LNX.2.00.1208012201520.14910@pobox.suse.cz> (Jiri
	Kosina's message of "Wed, 1 Aug 2012 22:03:42 +0200 (CEST)")
Message-ID: <m27gtitfv4.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

>  	if (personality(current->personality) == PER_LINUX32
> -	    && personality == PER_LINUX)
> -		personality = PER_LINUX32;
> +	    && personality(personality) == PER_LINUX)
> +		personality &= ~PER_LINUX | PER_LINUX32;

That doesn't work.  ~PER_LINUX is -1, so this is a no-op.

>  	ret = sys_personality(personality);
> -	if (ret == PER_LINUX32)
> -		ret = PER_LINUX;
> +	if (personality(ret) == PER_LINUX32)
> +		ret &= ~PER_LINUX32 | PER_LINUX;

That only "works" because PER_LINUX is 0.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
