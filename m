Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1BDRTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:19:21 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:46622 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1BDRTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:19:20 -0500
Subject: Re: [RFC][PATCH 2/6] pagewalk: only split huge pages when necessary
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <alpine.DEB.2.00.1102031343530.1307@chino.kir.corp.google.com>
References: <20110201003357.D6F0BE0D@kernel>
	 <20110201003359.8DDFF665@kernel>
	 <alpine.DEB.2.00.1102031257490.948@chino.kir.corp.google.com>
	 <1296768812.8299.1644.camel@nimitz>
	 <alpine.DEB.2.00.1102031343530.1307@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 04 Feb 2011 09:19:12 -0800
Message-ID: <1296839952.6737.2316.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 13:46 -0800, David Rientjes wrote:
> > Probably, but we don't currently have any central documentation for it.
> > Guess we could make some, or just ensure that all the users got updated.
> > Any ideas where to put it other than the mm_walk struct?
> 
> I think noting it where struct mm_walk is declared would be best (just a 
> "/* must handle pmd_trans_huge() */" would be sufficient) although 
> eventually it might be cleaner to add a ->pmd_huge_entry(). 

For code maintenance, I really like _not_ hiding this in the API
somewhere.  This way, we have a great, self-explanatory tag wherever
code (possibly) hasn't properly dealt with THPs.  We get a nice,
greppable, cscope'able:

	split_huge_page_pmd()

wherever we need to "teach" the code about THP.

It's kinda like the BKL. :)

-- Dave

