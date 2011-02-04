Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1BDV2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:28:33 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:43191 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1BDV2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:28:32 -0500
Subject: Re: [RFC][PATCH 1/6] count transparent hugepage splits
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>
In-Reply-To: <20110204211825.GJ30909@random.random>
References: <20110201003357.D6F0BE0D@kernel>
	 <20110201003358.98826457@kernel>
	 <alpine.DEB.2.00.1102031235100.453@chino.kir.corp.google.com>
	 <20110204211825.GJ30909@random.random>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 04 Feb 2011 13:28:25 -0800
Message-ID: <1296854905.6737.2631.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 22:18 +0100, Andrea Arcangeli wrote:
> On Thu, Feb 03, 2011 at 01:22:14PM -0800, David Rientjes wrote:
> > i.e. no global locking, but we've accepted the occassional off-by-one 
> > error (even though splitting of hugepages isn't by any means lightning 
> > fast and the overhead of atomic ops would be negligible).
> 
> Agreed losing an increment is not a problem, but in very large systems
> it will become a bottleneck. It's not super urgent, but I think it
> needs to become a per-cpu counter sooner than later (not needed
> immediately but I would appreciate an incremental patch soon to
> address that). 

Seems like something that would be fairly trivial with the existing
count_vm_event() infrastructure.  Any reason not to use that?  I'll be
happy to tack a patch on to my series.

-- Dave

