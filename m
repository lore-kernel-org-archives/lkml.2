Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0G0FKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 01:10:23 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:45536 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab0G0FKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 01:10:20 -0400
Date: Tue, 27 Jul 2010 07:13:47 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] padata/pcrypt: cleanups
Message-ID: <20100727051347.GI11081@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jul 2010 05:10:11.0776 (UTC) FILETIME=[FD6BE400:01CB2D49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the following changes:

1. padata - Rename padata_alloc functions to not export underlined functions.

2. padata - Rearrange set_cpumask functions to have proper locking for all
these functions and to avoid to export underlined functions.

3. padata - Pass the padata cpumasks to the cpumask_change_notifier chain, so
users can access them without the need of a padata_get_cpumask function.

4. pcrypt - Rename the stuct pcrypt_instance. An instance refers usually to a
crypto instance in the crypto-layer, the struct pcrypt_instance is not related
to a crypto instance, so we rename it.

5. pcrypt - Update pcrypt cpumask acording to the padata cpumask notifier.
The padata cpumask change notifier passes a padata_cpumask to the
notifier chain, so we use this to update the pcrypt cpumask.

6. padata - Remove padata_get_cpumask. This function is a bit error prone
because the cpumask can change at any time, so we can't be sure to get the
right cpumask from that function.

7. padata - Update the API documentation.

Steffen

