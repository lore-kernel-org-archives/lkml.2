Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab2DQKNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:13:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:45660 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2DQKNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:13:08 -0400
Message-ID: <1334657569.28150.81.camel@twins>
Subject: Re: A quick view of the performance benchmark for semaphore-like
 and mutex
From: Peter Zijlstra <peterz@infradead.org>
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Tue, 17 Apr 2012 12:12:49 +0200
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE043B15DCF@SCYBEXDAG03.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE043B15DCF@SCYBEXDAG03.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 09:36 +0000, Chen, Dennis (SRDC SW) wrote:
> 
> Interesting!! Semaphore-like is almost 8s slower than mutex... Also, the Events sycles of perf
> reported is different 

I suspect that if you were to use actual semaphores it would be even
worse, the semaphore implementation doesn't do lock-stealing nor does it
have fancy assembly fast paths.

In fact, I don't know why you even bother with sems, they're a
deprecated serialization primitive that really shouldn't be used
anymore.
