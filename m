Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab2CSTly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:41:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759297Ab2CSTlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:41:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <161084.1332177826@turing-police.cc.vt.edu>
References: <161084.1332177826@turing-police.cc.vt.edu> <1121.1332169437@redhat.com> <20120318235114.GA30497@thor.bakeyournoodle.com> <20120318184105.GC2095@windriver.com> <9942.1332170491@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com, Tony Breeds <tony@bakeyournoodle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: triage for March 18, 2012
Date: Mon, 19 Mar 2012 19:41:44 +0000
Message-ID: <8010.1332186104@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

> Umm.. it's not clear to *me* that it's intended to be a negative 16 bit?  Or
> am I just missing context not present in the patch?
> 
> (I have no idea if the rest of the patch is OK or not, but that comment
> didn't give me warm fuzzies....)

Sorry, I haven't explained it well.

The patch permits a 64-bit hosted assembler to represent a large 32-bit
unsigned integer (such as 0xfffffff1) as a negative integer where the
instruction being assembled has a signed immediate operand.

For instance, the ANDI instruction on FRV takes a small signed integer (10
bits IIRC) that it sign-extends to 32-bits before using - so to clear a single
low-order bit, I pass in, say, ~0x2 and the assembler represents this as a
negative value.

The problem was that in a 64-bit hosted assembler, the unsigned 32-bit integer
gets converted to an unsigned 64-bit integer - which doesn't then appear
negative (whereas in a 32-bit hosted assembler it does).

David
