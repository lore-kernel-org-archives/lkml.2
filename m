Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab1DISXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 14:23:55 -0400
Received: from dspnet.fr ([188.165.44.67]:39986 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab1DISXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 14:23:52 -0400
Date: Sat, 9 Apr 2011 20:23:47 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110409182347.GB27431@dspnet.fr>
References: <1301592656.586.15.camel@jaguar>
 <4D982E89.8070502@redhat.com>
 <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
 <4D9847BC.9060906@redhat.com>
 <4D98716D.9040307@codemonkey.ws>
 <4D9873CD.3080207@redhat.com>
 <20110406093333.GB6465@elte.hu>
 <4D9E6F6E.9050709@codemonkey.ws>
 <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
 <4D9F150B.1030809@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9F150B.1030809@codemonkey.ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 09:00:43AM -0500, Anthony Liguori wrote:
> Really, having a flat table doesn't make sense.  You should just send 
> everything to an i440fx directly.  Then the i440fx should decode what it 
> can, and send it to the next level, and so forth.

No you shouldn't.  The i440fx should merge and arbitrate the mappings
and then push *direct* links to the handling functions at the top
level.  Mapping changes don't happen often on modern hardware, and
decoding is expensive.  Incidentally, you can have special handling
functions which are in reality references to kernel handlers,
shortcutting userspace entirely for critical ports/mmio ranges.

  OG.
