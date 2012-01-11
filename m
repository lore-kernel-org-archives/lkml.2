Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2AKLTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 06:19:45 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51283 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab2AKLTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 06:19:44 -0500
Message-ID: <1326280780.2767.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: RE: Extermeley large PageTables over 500G on kernel 2.6.32.49
 (SLES11 SP1)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Borzenkov, Andrey" <andrey.borzenkov@ts.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jan 2012 12:19:40 +0100
In-Reply-To: <CB1B361E45A85849902B25342E88900501CFDC311187@ABGEX70E.FSC.NET>
References: <CB1B361E45A85849902B25342E88900501CFDC3110D6@ABGEX70E.FSC.NET>
	 <1326278196.2767.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CB1B361E45A85849902B25342E88900501CFDC311187@ABGEX70E.FSC.NET>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 11 janvier 2012 à 11:52 +0100, Borzenkov, Andrey a écrit :

> Colleagues responsible for Oracle are reconfiguring it now.
> 

OK. Since your hardware supports 1GB hugepages, you might try to use
them as well. Not sure if your kernel is recent enough...

cat /proc/cmdline 
ro root=LABEL=/ hugepagesz=1GB hugepages=512 

> > If not, its normal to eat so much memory for page tables
> > 
> > grep VmPTE /proc/*/status
> > 
> > 
> 
> Forgive my ignorance. I thought that
> 
> 1. PTE is 8 bytes per page, which is 4K which gives 2K per 1M of memory
> 2. All processes sharing the same shared memory share the same page table

It depends how oracle maps its SGA.

It probably uses a method disallowing page table sharing.

Anyway, hugetables for this kind of workload is a must.



