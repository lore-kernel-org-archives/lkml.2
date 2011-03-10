Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1CJL4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 06:56:20 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52535 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab1CJL4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 06:56:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v5] kbuild: Add extra gcc checks
Date: Thu, 10 Mar 2011 12:56:06 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, bp@amd64.org
References: <20110301083529.GA767@liondog.tnic> <20110309175625.GA29181@merkur.ravnborg.org> <20110310090444.GA25522@elte.hu>
In-Reply-To: <20110310090444.GA25522@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101256.06745.arnd@arndb.de>
X-Provags-ID: V02:K0:EqxcsX4dcSFZVQzKtjgiCfwUm6B5qEszAgN7hZVKUYp
 FDHVWunBJCe9OeK+1O5yrdnQfzzcOmjhZdp9b9j0R9ZCxiBG0L
 9hZ/xT2FzOtLo/uV6hlNU8SG1wGKPa/u6CoylFNCz+B4YWjav6
 a/B1GbOmzk1aS3yf0BKCSgR8y8IT/LxnIGt4I+iEhw2aP0Nkgi
 wnhVTCff/EJglewhOEkiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 March 2011, Ingo Molnar wrote:
> Also, adding 3 lines per object file is pretty ugly - would it be possible to create 
> a nicer, compact, single-line way to someone condense a CONFIG_ERROR opt-out 
> mechanism, the -Werror default and the single-object-file into a single rule?
> 
> Something like:
> 
>   obj-werror-y += sched.o

I haven't tried it, but it could work (or be made to work) recursively,
so you can link multiple objects together and have them use the same flag e.g.

obj-y += obj_werror.o
ccflags-obj_werror.o += -Werror
obj-werror-y += sched.o module.o user.o

	Arnd
