Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab1FOINZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:13:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44017 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab1FOINW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gHmkjVeExEiVPWBFZvULBo0/ifzfB8B5WpqsFh1iKWhFgYOHhI5M/BGCPdYP9EXRbk
         nKJQFMMrE98BNax9bftGC3t1icj3L8AdYGIXl6YYuY0JHPPR0ZDNj0p9krCdiYcysrdB
         1bukRWxAQPzJRq6ae/OmNTFzBHT/66JWpN2WA=
Date: Wed, 15 Jun 2011 10:13:17 +0200
From: Tejun Heo <tj@kernel.org>
To: Maxin B John <maxin.john@gmail.com>
Cc: akpm@linux-foundation.org, segooon@gmail.com, jkosina@suse.cz,
        tglx@linutronix.de, eike-kernel@sf-tec.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] devres: Fix possible use after free
Message-ID: <20110615081317.GL8141@htj.dyndns.org>
References: <20110614070732.GA3355@maxin>
 <20110614071540.GE8141@htj.dyndns.org>
 <BANLkTimHjVX6ymALT-ZBeSs1S+PRDRwQaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimHjVX6ymALT-ZBeSs1S+PRDRwQaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Maxin.

On Tue, Jun 14, 2011 at 03:09:34PM +0100, Maxin B John wrote:
> You are right. I shouldn't have mentioned it as dangerous. I was trying to
> make this patch description similar to the description present in the
> previous patch:
> http://www.spinics.net/lists/mm-commits/msg84313.html
> 
> This patch silences the Coverity Prevent's complains about this as
> use-after-free bug. Please let me know if the updated patch description is OK.
> 
> "
> A freed pointer is passed as an argument to the function "devres_destroy()" in
> "kernel/irq/devres.c" and "lib/devres.c". This patch fixes the possible use
> after free.
> The change silences the static analysis tool (Coverity Prevent) complains
> about this as use-after-free bug.
> "

Yeap, sounds mostly okay but there's no 'possible use after free'.
Maybe something like, "devres uses the pointer value as key after it's
freed, which is safe but triggers spurious use-after-free warnings on
some static analysis tools.  Rearrange code to avoid such warnings".

Thanks.

-- 
tejun
