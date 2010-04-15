Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0DOQgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:36:15 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:23871 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab0DOQgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:36:13 -0400
Date: Thu, 15 Apr 2010 12:34:55 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Nick Piggin <npiggin@suse.de>, zach.brown@oracle.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in
 semtimedop
Message-ID: <20100415163455.GD3794@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Nick Piggin <npiggin@suse.de>, zach.brown@oracle.com,
	jens.axboe@oracle.com, linux-kernel@vger.kernel.org
References: <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
 <4BC4A6B2.1090906@colorfullife.com>
 <20100413173941.GI13327@think>
 <20100413180945.GD5683@laptop>
 <20100413181937.GM13327@think>
 <4BC5EA75.9090803@colorfullife.com>
 <20100414173319.GA3228@think>
 <4BC61370.7020700@colorfullife.com>
 <20100414195003.GE3228@think>
 <4BC73FC9.1090007@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC73FC9.1090007@colorfullife.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BC74077.009A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 06:33:13PM +0200, Manfred Spraul wrote:
> On 04/14/2010 09:50 PM, Chris Mason wrote:
> >On a big system I saw about 4000 semaphores total.  The database will
> >just allocate as many as it can into a single array and keep creating
> >arrays until it has all it needs.
> >
> What happens if SEMMSL is reduced (first entry in /proc/sys/kernel/sem)?

Performance improves slightly but the ipc lock is still at the top of the
profile ;)

-chris

