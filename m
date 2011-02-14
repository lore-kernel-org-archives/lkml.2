Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1BNOXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:23:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab1BNOXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:23:32 -0500
Message-ID: <4D593AD8.7070901@redhat.com>
Date: Mon, 14 Feb 2011 15:23:20 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH][RFC] dm: Do not open log and cow device read-write for
 read-only mappings
References: <4D573BBB.6090200@redhat.com> <1297594735-5593-1-git-send-email-tm@tao.ma> <4D57E67E.1030707@redhat.com> <4D57F357.6060708@tao.ma> <4D580A8B.5050508@redhat.com> <20110214103026.GA18742@htj.dyndns.org> <4D591664.6090203@redhat.com> <4D592AD1.6020500@redhat.com> <20110214140940.GM18742@htj.dyndns.org>
In-Reply-To: <20110214140940.GM18742@htj.dyndns.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 03:09 PM, Tejun Heo wrote:
> On Mon, Feb 14, 2011 at 02:14:57PM +0100, Milan Broz wrote:
>>> But it doesn't fix the read-only snapshot issue and I guess there will be
>>> the same problem with read-only MD code too.
>>> (so the 2) issue here https://lkml.org/lkml/2011/2/12/209).
> 
> So, the problem is caused by dm opening members rw even for ro
> devices, right?

The patch uncover these shortcomings in code.
(Unfortunately quite late in RC...)

>> I am not sure if this is complete fix... note that:
>> - what happens during mirror resync and read-only log?
>> - for COW, it there situation we need to update header in read-oly mode? (invalidated snap?)
> 
> But if the underlying device is marked ro, dm shouldn't update it at
> all.  The device should be opened ro and ro policy should be enforced.

Sure. So we need to check these situations I described.


Btw the same pattern is in MD code in lock_rdev() ...

Milan

