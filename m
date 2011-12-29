Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1L2Qkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:40:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab1L2Qkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:40:40 -0500
Message-ID: <4EFC9872.7000708@suse.cz>
Date: Thu, 29 Dec 2011 17:42:26 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kbuild: add target to install gzipped modules
References: <1325173819-26274-1-git-send-email-lucas.demarchi@profusion.mobi>
In-Reply-To: <1325173819-26274-1-git-send-email-lucas.demarchi@profusion.mobi>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 29.12.2011 16:50, Lucas De Marchi napsal(a):
> Add target in Makefile to compress the module after it's installed.
> Module-init-tools and libkmod can handle gzipped modules.

I am not convinced that this is a needed feature. Compressing elf files
means that depmod and modinfo need to read the whole compressed file
from disk and unpack it, while only a couple of bytes need to be read.
Those concerned about disk space either compile only the few needed
modules and/or use some compressed filesystem, which allows for random
access.


> This is not much useful for distributions because the package will gzip
> the modules and call depmod in a install rule. However for those
> compiling the kernel on their own and debugging module loading, it's
> useful so depmod doesn't have to be called twice and we don't have to
> manually compress the modules.

I understand that you need *.ko.gz support in kmod for the sake of
feature parity and that such patch would help you with debugging. But I
doubt there is use for it apart of developing kmod. Wouldn't an external
script like this do the same job for you?

#!/bin/sh
make "$@" modules_install
rel="$(make -s "$@" kernelrelease)"
find "/lib/modules/$rel" -name '*.ko' -exec gzip '{}' ';'
depmod "$rel"

Michal
