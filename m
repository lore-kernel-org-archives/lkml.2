Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1E1HzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 03:55:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099Ab1E1HzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 03:55:11 -0400
Date: Sat, 28 May 2011 00:56:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-Id: <20110528005640.9076c0b1.akpm@linux-foundation.org>
In-Reply-To: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011 18:01:28 +0530 Ankita Garg <ankita@in.ibm.com> wrote:

> This patchset proposes a generic memory regions infrastructure that can be
> used to tag boundaries of memory blocks which belongs to a specific memory
> power management domain and further enable exploitation of platform memory
> power management capabilities.

A couple of quick thoughts...

I'm seeing no estimate of how much energy we might save when this work
is completed.  But saving energy is the entire point of the entire
patchset!  So please spend some time thinking about that and update and
maintain the [patch 0/n] description so others can get some idea of the
benefit we might get from all of this.  That estimate should include an
estimate of what proportion of machines are likely to have hardware
which can use this feature and in what timeframe.

IOW, if it saves one microwatt on 0.001% of machines, not interested ;)


Also, all this code appears to be enabled on all machines?  So machines
which don't have the requisite hardware still carry any additional
overhead which is added here.  I can see that ifdeffing a feature like
this would be ghastly but please also have a think about the
implications of this and add that discussion also.  

If possible, it would be good to think up some microbenchmarks which
probe the worst-case performance impact and describe those and present
the results.  So others can gain an understanding of the runtime costs.


