Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0KXRcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:32:14 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:58776 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab0KXRcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:32:13 -0500
Subject: Re: Sudden and massive page cache eviction
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Peter =?ISO-8859-1?Q?Sch=FCller?= <scode@spotify.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Mattias de Zalenski <zalenski@spotify.com>, linux-mm@kvack.org
In-Reply-To: <AANLkTi=mgTHPEYFsryDYnxPa78f-Nr+H7i4+0KPZbxh3@mail.gmail.com>
References: <AANLkTikg-sR97tkG=ST9kjZcHe6puYSvMGh-eA3cnH7X@mail.gmail.com>
	 <20101122161158.02699d10.akpm@linux-foundation.org>
	 <1290501502.2390.7029.camel@nimitz>
	 <AANLkTik2Fn-ynUap2fPcRxRdKA=5ZRYG0LJTmqf80y+q@mail.gmail.com>
	 <1290529171.2390.7994.camel@nimitz>
	 <AANLkTikCn-YvORocXSJ1Z+ovYNMhKF7TaX=BHWKwrQup@mail.gmail.com>
	 <AANLkTi=mgTHPEYFsryDYnxPa78f-Nr+H7i4+0KPZbxh3@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 24 Nov 2010 09:32:09 -0800
Message-ID: <1290619929.10586.6.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 15:14 +0100, Peter Schüller wrote:
> >> Do you have any large page (hugetlbfs) or other multi-order (> 1 page)
> >> allocations happening in the kernel?
> 
> I forgot to address the second part of this question: How would I best
> inspect whether the kernel is doing that? 

I found out yesterday how to do it with tracing, but it's not a horribly
simple thing to do in any case.  You can watch the entries in slabinfo
and see if any of the ones with sizes over 4096 bytes are getting used
often.  You can also watch /proc/buddyinfo and see how often columns
other than the first couple are moving around.

Jumbo ethernet frames would be the most common reason to see these
allocations.  It's _probably_ not an issue in your case.

-- Dave

