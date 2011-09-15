Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1IORab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:30:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30994 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab1IORaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:30:30 -0400
MIME-Version: 1.0
Message-ID: <075c4e4c-a22d-47d1-ae98-31839df6e722@default>
Date: Thu, 15 Sep 2011 10:29:51 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, gregkh@suse.de, devel@driverdev.osuosl.org,
        cascardo@holoscopio.com, linux-kernel@vger.kernel.org,
        dave@linux.vnet.ibm.com, linux-mm@kvack.org, brking@linux.vnet.ibm.com,
        rcj@linux.vnet.ibm.com
Subject: RE: [PATCH v2 0/3] staging: zcache: xcfmalloc support
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20110909203447.GB19127@kroah.com> <4E6ACE5B.9040401@vflare.org>
 <4E6E18C6.8080900@linux.vnet.ibm.com> <4E6EB802.4070109@vflare.org>
 <4E6F7DA7.9000706@linux.vnet.ibm.com> <4E6FC8A1.8070902@vflare.org
 4E72284B.2040907@linux.vnet.ibm.com>
In-Reply-To: <4E72284B.2040907@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E72362B.0148:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
> 
> Hey Nitin,
> 
> So this is how I see things...
> 
> Right now xvmalloc is broken for zcache's application because
> of its huge fragmentation for half the valid allocation sizes
> (> PAGE_SIZE/2).

Um, I have to disagree here. It is broken for zcache for
SOME set of workloads/data, where the AVERAGE compression
is poor (> PAGE_SIZE/2).
 
> My xcfmalloc patches are _a_ solution that is ready now.  Sure,
> it doesn't so compaction yet, and it has some metadata overhead.
> So it's not "ideal" (if there is such I thing). But it does fix
> the brokenness of xvmalloc for zcache's application.

But at what cost?  As Dave Hansen pointed out, we still do
not have a comprehensive worst-case performance analysis for
xcfmalloc.  Without that (and without an analysis over a very
large set of workloads), it is difficult to characterize
one as "better" than the other.

> So I see two ways going forward:
> 
> 1) We review and integrate xcfmalloc now.  Then, when you are
> done with your allocator, we can run them side by side and see
> which is better by numbers.  If yours is better, you'll get no
> argument from me and we can replace xcfmalloc with yours.
> 
> 2) We can agree on a date (sooner rather than later) by which your
> allocator will be completed.  At that time we can compare them and
> integrate the best one by the numbers.
> 
> Which would you like to do?

Seth, I am still not clear why it is not possible to support
either allocation algorithm, selectable at runtime.  Or even
dynamically... use xvmalloc to store well-compressible pages
and xcfmalloc for poorly-compressible pages.  I understand
it might require some additional coding, perhaps even an
ugly hack or two, but it seems possible.

Dan
