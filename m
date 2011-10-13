Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1JMPyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:54:35 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:35015 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752676Ab1JMPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:54:34 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0VGKZ7UVM1kW_Lm9ouy1U0bqJVvQzprn5sMPyiceqa4OmI5
 YotQTp7EV6c98r_O2fo.TdWeR6mjSepQQSy88cxjZQi2M9VSaodcamdWb7Fx
 3EicOAF3bYfAKu9nCLTLq65548z35PE77VvAYozf_nkud3TcIhbqtYMkWVwv
 D3fEfcXNFNp44XyOp9udXe369QcFGvITCvgtBinOp7nhHP9pgfYEYjaOTv0A
 WeCOxyrxQ7LdMVvhiYCQjT2tSU_9UXYAmGr4Feo7_1A9LDkRhquIzZG0x8AK
 F.6uwD1NnpOclipGBp7Ppb97NxZF6MGlEbgw2ldLrDXy6EI7.YtCAVBzCV4u
 V8vnkogRYaWicQTdTXJ7IDQDm3JYDAL4_a1Xfn_ft8DLlynY-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 13 Oct 2011 10:54:30 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Dimitri Sivanich <sivanich@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
In-Reply-To: <20111013152355.GB6966@sgi.com>
Message-ID: <alpine.DEB.2.00.1110131052300.18473@router.home>
References: <20111012160202.GA18666@sgi.com> <20111012120118.e948f40a.akpm@linux-foundation.org> <alpine.DEB.2.00.1110121452220.31218@router.home> <20111013152355.GB6966@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Dimitri Sivanich wrote:

> > increase the allowed delta per zone if frequent updates occur via the
> > overflow checks in vmstat.c. See calculate_*_threshold there.
>
> I tried changing the threshold in both directions, with slower throughput in
> both cases.

If that is the case check for the vm_stat cacheline being shared with
another hot kernel variable variable. Maybe that causes cacheline
eviction.

If there are no updates occurring for a while (due to increased deltas
and/or vmstat updates) then the vm_stat cacheline should be able to stay
in shared mode in multiple processors and the performance should increase.


