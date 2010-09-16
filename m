Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0IPXdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:33:08 -0400
Received: from smtp103.sbc.mail.ne1.yahoo.com ([98.138.84.214]:21119 "HELO
	smtp103.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753281Ab0IPXdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:33:07 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 9NQo8KIVM1kpiPiaMRaNtjaoPS77MMEmKOvUCWIR51f._wA
 CtJ9jhI29oHtPb2UH8vhcIBqANRUAy7j67R9TwvXWa8dN3NEdu02bcKr4hOr
 3VIWQf9kDDfHUBbt2tldkOcXrDhasJxVYzTI.tZ94AT7RwF8G8aGj9hYP1vT
 CbHLjQ3AuAVc8H0DABcOP1yRZmCryUhQVXBYsf_O9r1z3wQW4_ORcEAZ.pqJ
 _lGwyfM009SJawHcE4J5e6U1Y2fD9Yu_tJME5gI2DG_mjQyhwf1dEr97hbU5
 T9uFd6rhWqPlH7fucMvrCMa.l0Hk1bYLRM.47YL3hj6F5EALOa5bUzGAVAe_
 UijF5zkQEaY4YuWgKAdc-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand()
	caller
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Chetan Loke <chetanloke@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <AANLkTi=QXj0Do_PDvFmu5v8Py_tm_uJdDh_PQu_96M2v@mail.gmail.com>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
	 <AANLkTi=QXj0Do_PDvFmu5v8Py_tm_uJdDh_PQu_96M2v@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 16 Sep 2010 16:28:55 -0700
Message-Id: <1284679735.13344.123.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 19:26 -0400, Chetan Loke wrote:
> On Thu, Sep 16, 2010 at 6:35 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> 
> > and LLDs have adopted over the years.  The changes involved here are really
> > quite straight forward, but please note that none of this code has been tested
> > with actual hardware yet, and is intended for generating comments for the relivent
> > SCSI LLD driver maintainers and other interested folks.
> >
> 
> NO. Why not try testing it w/ an abort storm first else we will
> seriously end up screwing the filesystems....

The only real issue here would be an immediate struct
Scsi_Host->host_lock dead lock for those LLDs that still use legacy
unlock() > do_work() -> lock() in their SHT->queuecommand() caller.
This is *not* going to happen under heavy load with a bunch of
outstanding WRITEs, but immediate the first couple of times that
scsi_dispatch_cmd() gets called, so there is really little to no fear of
filesystem corruption with these patches.

Anyways, please feel free to test them yourself with an TMR ABORT storm
if you so desire..

Best,

--nab

