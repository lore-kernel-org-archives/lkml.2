Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab0LHG4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 01:56:40 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:48943 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396Ab0LHG4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 01:56:34 -0500
X-ASG-Debug-ID: 1291791392-085394c90001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CFF2C1A.1010100@fusionio.com>
Date: Wed, 8 Dec 2010 14:56:26 +0800
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [RFC]block: change sort order of elv_dispatch_sort
References: <1291786922.12777.152.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [RFC]block: change sort order of elv_dispatch_sort
In-Reply-To: <1291786922.12777.152.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1291791392
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.48803
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-08 13:42, Shaohua Li wrote:
> Change the sort order a little bit. Makes requests with sector above boundary
> in ascendant order, and requests with sector below boundary in descendant
> order. The goal is we have less disk spindle move.
> For example, boundary is 7, we add sector 8, 1, 9, 2, 3, 4, 10, 12, 5, 11, 6
> In the original sort, the sorted list is:
> 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6
> the spindle move is 8->12->1->6, total movement is 12*2 sectors
> with the new sort, the list is:
> 8, 9, 10, 11, 12, 6, 5, 4, 3, 2, 1
> the spindle move is 8->12->6->1, total movement is 12*1.5 sectors

It was actually done this way on purpose, it's been a while since we
have done two way elevators even outside the dispatch list sorting
itself.

Do you have any results to back this change up? I'd argue that
continuing to the end, sweeping back, and reading forwards again will be
faster then doing backwards reads usually.

-- 
Jens Axboe

