Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab2DWRTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:19:35 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58946 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2DWRTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:19:33 -0400
Message-ID: <4F958F13.1000005@linux.vnet.ibm.com>
Date: Mon, 23 Apr 2012 10:19:15 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: Richard Davies <richard@arachsys.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Chris Webb <chris@arachsys.com>, Badari <pbadari@us.ibm.com>
Subject: Re: Over-eager swapping
References: <20120423092730.GB20543@alpha.arachsys.com>
In-Reply-To: <20120423092730.GB20543@alpha.arachsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042317-4242-0000-0000-0000016DCF2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 02:27 AM, Richard Davies wrote:
> # cat /proc/meminfo
> MemTotal:       65915384 kB
> MemFree:          271104 kB
> Buffers:        36274368 kB

Your "Buffers" are the only thing that really stands out here.  We used
to see this kind of thing on ext3 a lot, but it's gotten much better
lately.  From slabinfo, you can see all the buffer_heads:

buffer_head       8175114 8360937    104   39    1 : tunables    0    0
   0 : slabdata 214383 214383      0

I _think_ this was a filesystems issue where the FS for some reason kept
the buffers locked down.  The swapping just comes later as so much of
RAM is eaten up by buffers.

