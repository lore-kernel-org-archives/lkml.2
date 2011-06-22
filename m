Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab1FVQqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 12:46:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38626 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab1FVQqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 12:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CVJTqVdEo4WjFN/QmrWZD55Fg2SQuNT4hF1LGwhMNFSE7+D98/A9Zwnf0vSR3nGcLS
         Hh6r9u2OQROOOAgntz+Iq3c8Vo0DSwiOs7IU7AiJ3JioupzoqlFzWdcxPaipWEPMqjA9
         fgdTVBwxC390dB7MZLzJit44X6K3nvkgpZ5+8=
Subject: Re: [PATCH] Fix CPU spinlock lockups on secondary CPU bringup
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
In-Reply-To: <20110622105550.GQ23234@n2100.arm.linux.org.uk>
References: <20110622105550.GQ23234@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 20:46:48 +0200
Message-ID: <1308768408.2268.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 22 juin 2011 à 11:55 +0100, Russell King - ARM Linux a
écrit :
> From: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Secondary CPU bringup typically calls calibrate_delay() during its
> initialization.  However, calibrate_delay() modifies a global variable
> (loops_per_jiffy) used for udelay() and __delay().
> 
> A side effect of 71c696b1 (calibrate: extract fall-back calculation
> into own helper) introduced in the 2.6.39 merge window means that we
> end up with a substantial period where loops_per_jiffy is zero.  This
> causes the spinlock debugging code to malfunction:
...

>  
> +	loops_per_jiffy = lpj;
>  	printed = true;
>  }

To be 100% safe, I would use

	ACCESS_ONCE(loops_per_jiffy) = lpj;

But I assume no current gcc would be that stupid ;)



