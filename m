Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0FSORr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 10:17:47 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:32671 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab0FSORq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 10:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=NFN5ASlfywq4obYYbk9v2CflQDFKvo807fus/QKTQPJHVfS2DsZhWK0t0uVtGBMJmQ
         ulDdbqJUGIpFNVOMGPJi1ZZ7m6p/1ZF/reeDWumoiHCYoT42Ek+bRNbpfcFmRi/PZViw
         vAJZVG61L4i4h7Gcd/k6qp5E3sQtHlvtlDZZA=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20100619140933.GM18946@basil.fritz.box>
References: <200912081016.198135742@firstfloor.org> <20091208211647.9B032B151F@basil.firstfloor.org> 
	<AANLkTimBhQAYn7BDXd1ykSN90v0ClWybIe2Pe1qv_6vA@mail.gmail.com> 
	<20100619132055.GK18946@basil.fritz.box> <AANLkTin-lj5ZgtcvJhWcNiMuWSCQ39N8mqe_2fm8DDVR@mail.gmail.com> 
	<20100619133000.GL18946@basil.fritz.box> <AANLkTiloIXtCwBeBvP32hLBBvxCWrZMMwWTZwSj475wi@mail.gmail.com> 
	<20100619140933.GM18946@basil.fritz.box>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sat, 19 Jun 2010 16:17:24 +0200
Message-ID: <AANLkTilF6m5YKMiDGaTNuoW6LxiA44oss3HyvkavwrOK@mail.gmail.com>
Subject: Re: [PATCH] [31/31] HWPOISON: Add a madvise() injector for soft page 
	offlining
To: Andi Kleen <andi@firstfloor.org>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Sat, Jun 19, 2010 at 4:09 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Sat, Jun 19, 2010 at 03:43:28PM +0200, Michael Kerrisk wrote:
>> Is there a userspace operation to unpoison (i.e., reverse MADV_SOFT_OFFLINE)?
>
> Yes, but it's only a debugfs interface currently.

Okay -- thanks.

>> I ask because I wondered if there is something additional to be documented.
>
> I don't think debugfs needs manpages atm.

Okay.

I edited your text somewhat. Could you please review the below.

Cheers,

Michael

.TP
.BR MADV_SOFT_OFFLINE " (Since Linux 2.6.33)
Soft offline the pages in the range specified by
.I addr
and
.IR length .
This memory of each page in the specified range is copied to a new page,
and the original page is offlined
(i.e., no longer used, and taken out of normal memory management).
The effect of the
.B MADV_SOFT_OFFLINE
operation is normally invisible to (i.e., does not change the semantics of)
the calling process.
This feature is intended for testing of memory error-handling code;
it is only available if the kernel was configured with
.BR CONFIG_MEMORY_FAILURE .
