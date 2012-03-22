Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab2CVCxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:53:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27011 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab2CVCxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:53:13 -0400
To: Shaohua Li <shli@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, neilb@suse.de
Subject: Re: [patch 1/2]block: handle merged discard request
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20120316073213.656519005@fusionio.com>
	<20120316073512.485027511@fusionio.com>
	<20120320162157.GE17071@redhat.com>
	<CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
	<4F69C62C.7020604@kernel.org> <yq18vitwejt.fsf@sermon.lab.mkp.net>
	<CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
Date: Wed, 21 Mar 2012 22:53:02 -0400
In-Reply-To: <CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
	(Shaohua Li's message of "Thu, 22 Mar 2012 10:39:19 +0800")
Message-ID: <yq1zkb9uz1t.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090205.4F6A9412.00A2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Shaohua" == Shaohua Li <shli@kernel.org> writes:

Shaohua> Yes, this is a problem. But note we already have this problem
Shaohua> with discard request for a long time. The payload has just
Shaohua> (sector, length).  And looks the request finish returns the
Shaohua> transfered data of the payload instead of the discarded
Shaohua> data. Am I missing anything?

Nope, it's broken. But if you check my write same patches you'll see
that I actually return the correct completion size there.

There are several additional commands in the pipeline where the 1:1
mapping between DMA size and block range is invalid. I want to get rid
of the 1:1 assumption in general so we can handle any command without
these evil workarounds.

-- 
Martin K. Petersen	Oracle Linux Engineering
