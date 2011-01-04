Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751116Ab1ADWTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 17:19:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50154 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1ADWTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 17:19:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FW7hvHKKVjfGBgU9aEr1hx2n+yYVR2kwQN9uQcoF5IuZd3DL9UbBJVtHJBo4R5GdWg
         T9xmuHykTTofSqf/z0+XR4y5AD8cQ6Lg9LYQB2wjYPn7U/5wjVQnEDbYN39as2VoQATn
         6UigrdI4NW/sCn5dXKpTHTABfbe3HJTkx0GP0=
Subject: Re: [PATCH 2/2] lib: cpu_rmap: CPU affinity reverse-mapping
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
        Tom Herbert <therbert@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-net-drivers@solarflare.com
In-Reply-To: <1294178690.3636.49.camel@bwh-desktop>
References: <1294169842.3636.31.camel@bwh-desktop>
	 <1294169967.3636.34.camel@bwh-desktop>
	 <1294175823.3420.7.camel@edumazet-laptop>
	 <1294176216.3636.38.camel@bwh-desktop>
	 <1294177548.3420.11.camel@edumazet-laptop>
	 <1294178690.3636.49.camel@bwh-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 23:19:02 +0100
Message-ID: <1294179542.3420.13.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 04 janvier 2011 à 22:04 +0000, Ben Hutchings a écrit :

> get_rps_cpu() will need to read from an arbitrary entry in cpu_rmap (not
> the current CPU's entry) for each new flow and for each flow that went
> idle for a while.  That's not fast path but it is part of the data path,
> not the control path.
> 

Hmm, I call this fast path :(

> > Cache lines dont matter. I was not concerned about speed but memory
> > needs.
> > 
> > NR_CPUS can be 4096 on some distros, that means a 32Kbyte allocation.
> > 
> > Really, you'll have to have very strong arguments to introduce an
> > [NR_CPUS] array in the kernel today.
> 
> I could replace this with a pointer to an array of size
> num_possible_cpus().  But I think per_cpu is wrong here.

Yes, an dynamic array is acceptable

You probably mean nr_cpu_ids 




