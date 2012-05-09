Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab2EIHM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:12:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64156 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab2EIHM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:12:57 -0400
Message-ID: <4FAA18F1.6080508@redhat.com>
Date: Wed, 09 May 2012 09:12:49 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Joseph Cihula <joseph.cihula@intel.com>,
        Shane Wang <shane.wang@intel.com>, hpa@linux.intel.com
Subject: Re: [PATCH 04/23] x86, realmode: Move reboot_32.S to unified realmode
 code
References: <1336501366-28617-1-git-send-email-jarkko.sakkinen@intel.com> <1336501366-28617-5-git-send-email-jarkko.sakkinen@intel.com>
In-Reply-To: <1336501366-28617-5-git-send-email-jarkko.sakkinen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/05/2012 20:22, Jarkko Sakkinen ha scritto:
> +	xorl	%ecx, %ecx
> +	movl	%cr0, %edx
> +	andl	$0x00000011, %edx
> +	orl	$0x60000000, %edx
> +	movl	%edx, %cr0
> +	movl	%ecx, %cr3
> +	movl	%cr0, %edx
> +	andl	$0x60000000, %edx	/* If no cache bits -> no wbinvd */

Shouldn't this be a testl?

> +	jz	2f
> +	wbinvd
> +2:
> +	andb	$0x10, %dl

... because otherwise this is really a mov $0, %edx and it sounds wrong.
 It doesn't really matter, nobody really uses bit 4 of CR0 anymore,
still would be nice to fix it.

> +	movl	%edx, %cr0

Paolo
