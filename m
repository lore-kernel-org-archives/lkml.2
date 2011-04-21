Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1DUTdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:33:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1DUTdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=fkS85yKwWvUS+vVIEnmQNLq7Ru7xRSP7RAL0O3HxYeSOAhOHMMLVCYRpqaS+3OEbUk
         sXAIvyxXkvLJsKEpsPdQ==
Date: Thu, 21 Apr 2011 12:33:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <20110421221712.9184.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104211230030.5829@chino.kir.corp.google.com>
References: <1303337718.2587.51.camel@mulgrave.site> <alpine.DEB.2.00.1104201530430.13948@chino.kir.corp.google.com> <20110421221712.9184.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011, KOSAKI Motohiro wrote:

> ia64 and mips have CONFIG_ARCH_POPULATES_NODE_MAP and it initialize
> N_NORMAL_MEMORY automatically if my understand is correct.
> (plz see free_area_init_nodes)
> 

ia64 doesn't enable CONFIG_HIGHMEM, so it never gets set via this generic 
code; mips also doesn't enable it for all configs even for 32-bit.

So we'll either want to take check_for_regular_memory() out from under 
CONFIG_HIGHMEM and do it for all configs or teach slub to use 
N_HIGH_MEMORY rather than N_NORMAL_MEMORY.
