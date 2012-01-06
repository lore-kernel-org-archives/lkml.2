Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab2AFDW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 22:22:28 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51676 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab2AFDW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 22:22:26 -0500
MIME-Version: 1.0
In-Reply-To: <1325820878.22361.518.camel@sli10-conroe>
References: <20120103200906.GG31746@google.com>
	<4F03631C.8080501@kernel.dk>
	<20120103221301.GH31746@google.com>
	<20120103223505.GI31746@google.com>
	<20120105012445.GP31746@google.com>
	<alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
	<20120105183842.GF18486@google.com>
	<20120106021707.GA6276@google.com>
	<20120106023638.GC6276@google.com>
	<1325819655.22361.513.camel@sli10-conroe>
	<20120106030406.GD6276@google.com>
	<1325820878.22361.518.camel@sli10-conroe>
Date: Thu, 5 Jan 2012 19:22:24 -0800
X-Google-Sender-Auth: bAxDHDwqGvQp_en6yVS_ZJEEA3g
Message-ID: <CAOS58YOcciTFzYU9vsW2pnE=dbNo+rGz2XJ0Qjk4VHriNDw31g@mail.gmail.com>
Subject: Re: [PATCH block:for-3.3/core] cfq: merged request shouldn't jump to
 a different cfqq
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 7:34 PM, Shaohua Li <shaohua.li@intel.com> wrote:
>> That's how cfq has behaved before this recent plug merge breakage and
>> IIRC why the cooperating queue thing is there.  If you want to change
>> the behavior, that should be an explicit separate patch.
> My point is both cooperating merge and the plug merge of different cfq
> are merge, no reason we allow one but disallow the other. plug merge
> isn't a breakage to me.

Isolation is pretty big deal for cfq and cross cfqq merging happening
without cfq noticing it isn't gonna be helpful to the cause.  Why
don't we merge bio's across different cfqq's then?

-- 
tejun
