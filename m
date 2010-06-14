Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0FNPdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:33:33 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59290 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0FNPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:33:32 -0400
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page
 cache control
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: balbir@linux.vnet.ibm.com, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4C162846.7030303@redhat.com>
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
	 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
	 <4C10B3AF.7020908@redhat.com> <20100610142512.GB5191@balbir.in.ibm.com>
	 <1276214852.6437.1427.camel@nimitz>
	 <20100611045600.GE5191@balbir.in.ibm.com> <4C15E3C8.20407@redhat.com>
	 <20100614084810.GT5191@balbir.in.ibm.com> <4C16233C.1040108@redhat.com>
	 <20100614125010.GU5191@balbir.in.ibm.com>  <4C162846.7030303@redhat.com>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 08:33:16 -0700
Message-Id: <1276529596.6437.7216.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 16:01 +0300, Avi Kivity wrote:
> If we drop unmapped pagecache pages, we need to be sure they can be 
> backed by the host, and that depends on the amount of sharing.

You also have to set up the host up properly, and continue to maintain
it in a way that finds and eliminates duplicates.

I saw some benchmarks where KSM was doing great, finding lots of
duplicate pages.  Then, the host filled up, and guests started
reclaiming.  As memory pressure got worse, so did KSM's ability to find
duplicates.

At the same time, I see what you're trying to do with this.  It really
can be an alternative to ballooning if we do it right, since ballooning
would probably evict similar pages.  Although it would only work in idle
guests, what about a knob that the host can turn to just get the guest
to start running reclaim?

-- Dave

