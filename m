Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab0JSNed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:34:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53914 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758293Ab0JSNec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:34:32 -0400
Date: Tue, 19 Oct 2010 15:34:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [patch]x86: spread tlb flush vector between nodes
Message-ID: <20101019133426.GB11654@basil.fritz.box>
References: <1286955698.13317.5.camel@sli10-conroe.sh.intel.com>
 <20101013081629.GA1621@basil.fritz.box>
 <1286959176.24888.6.camel@sli10-conroe.sh.intel.com>
 <1287466757.29515.2.camel@sli10-conroe.sh.intel.com>
 <6dd05e19-05ef-48e4-b42d-d18c913fa4d7@email.android.com>
 <20101019084423.GB27723@elte.hu>
 <1287478532.9456.0.camel@sli10-conroe.sh.intel.com>
 <20101019103759.GC32212@elte.hu>
 <1287494931.1699.12.camel@shli-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287494931.1699.12.camel@shli-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> +static int tlb_vector_offset[NR_CPUS] __read_mostly;

Never use NR_CPUS. Always use per cpu data.

Otherwise you waste a lot of space on a CONFIG_MAX_SMP
kernel running on a smaller box.

-Andi
