Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0GTOAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:00:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:58622 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab0GTOAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:00:14 -0400
Message-ID: <4C45ABFD.8060308@suse.cz>
Date: Tue, 20 Jul 2010 16:00:29 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBHw7Nybnk=?= <gentoo@mgorny.alt.pl>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] KERNEL BUILD: Make the setlocalversion script POSIX-compliant.
References: <20100718102640.01729af9@pomiocik.lan>
In-Reply-To: <20100718102640.01729af9@pomiocik.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.7.2010 10:26, Michał Górny wrote:
> The 'source' builtin is a bash alias to the '.' (dot) builtin. While the
> former is supported only by bash, the latter is specified in POSIX and
> works fine with all POSIX-compliant shells I am aware of.
> 
> The '$_' special parameter is specific to bash. It is partially
> supported in dash too but it always evaluates to the current script path
> (which causes the script to enter a loop recursively re-executing
> itself). This is why I have replaced the two occurences of '$_' with the
> explicit parameter.
> 
> The 'local' builtin is another example of bash-specific code. Although
> it is supported by all POSIX-compliant shells I am aware of, it is not
> part of POSIX specification and thus the code should not rely on it
> assigning a specific value to the local variable. Moreover, the 'posh'
> shell has a limited version of 'local' builtin not supporting direct
> variable assignments. Thus, I have broken one of the 'local'
> declarations down into a (non-POSIX) 'local' declaration and a plain
> (POSIX-compliant) variable assignment.
> 
> Signed-off-by: Michał Górny <gentoo@mgorny.alt.pl>

Thanks a lot, applied to the kbuild tree.


> ---
> 
> There is one 'bashism' left which I wasn't able to fix -- the use of
> 'test -ef'. I'm not aware of any POSIX equivalent of that.

Me neither, POSIX does not know stat(1) AFAICS. Does it matter in real
life? Is there a distro that installs posh or a similarly strict shell
as /bin/sh? It seems to work with dash after your changes.

Michal
