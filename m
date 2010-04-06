Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab0DFV2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:28:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:55391 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab0DFV14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=voWnZ3mF9mI8dRkrsoSfT9bq7nwF4nw15Rl6Vg5R6sPjS4bmKUSH6POzf/if2NP8nz
         bDmgYNGdpbBnUkSJWr5M9XcHH0biMCtIeZ8of3ui42mXW0Dz4yr7FR7KELO96/QaH58i
         058JTHsOjhVJuP8l42QR9PGqFw2jLBzEzev/Q=
MIME-Version: 1.0
In-Reply-To: <20100303213329.GA500@alarsen.net>
References: <20100303213329.GA500@alarsen.net>
Date: Tue, 6 Apr 2010 23:27:55 +0200
Message-ID: <w2ocd73a99e1004061427t322f8d4cmecd708ad16580f00@mail.gmail.com>
Subject: Re: [PATCH 1/2] AT91 slow-clock suspend: don't wait when turning PLLs 
	off
From: Andrew Victor <avictor.za@gmail.com>
To: Anders Larsen <al@alarsen.net>
Cc: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Julien Langer <julien.langer@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Anders,

> From: Julien Langer <julien.langer@gmail.com>
>
> AT91: when turning off the PLLs during suspend, don't wait for the lock flag
> to be set. Previously the code would always run into the loop limitation
> of 1000 iterations because the flag is never set when turning the PLLs off.
>
> Signed-off-by: Julien Langer <julien.langer@gmail.com>
> Signed-off-by: Anders Larsen <al@alarsen.net>
> Cc: Andrew Victor <avictor.za@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>

During suspend we set the MULA and MULB bits to 0 to disable the
PLL's.  When disabled, the PLLs will never "lock".

   Acked-by: Andrew Victor <linux@maxim.org.za>


Russell:  This is patch 5975/1 in the patch-system.
