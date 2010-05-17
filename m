Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab0EQUCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:02:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46337 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab0EQUCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:02:10 -0400
To: Jiaying Zhang <jiayingz@google.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, hch@infradead.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org, mrubin@google.com
Subject: Re: [PATCH, RFC] addjust discard request to be aligned with hwsect  size to support SSDs with larger sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100513051953.532821BC316@ruihe.smo.corp.google.com>
	<yq1pr0u8igd.fsf@sermon.lab.mkp.net>
	<AANLkTikjfv2DHshXhxwPpyvpCvvGLiK-IOcucXJX3jBQ@mail.gmail.com>
Date: Mon, 17 May 2010 16:00:49 -0400
In-Reply-To: <AANLkTikjfv2DHshXhxwPpyvpCvvGLiK-IOcucXJX3jBQ@mail.gmail.com>
	(Jiaying Zhang's message of "Mon, 17 May 2010 12:44:24 -0700")
Message-ID: <yq1pr0uxpqm.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BF1A0BB.00A9:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jiaying" == Jiaying Zhang <jiayingz@google.com> writes:

Jiaying> It is true that all of the block layer works on 512-byte sector
Jiaying> size, but I think it is good to check for address alignment for
Jiaying> discard request so we don't insert unnecessary discard requests
Jiaying> into the request queue.

Well, then what happens when you stripe or use DM on devices with
different discard granularity?  Or what about a mirror?  Or multiple
levels of stacking of heterogeneous devices.

There are good reasons why we postpone the logical block scaling until
we're preparing the request for the actual physical device.


Jiaying> There are also certain disk drivers that assume a discard
Jiaying> request passed from the block layer is already properly
Jiaying> aligned. We could argue that those disk drivers need to fix
Jiaying> that

Which is what I'm arguing :)


Jiaying> 512 bytes and 4KB seem to be the most common sizes but I
Jiaying> wouldn't be surprised to see other logical block size.

That's the reason I'm asking.  If you have a different lbs then let's by
all means add support for it.  Or make the ULD scaling generic.

I'm open to aligning to the reported discard granularity in the ULD, for
instance.

-- 
Martin K. Petersen	Oracle Linux Engineering
