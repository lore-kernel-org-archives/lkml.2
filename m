Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1E1NQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 09:16:18 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:42758 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab1E1NQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 09:16:16 -0400
Date: Sat, 28 May 2011 18:46:06 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-ID: <20110528131606.GA3416@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
 <20110528005640.9076c0b1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110528005640.9076c0b1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sat, May 28, 2011 at 12:56:40AM -0700, Andrew Morton wrote:
> On Fri, 27 May 2011 18:01:28 +0530 Ankita Garg <ankita@in.ibm.com> wrote:
> 
> > This patchset proposes a generic memory regions infrastructure that can be
> > used to tag boundaries of memory blocks which belongs to a specific memory
> > power management domain and further enable exploitation of platform memory
> > power management capabilities.
> 
> A couple of quick thoughts...
> 
> I'm seeing no estimate of how much energy we might save when this work
> is completed.  But saving energy is the entire point of the entire
> patchset!  So please spend some time thinking about that and update and
> maintain the [patch 0/n] description so others can get some idea of the
> benefit we might get from all of this.  That estimate should include an
> estimate of what proportion of machines are likely to have hardware
> which can use this feature and in what timeframe.
>

This patchset is definitely not for inclusion. The intention of this RFC
series is to convey the idea and demonstrate the intricacies of the VM
design. Partial Array Self-Refresh (PASR) is an upcoming technology that
is supported on some platforms today, but will be an important feature
in future platforms to conserve idle power consumed by memory subsystem.
Mobile devices that are predominantly in the standby state can exploit
PASR feature to partially turn off areas of memory that are free.

Unfortunately, at this point we are unable to provide an estimate of the
power savings, as the hardware platforms do not yet export information
about the underlying memory hardware topology. We are working on this
and hope to have some estimations in a month or two. However, will
evaluate the performance impact of the changes and share the same.

> IOW, if it saves one microwatt on 0.001% of machines, not interested ;)
> 
> 
> Also, all this code appears to be enabled on all machines?  So machines
> which don't have the requisite hardware still carry any additional
> overhead which is added here.  I can see that ifdeffing a feature like
> this would be ghastly but please also have a think about the
> implications of this and add that discussion also.  
> 
> If possible, it would be good to think up some microbenchmarks which
> probe the worst-case performance impact and describe those and present
> the results.  So others can gain an understanding of the runtime costs.
> 

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
