Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab0KRRP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:15:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54015 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab0KRRP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:15:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Yx+WRtrliGkGc5tiNR541rNPynNg0XURhYskjxRgOeuAewrIl6QJAwVov2eB4P+hNH
         ftBrHFDWRbJ8doMN/JUZCo9PnOUydFWFkmmE1Qnd2ck1yx6nJfGL7DAmEoNqZCpBi+tL
         2uA0iyrNpywHOnhtrYkbEU7HAqlUkzi6GMPGk=
Subject: Re: [PATCH] checkpatch: teach checkpatch about rcu
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Patrick Pannuto <ppannuto@codeaurora.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101118170515.GA14005@redhat.com>
References: <20101118170515.GA14005@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 18:15:47 +0100
Message-ID: <1290100547.2781.206.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 18 novembre 2010 à 19:05 +0200, Michael S. Tsirkin a écrit :
> I got this:
> +       struct kvm_kernel_irq_routing_entry __rcu *irq_entry;
> which is because checkpatch does not know about __rcu.
> So here's a patch to teach it about that tag.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  scripts/checkpatch.pl |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 2039acd..1b11c8e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -143,6 +143,7 @@ our $Sparse	= qr{
>  			__must_check|
>  			__init_refok|
>  			__kprobes|
> +			__rcu|
>  			__ref
>  		}x;
>  


Hmm, why __percpu is in $Attribute, and __rcu in $Sparse ?



