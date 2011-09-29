Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1I2R5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 13:57:15 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:41192 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751346Ab1I2R5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 13:57:14 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: EFJE0ioVM1nL881obYQDcjQCW5vgonDnxybIPCxo5s4gy7R
 MuP9qLdpJEC4qB.1CXrQt31ikDHFJ.Y7HoSdIoV5IlFzlZ4Ibdp.R9nBRH5t
 sjSDSADJ7qsP0M9Mo90zRceJOAApXZ0_PQYZa_J7oVJZtszuxldh11_lfqhv
 O8aR8uWar5I.Iay1dsv0tFec.99JoL3Hln5Xum5W6PcuNJptxFMRBBY82GDx
 G9jTOVido7CYsKbmUlnVtVhjJWuAV3eCQiwxV1C6IFyMkhzcOLXUJtrWm9S0
 .nhnmPY8uzNLcQXvEzaJEPO0oIeu_PSu3ekEF3tF6s1KyUmuKQY_qf_O73q0
 gN57J7C6t9rZI_NgbdErYVz0kT4GXldmPlCOrl55bqPzIEF3ZuFwcn6IaCQ_
 qTH.WDpaA7tavskvZvEnBsts-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 29 Sep 2011 12:57:11 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li.lee@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] kmemleak: Handle percpu memory allocation
In-Reply-To: <20110929171713.GK32023@e102109-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.00.1109291253320.12920@router.home>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com> <20110929110228.10660.87600.stgit@e102109-lin.cambridge.arm.com> <1317297373.2855.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110929171713.GK32023@e102109-lin.cambridge.arm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011, Catalin Marinas wrote:

> A better approach would be to tell kmemleak about the __percpu pointer
> via some additional API (or some other way to detect that it's a
> __percpu pointer) and kmemleak would do the for_each_possible_cpu()
> conversion when scanning.
>
> The question - can we guarantee that the __percpu pointer returned by
> alloc_percpu() does not overlap with some memory block allocated
> elsewhere? At least for the first chunk it seems to overlap with the
> percpu data section, which is fine as that's not added in kmemleak as an
> allocated block.

percpu data can be placed in physical areas as well as virtually mapped
areas. The size of the offset returned by alloc_percpu() depends on the
mechanism and therefore is treated like an arbitrary value.

> Allowing overlapping blocks in kmemleak may be a solution but it's not
> implemented yet.

You could use the address of the instance of the percpu variable in the
*first* cpu as the canonical item. As soon as you calculate an actual
address (using a processor number) you will have a physical address that
cannot overlap elsewhere.
