Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1DTNuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:50:21 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:40303 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752890Ab1DTNuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:50:20 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: gJkjJQoVM1mat7ULshxZTCtmQ5JR3UAB1M_8.cBrxmer08p
 LEMs2h4sFWYzRC0l5v6R1oK.muv.GjIns_EJ_kQ7UZXjYzQayjv0E8zFcfjZ
 C2EZUbfed8RjAhdAFkvY7tIGfxNzgD9TCUKmD3Ej4ZBKgWduaSmcYcI3bioY
 zkRDTG3qzI2X6WpA_TrHFepREnLX4xLn7J6rQoP_lNuKHXRfogJ8peWxyVbx
 1VpegwErA0HZP8rsqn_Yc5rwi2parxe9mC09UFpbNcKiWIESsvbo0rCLDv7x
 qrjMMsVns6r84nz52fCGJW.h6R1Rbl8N20auyivSoak6wTon9RWD6fhLjLFQ
 CHdbkQivHRlBmx.y.ggP.6wv2
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 20 Apr 2011 08:50:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <20110420115804.461E.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104200847240.8634@router.home>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com> <1303267733.11237.42.camel@mulgrave.site> <20110420115804.461E.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, KOSAKI Motohiro wrote:

> >                  from arch/parisc/kernel/asm-offsets.c:31:
> > include/linux/topology.h: In function 'numa_node_id':
> > include/linux/topology.h:255: error: implicit declaration of function 'cpu_to_node'
>
> Sorry about that. I'll see more carefully the code later. Probably long
> time discontig-mem uninterest made multiple level breakage. Grr. ;-)

True. Someone needs to go through discontig and make it work right with a
!NUMA configuration. Many pieces of the core code assume that there will
be no node on a !NUMA config today. I guess that was different in ages
past.

Maybe we should make DISCONTIG broken under !NUMA until that time?

Tejon was working on getting rid of DISCONTIG. SPARSEMEM is the favored
alternative today. So we could potentially change the arches to use SPARSE
configs in the !NUMA case.


