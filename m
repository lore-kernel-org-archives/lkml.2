Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960Ab0KQXSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:18:08 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0KQXSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:18:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Yk3LQaevjiG9xImgT7JV8jxAh2/Sxyv4gR/Fw5i55BMiryh0031fImgvOdaesu5Mn9
         ddzN58hrSZQeNaMwX2bQ==
Date: Wed, 17 Nov 2010 15:17:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: shaohui.zheng@intel.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, lethal@linux-sh.org, ak@linux.intel.com,
        shaohui.zheng@linux.intel.com, Haicheng Li <haicheng.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Greg KH <greg@kroah.com>,
        Aaron Durbin <adurbin@google.com>
Subject: Re: [7/8,v3] NUMA Hotplug Emulator: extend memory probe interface
 to support NUMA
In-Reply-To: <1290034830.9173.4363.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1011171508570.24488@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.916235444@intel.com> <1290019807.9173.3789.camel@nimitz> <alpine.DEB.2.00.1011171312590.10254@chino.kir.corp.google.com> <1290030945.9173.4211.camel@nimitz> <alpine.DEB.2.00.1011171434320.22190@chino.kir.corp.google.com>
 <1290034830.9173.4363.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Dave Hansen wrote:

> It's not just the mem_map[], though.  When a section is sitting
> "offline", it's pretty much all ready to go, except that its pages
> aren't in the allocators.  But, all of the other mm structures have
> already been modified to make room for the pages.  Zones have been added
> or modified, pgdats resized, 'struct page's initialized.
> 

Ok, so let's create an interface that compliments the probe interface that 
takes a quantity of memory to be hot-added from the amount of hidden RAM 
only after we fake the nodes_add array for each section within that 
quantity by calling update_nodes_add() and then looping through for each 
section calling add_memory().
