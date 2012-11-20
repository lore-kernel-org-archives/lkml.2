Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab2KTJ7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:59:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab2KTJ7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:59:04 -0500
Message-ID: <50AB5462.9030401@suse.cz>
Date: Tue, 20 Nov 2012 10:58:58 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, linux-kernel@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [PATCH] Coccicheck: Improvement for online checking with 'make
 C=[12]'
References: <1350031730-20822-1-git-send-email-nicolas.palix@imag.fr>
In-Reply-To: <1350031730-20822-1-git-send-email-nicolas.palix@imag.fr>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

sorry for the delay.

On 12.10.2012 10:48, Nicolas Palix wrote:
> +    # The ignore_unknown_options flag requires Coccinelle >= 0.2.3
> +    FLAGS="-ignore_unknown_options -very_quiet"
> +    if [ "$KBUILD_EXTMOD" = "" ] ; then
> +        OPTIONS="-dir $srctree $*"

Why is -Iinclude not needed in this case?


> +    else
> +        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree -I $srctree/include -I $KBUILD_EXTMOD/include $*"
> +    fi

The main Makefile exports the $LINUXINCLUDE variable, which contains all
the needed -I options. It would be cleaner to use that instead.

Michal
