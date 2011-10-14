Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab1JNOeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:34:23 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:29413 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754119Ab1JNOeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:34:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: sdB3ussVM1l06BQ39hbZ.zaN4Os7LQor3pU0.1Zzi9QfGW4
 1kIsLWoD6H6savbBH5rTrcDQ9ZKnxe3he84aHXKN8zZQwS5Y5e1CL8YMURBp
 25V2Yayu_hYlgNtV8MOLRNLieabWDDsITs3qV0Qq_uEoUd0tzoTqgg0nICaJ
 oHMqtwCVNKRZIq9YgI2I_CxKoOz5vicByJ38dVTLnTiR8WA6GmopOhHtHoEQ
 WbaFxqSnVWHvoKk3Ol7u6VkuHVSi7P4ctzEKfDJwluLCES4jYmu1RCy6g9cN
 pnesMt_u16lgXpg4AFSLkqimeGuqpaJE_FZK2xWLXecFgxma8W2Tzkra5D2i
 8z_crN99NM1XbR9XCeHyVBAvEQb7HvWtlA8lvWURrM2aZO0xgvSX9ukSJ6dp
 dpg3ckKDvfm8CVvAf0WV3UZA-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 14 Oct 2011 09:34:17 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Dimitri Sivanich <sivanich@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
In-Reply-To: <20111014141921.GC28592@sgi.com>
Message-ID: <alpine.DEB.2.00.1110140932530.6411@router.home>
References: <20111012120118.e948f40a.akpm@linux-foundation.org> <alpine.DEB.2.00.1110121452220.31218@router.home> <20111013152355.GB6966@sgi.com> <alpine.DEB.2.00.1110131052300.18473@router.home> <20111013135032.7c2c54cd.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1110131602020.26553@router.home> <20111013142434.4d05cbdc.akpm@linux-foundation.org> <20111014122506.GB26737@sgi.com> <20111014135055.GA28592@sgi.com> <alpine.DEB.2.00.1110140856420.6411@router.home> <20111014141921.GC28592@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Dimitri Sivanich wrote:

> Increasing the ZVC deltas (threshold value in calculate*threshold == 125)
> does -seem- to give a small speedup in this case (maybe as much as 50 MB/sec?).

Hmm... The question is how much do the VM paths used for the critical path
increment the vmstat counters on average per second? If we end up with
hundred of updates per second from each thread then we still have a
problem that can only be addressed by increasing the deltas beyond 125
meaning the fieldwidth must be increased to support 16 bit counters.

