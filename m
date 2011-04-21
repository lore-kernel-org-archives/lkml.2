Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1DUUCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:02:50 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:46023 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753200Ab1DUUCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:02:49 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 1IX.4P0VM1lcwwca2bzo00B1v1OHYyJxxoSaKBPwgkPbQoO
 2e0Gx0wRO0hk37IWZ5ri88mdi565mtUdVM4d_GodcWKBsG1kIU.WeNeYQBH7
 0qQr4pF6q2y_AsFiygxGnv9h7k9zSndPfoAiS_QC57lSsH4x4zW2l4RfuBKK
 YoJ3x1Mb7djwaK.2POhq4sDDC3zvDeCjb_m2r7DGb6j9ymqHVnei4kGpKOyT
 q9jkdRE90xm_BcVvXwWAV2W1hMDe2eAKEtlIndnUkCiGfYlU96jnAXTgdJFi
 .38vjhL43VIUp.aMp8UMecL0xMBkc9FVCt04J7TIBfQfMutISar0Ixtxityr
 EEI1Ol2G_b3weJrA2qwyfKp4K
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 21 Apr 2011 15:02:42 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1104211500170.5741@router.home>
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011, David Rientjes wrote:

> I think we may want to just convert slub (and the memory controller) to
> use N_HIGH_MEMORY rather than N_NORMAL_MEMORY since nothing else uses it
> and the generic code seems to handle N_HIGH_MEMORY for all configs
> appropriately.

In 32 bit configurations some architectures (like x86) provide nodes
that have only high memory. Slab allocators only handle normal memory.
SLAB operates in a kind of degraded mode in that case by falling back for
each allocation to the nodes that have normal memory.

