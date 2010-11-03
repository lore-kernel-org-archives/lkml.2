Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0KCW5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 18:57:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab0KCW5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 18:57:07 -0400
Message-ID: <4CD1E8C4.2020405@suse.cz>
Date: Wed, 03 Nov 2010 23:57:08 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild, deb-pkg: fix Architecture field when cross compiling
References: <1288654261-8269-1-git-send-email-asbjorn@asbjorn.biz>
In-Reply-To: <1288654261-8269-1-git-send-email-asbjorn@asbjorn.biz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.11.2010 00:31, Asbjoern Sloth Toennesen wrote:
> If the environment variable CROSS_COMPILE is set, override
> the Architecture control field, based on the value of the
> ARCH environment variable.
> 
> With this patch the following make command:
> 
> 	make CROSS_COMPILE='' ARCH=i386 deb-pkg
> 
> will output an i386 Debian package instead of an amd64 one,
> when run on amd64 machine.

I know very little about debian packaging, but shouldn't this be done in
all cases, regardless of CROSS_COMPILE being set or not? You even show
in the above example that in some cases you don't need CROSS_COMPILE to
build a kernel for a different architecture. make rpm-pkg seems to
suffer from the same problem, btw.

Michal
