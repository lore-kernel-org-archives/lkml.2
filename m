Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162303Ab2CSUDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:03:22 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:22683 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1032891Ab2CSUDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:03:18 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Ey_w0kgVM1l87BqLlHwxtKijLYhGMvR.bGPhiIs3ssz0bNr
 UQdLWpU8I.wW.sSNtKo6h6zkEZpbl9HvZ19NaBbk75sf3FK5ePtoPWhsbdNb
 1Yl3_ImEMEO6muYT3OP0Aree37KO4N6HGkev.CL.vbr0t2ucrvaEZh9NSPyz
 G.BwyPvy7XRq_HXGZO_4dW9ILliuY5mIMygG93md2tBkqxOVeigDleYdZ8Mh
 mBxTnB.Y6URZEiE6oX41DhAPH8C4CVKpTqEN0G6DSNfeffFdhOvhGuCRAPtR
 DWLTW2FH.3LR41.tEYApM9BBf.4Qsr4p.xLGjAKFOdaX2W5Dpm0G39YhYKO.
 E18C7pCY49.4LNFZzpikVCA_g6dPgElA171dBx5NLiH.TOOr8UMxQXtXXH.j
 6376h5LJF546i4UwzXtJOhYV0I314BnTewxlzhvD9cqrnQnUCh0d2MJEUw9E
 Dj8J2HPHf1yfXUNbnISA0.urW9QNGD0qzQfM_1FQjMEgC68Wd
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Mar 2012 15:03:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Sasha Levin <levinsasha928@gmail.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, kaber@trash.net,
        davem@davemloft.net, Dave Jones <davej@redhat.com>,
        netfilter-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: netfilter: Hung task
In-Reply-To: <CA+1xoqeinbEVMUGu=zx8nDbdDFx30RiTS=qiSgFKZnSYYPDZ+Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1203191501140.23632@router.home>
References: <CA+1xoqfCTXxXsbfUjttuOVutyD_FzYS8PoOoAOOtB72P8SwdVg@mail.gmail.com> <20120318141943.GA28850@1984> <CA+1xoqcQYqCgQb=1M5PVkm=6SBhV2oJxJ2CtBp=gAvZM36Kc2Q@mail.gmail.com> <20120319002811.GA30408@1984> <alpine.DEB.2.00.1203190854560.16879@router.home>
 <CA+1xoqdo5zvUe+=BYr42iEEq9mU=kd1zVxrGhQc0sNYqbpBkNQ@mail.gmail.com> <alpine.DEB.2.00.1203191129440.20196@router.home> <CA+1xoqeinbEVMUGu=zx8nDbdDFx30RiTS=qiSgFKZnSYYPDZ+Q@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Sasha Levin wrote:

> lockdep listed all the held locks there.

None of the locks listed are slub locks.

> I've mentioned that it looks very similar to
> https://lkml.org/lkml/2012/1/14/45 where the userspace helper tried to
> read from the sysfs files, but got into a deadlock since the kernel
> side held them before it called the usermode helper.

Ah yes. In that case slub held a semaphore. Code was changed since then to
no longer hold a semaphore when calling into sysfs.

The uevent handler can execute arbitrary user space code. Do you have to
hold locks while calling kmem_cache_destroy?


