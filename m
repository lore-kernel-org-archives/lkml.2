Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996Ab2FAOKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:10:15 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:48763 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758970Ab2FAOKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:10:14 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qrY_7ewVM1mt9dro_GzabJOB2caPf9bKWlWQZk2jHCxWd.J
 O_4FhZhdV9sp4Rs8PqaguK_glszXDhUAm4IeDQalzrGcqVSimYGqON8m_tZv
 d.6K3iXnSgDuov5X82.vgoQcaX2NW_aU__zGR.fqIkGtMcShWnkRNEnScA_H
 X8bQn8sXgteaXilCbsask_KRa6mK0rl5mGhl6zvGRp0Pjg7ZH4YPDJdWHJDE
 eKXGPspWZrX71NqsIfxC_4diovVERgq7smXNdoboeRplKLlTclFZV4R4Vip4
 wh9f4Eh8oYfwWQaSrrDSX1LGKjCCTfEhFFMiVHNMM5BaUDO2LxiQxF8VtL3j
 djbwLAZ36b22CFO9qgMQrumSSVG99cJlp8jjKFJlG_uhIIRlIb1x1biuUolp
 H
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 1 Jun 2012 09:10:11 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
In-Reply-To: <CAOJsxLHz7sJytDdDsjXCP4VaR2AFu_dDJchHQuceB11wMGN+Yg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1206010905390.6634@router.home>
References: <1338438844-5022-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.00.1205311342320.2764@chino.kir.corp.google.com> <CAOJsxLHz7sJytDdDsjXCP4VaR2AFu_dDJchHQuceB11wMGN+Yg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2012, Pekka Enberg wrote:

> > I think the version proposed by David Mackey is more clear, it makes it
> > obvious that we don't want to dereference current in interrupt context
> > whereas that relies on short-circuiting your conditional in your approach.
>
> I like it better also. Christoph, Andi?

I dont like the conditional in the assignment followed by a test for NULL
which is also not easy to read.

Would prefer that the control flow be redesigned.

Something like

	if (in_interrupt())
		return numa_node_id();

	policy = current->mempolicy
	if (!policy || ...)
		return numa_node_id();

