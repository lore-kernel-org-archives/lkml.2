Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0KXLNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:13:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab0KXLNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:13:48 -0500
Message-ID: <4CECF30D.5050204@redhat.com>
Date: Wed, 24 Nov 2010 13:12:13 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Chinner <david@fromorbit.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] IO-less dirty throttling v2
References: <20101117042720.033773013@intel.com>	<20101117150330.139251f9.akpm@linux-foundation.org>	<20101118020640.GS22876@dastard> <20101117180912.38541ca4.akpm@linux-foundation.org>
In-Reply-To: <20101117180912.38541ca4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 04:09 AM, Andrew Morton wrote:
> But mainly because we're taking the work accounting away from the user
> who caused it and crediting it to the kernel thread instead, and that's
> an actively *bad* thing to do.
>

That's happening more and more with workqueues and kernel threads.

We need the ability for a kernel thread (perhaps a workqueue thread) to 
say "I am doing this on behalf of thread X, please charge any costs I 
incur (faults, cpu time, whatever) to that thread".

-- 
error compiling committee.c: too many arguments to function

