Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab0DUFHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:07:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:48996 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0DUFH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:07:28 -0400
Date: Tue, 20 Apr 2010 22:08:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Salman Qazi <sqazi@google.com>
Cc: svaidy@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-pm@lists.linux-foundation.org, csadler@google.com,
       ranjitm@google.com, kenchen@google.com, dawnchen@google.com
Subject: Re: [PATCH 0/3] [idled]: Idle Cycle Injector for power capping
Message-ID: <20100420220855.4619256b@infradead.org>
In-Reply-To: <k2y4352991a1004201052lbef1fd73g714d527e872162fd@mail.gmail.com>
References: <20100413234902.29004.41655.stgit@bumblebee1.mtv.corp.google.com>
	<1271317886.32749.69.camel@laptop>
	<h2u4352991a1004191020q8200399oc8e9f7d8dee934bf@mail.gmail.com>
	<1271703701.1676.235.camel@laptop>
	<20100420045038.GB2915@dirshya.in.ibm.com>
	<k2y4352991a1004201052lbef1fd73g714d527e872162fd@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 10:52:58 -0700
Salman Qazi <sqazi@google.com> wrote:

> For improving power savings in the non-SMT case, as Arjan suggested, I
> will make the changes for heuristically aligning the injection on
> multiple cores.  This will not be perfect, but then because it's a
> power optimization, it doesn't have to always work.  I presume that
> this works best when done according to the CPU hierarchy?  That is, it
> is more beneficial to idle an entire socket than the same number of
> cores on different sockets?

not really; at least not for Intel CPUs.
The problem is that due to the cache coherency, as long as one cpu in
the system is awake, the memory controllers etc cannot go into a sleep
mode...

I would not be surprised if AMD has the same behavior... or anyone else
with an integrated memory controller for that matter.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
