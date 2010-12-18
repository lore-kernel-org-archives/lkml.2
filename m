Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0LRA3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:29:47 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:39013 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab0LRA3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:29:46 -0500
Message-ID: <4D0C0043.7090408@oracle.com>
Date: Fri, 17 Dec 2010 16:28:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2010-12-16-14-56 uploaded (hugetlb)
References: <201012162329.oBGNTdPY006808@imap1.linux-foundation.org> <20101217143316.fa36be7d.randy.dunlap@oracle.com> <20101217145334.3d67d80b.akpm@linux-foundation.org> <20101217233740.GR1671@random.random>
In-Reply-To: <20101217233740.GR1671@random.random>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/10 15:37, Andrea Arcangeli wrote:
> Hello,
> 
> On Fri, Dec 17, 2010 at 02:53:34PM -0800, Andrew Morton wrote:
>> afacit, CONFIG_HUGETLBFS must be enabled if CONFIG_HUGETLB_PAGE=y, and
>> thp-config_transparent_hugepage.patch broke that, by permitting
>> CONFIG_HUGETLBFS=n, CONFIG_HUGETLB_PAGE=y,
>> CONFIG_TRANSPARENT_HUGEPAGE=y.
> 
> CONFIG_HUGETLBFS and CONFIG_HUGETLB_PAGE existed before, and
> HUGETLBFS=n && HUGETLB_PAGE=y used to build just fine, I clearly
> didn't try a build with HUGETLBFS=n recently.
> 
>> There's lots of stuff in hugetlb.h which is clearly related to
>> hugetlbfs, but is enabled by CONFIG_HUGETLB_PAGE, so those things seem
>> to be pretty joined at the hip nowadays.
> 
> Yes, it used to build just fine but I guess after the last hugetlbfs
> updates I'm getting flood of errors no matter how I adjust things.
> hugetlbfs code who needs some fixup here.

I see a real *flood* of errors when I try building ARCH=um SUBARCH={i386|x86_64}:

> grep -c error: UM*/build*
UM32/build-defcfg.out:454539
UM64/build-defcfg.out:453707


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
