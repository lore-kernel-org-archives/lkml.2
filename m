Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0GTGok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 02:44:40 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:36805 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab0GTGoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 02:44:38 -0400
Date: Tue, 20 Jul 2010 08:47:36 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] padata/pcrypt: fixes
Message-ID: <20100720064736.GB11081@secunet.com>
References: <20100714142951.22817d0c@leibniz>
 <20100719060426.GA19696@gondor.apana.org.au>
 <20100719064050.GA11081@secunet.com>
 <20100719073255.GA20403@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100719073255.GA20403@gondor.apana.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 Jul 2010 06:44:33.0922 (UTC) FILETIME=[036E8E20:01CB27D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the following fixes:

1. padata - Fix a potential hang of the parallel worker threads on
cpu hotplug.

2. padata - Fix two NULL pointer dereference crashes if one of the
padata cpumasks is empty. The crashes can be triggered by doing
echo 0 > /sys/kernel/pcrypt/pencrypt/[parallel_cpumask/serial_cpumask]

3. padata - Fix a division by zero crash if the parallel cpumask
contains no active cpu. Can be triggered by doing
echo 0 > /sys/kernel/pcrypt/pencrypt/parallel_cpumask

4. pcrypt - Fix division by zero crash if the callback cpumask
is empty. Can be triggered by doing
echo 0 > /sys/kernel/pcrypt/pencrypt/serial_cpumask

I ran a script that does cpumask changes and cpu hotplugs as fast as
possible while sending IPsec packets on maximal rate with pcrypt.
It showed no furter crashes overnight, so I hope I've got them all.

padata API corrections and some minor fixes/cleanups are comming later.

Steffen
