Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab1GDIoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:44:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36730 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab1GDIon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:44:43 -0400
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>, paulus <paulus@samba.org>
In-Reply-To: <1309768420.3282.8.camel@twins>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
	 <1309768420.3282.8.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 04 Jul 2011 10:44:26 +0200
Message-ID: <1309769066.3282.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 10:33 +0200, Peter Zijlstra wrote:
> On Mon, 2011-07-04 at 08:02 +0000, Lin Ming wrote:
> > +/*
> > + * Memory load operation info encoding
> > + */
> > +
> > +/* Bits(0-1) {L1, L2, L3, RAM} or {unknown, IO, uncached, reserved}
> > */
> > +#define MEM_LOAD_L1                    0x00
> > +#define MEM_LOAD_L2                    0x01
> > +#define MEM_LOAD_L3                    0x02
> > +#define MEM_LOAD_RAM                   0x03
> > +#define MEM_LOAD_UNKNOWN               0x00
> > +#define MEM_LOAD_IO                    0x01
> > +#define MEM_LOAD_UNCACHED              0x02
> > +#define MEM_LOAD_RESERVED              0x03
> > +
> > +/* Bits(2-3) {toggle, snoop, local, remote} */
> > +#define MEM_LOAD_TOGGLE                        (0x00 << 2)
> > +#define MEM_LOAD_SNOOP                 (0x01 << 2)
> > +#define MEM_LOAD_LOCAL                 (0x02 << 2)
> > +#define MEM_LOAD_REMOTE                        (0x03 << 2)
> > +
> > +/* Bits(4-5) {modified, exclusive, shared, invalid} */
> > +#define MEM_LOAD_MODIFIED              (0x00 << 4)
> > +#define MEM_LOAD_EXCLUSIVE             (0x01 << 4)
> > +#define MEM_LOAD_SHARED                        (0x02 << 4)
> > +#define MEM_LOAD_INVALID               (0x03 << 4) 
> 
> Did anybody check with the other PMUs that have similar features like
> PowerPC and possibly IA64?
> 
> I keep mentioning this, nobody seems interested.

Anton, Paulus, IIRC PowerPC had some sort of Data-Source indication,
would you have some docs available on the PowerPC PMU?
