Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0INLTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 07:19:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33490 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0INLTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 07:19:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C8F59EA.6020606@s5r6.in-berlin.de>
Date: Tue, 14 Sep 2010 13:18:02 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Bug 18252] spinlock lockup in __make_request <- submit_bio <-
  ondemand_readahead
References: <bug-18252-4803@https.bugzilla.kernel.org/>	<4C8B50F1.4020502@s5r6.in-berlin.de> <20100913144139.b9e18133.akpm@linux-foundation.org> <4C8F1CAB.7020004@s5r6.in-berlin.de> <4C8F1D16.3040109@kernel.dk>
In-Reply-To: <4C8F1D16.3040109@kernel.dk>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On 2010-09-14 08:56, Stefan Richter wrote:
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=18252
>> Florian Mickler wrote:
>>> There was an scsi-related use-after-free OOPS fixed recently and pulled 3 days
>>> ago.  
...
>>> Maybe you are seeing that?
>>>
>>> (reacting to the general-protection-fault preceded by scsi_init in the
>>> attachment jpg)
>> Now that you point it out --- perhaps.  Though I haven't looked into the
>> mechanics of the now fixed scsi_ini_io use after free.
> 
> It seems the very likely explanation, since I can't see any other way that
> you would deadlock on the queue lock from that call trace if you haven't
> had someone else crash with the lock held already.

Good, I close the bugzilla item right away with the reasonable assuption that
it is fixed by commit 3a5c19c23db65a554f2e4f5df5f307c668277056.
-- 
Stefan Richter
-=====-==-=- =--= -===-
http://arcgraph.de/sr/
