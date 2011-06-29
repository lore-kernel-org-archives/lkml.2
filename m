Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1F2R7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:59:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50184 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab1F2R7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:59:37 -0400
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20110629174220.GA9152@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
	 <20110629130038.GA7909@in.ibm.com> <1309367184.11430.594.camel@nimitz>
	 <20110629174220.GA9152@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 10:59:02 -0700
Message-ID: <1309370342.11430.604.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 23:12 +0530, Ankita Garg wrote:
> 	4. The kernel must have a mechanism to maintain utilization
> 	   statistics pertaining to a piece of hardware, so that it can
> 	   trigger the hardware to power it off

Having statistics like this would certainly be nice, but how important
_is_ it?  Is it really a show-stopper?  There's some stuff today, like
the NPT/EPT support in KVM where we don't even have visibility in to
when a given page is referenced.

It's also going to be a pain to track kernel references.  On x86, our
kernel linear mapping uses 1GB pages when it can, and those are greater
than the 512MB granularity that we've been talking about here.  It's
even larger on powerpc.  I'm also pretty sure we don't even _look_ at
the referenced bits in the kernel page tables.  We'll definitely need
some infrastructure to do that.

> 	5. Being able to group these pieces of hardware for purpose of
> 	   higher savings. 

Do you really mean group, or do you mean "turn as many off as possible"?

-- Dave

