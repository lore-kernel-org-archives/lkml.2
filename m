Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0ITLNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 07:13:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64558 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab0ITLNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 07:13:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] BKL: Remove BKL from isofs
Date: Mon, 20 Sep 2010 13:13:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <201009161632.59210.arnd@arndb.de> <201009172100.06598.arnd@arndb.de> <20100920105811.GC3390@quack.suse.cz>
In-Reply-To: <20100920105811.GC3390@quack.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009201313.11526.arnd@arndb.de>
X-Provags-ID: V02:K0:dlBIRXWsEoQboA+vznq/PdDbUhDn9/ROMhGaFqzTtaT
 bklV2TeKet0A4qn/bQHCHNWE8JMnLXbmOw//Zzxk6pMC7kfAT3
 MGsmmn919M2pq9FkzN2TtfxYmx9ywtKUBn9rvZuXb5dXzr9IHu
 cBbhlcNoXXa3ESgLQkZIofL0ezZR4p+JTCwvoYEoh6EjnU+uWX
 IX7CON/YZEpFSPcXVr7Fg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 September 2010, Jan Kara wrote:
>   Hmm, looking through the code, I actually don't see a reason
> why we should need any per-sb lock at all. The filesystem is always
> read-only and we don't seem to have any global data structures that
> change. But that needs some testing I guess - I'll try to do that.

Ok, great! The BKL was basically as wrong as the global mutex protecting
the operations anyway, because it does not document what data is
actually getting protected in any of all the drivers that I'm converting
to a private mutex.

Given more time for code inspection and some testing, you can probably
come up with a good explanation why the BKL is not needed in all those
places, but since nobody ever bothered to do this for the last decade
for all these drivers, my approach was to simply prove (in a rather lose
sense) that I can't make it worse by converting to a mutex.

	Arnd
