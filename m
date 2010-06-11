Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017Ab0FKBNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 21:13:42 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55449 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262Ab0FKBNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 21:13:41 -0400
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page
 cache control
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100610142512.GB5191@balbir.in.ibm.com>
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
	 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
	 <4C10B3AF.7020908@redhat.com>  <20100610142512.GB5191@balbir.in.ibm.com>
Content-Type: text/plain
Date: Thu, 10 Jun 2010 17:07:32 -0700
Message-Id: <1276214852.6437.1427.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 19:55 +0530, Balbir Singh wrote:
> > I'm not sure victimizing unmapped cache pages is a good idea.
> > Shouldn't page selection use the LRU for recency information instead
> > of the cost of guest reclaim?  Dropping a frequently used unmapped
> > cache page can be more expensive than dropping an unused text page
> > that was loaded as part of some executable's initialization and
> > forgotten.
> 
> We victimize the unmapped cache only if it is unused (in LRU order).
> We don't force the issue too much. We also have free slab cache to go
> after.

Just to be clear, let's say we have a mapped page (say of /sbin/init)
that's been unreferenced since _just_ after the system booted.  We also
have an unmapped page cache page of a file often used at runtime, say
one from /etc/resolv.conf or /etc/passwd.

Which page will be preferred for eviction with this patch set?

-- Dave

