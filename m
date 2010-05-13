Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab0EMSnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:43:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47251 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab0EMSnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L+XRzDPBcFpp1QwCDfCstwa5OtyXZdpDigD8NMZ0Squ0OQwCHjlxobdyn7qas+qxjb
         6E+gjN+jSbYy4r6mt3WEtos5YR0c1HK0JNdPzdNAp5QU1tq0TVX7PFVPKWdYKVA45HGp
         iSEy+5dFfMXz2wz3JEh8uP7xd//XEr+AS3QjY=
Subject: Re: preempt_disable and sleep()
From: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
To: ratheesh k <ratheesh.ksz@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <AANLkTinbwZK5Tp6aI4ja38XaiiB5aIyECzHPdMpvkaIy@mail.gmail.com>
References: <AANLkTinbwZK5Tp6aI4ja38XaiiB5aIyECzHPdMpvkaIy@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 11:43:21 -0700
Message-ID: <1273776201.11899.23.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 00:02 +0530, ratheesh k wrote:
> I am running RT linux .
> 
> /* code snippet */
> 
> preempt_disable()
> ...........
> sleep(10);
> '............
> preempt_enable()
> 
> 
> will this sleep() will cause reschedule ?.
> 

Why would you do this?

If you had tried this code, you would have seen the corresponding stack
dump on the console.

> if an interrupt comes  while premption is disabled , how it is handled ?.
> 

Depends on the number of (idle) cores, the setting of CONFIG_PREEMPT_[]
and the type of interrupt.

RT threaded IRQs would not run until preemption is enabled on a single
core system.



> Thanks,
> Ratheesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


