Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab0EYMnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:43:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41205 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab0EYMnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:43:40 -0400
Date: Tue, 25 May 2010 13:43:25 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Yu, Luming" <luming.yu@intel.com>
Cc: Len Brown <lenb@kernel.org>, Philip Langdale <philipl@overt.org>,
       Jeff Garrett <jeff@jgarrett.org>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "venki@google.com" <venki@google.com>
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
Message-ID: <20100525124325.GC7876@srcf.ucam.org>
References: <87y6jkee1b.fsf@basil.nowhere.org> <20100205160900.GA2736@jgarrett.org> <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain> <20100426194002.586fbaa5@fido5> <20100427124703.GA16706@jgarrett.org> <alpine.LFD.2.00.1004301218280.2489@sony> <20100430174447.GA14889@srcf.ucam.org> <d7f2dd35a4361e5156079278543769a0@localhost> <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain> <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the other hand, the relevant section of spec is:

"OSPM uses the BM_STS bit to determine the power state to enter when 
considering a transition to or from the C2/C3 power state. The BM_STS is 
an optional bit that indicates when bus masters are active. OSPM uses 
this bit to determine the policy between the C2 and C3 power states: a 
lot of bus master activity demotes the CPU power state to the C2 (or C1 
if C2 is not supported), no bus master activity promotes the CPU power 
state to the C3 power state. OSPM keeps a running history of the BM_STS 
bit to determine CPU power state policy."

while the description of the bit itself is:

"This is the bus master status bit. This bit is set any time a system 
bus master requests the system bus, and can only be cleared by writing a 
“1” to this bit position. Notice that this bit reflects bus master 
activity, not CPU activity (this bit monitors any bus master that can 
cause an incoherent cache for a processor in the C3 state when the bus 
master performs a memory transaction)."

which implies that as long as you don't have any cache coherency 
concerns, it's acceptable (if potentially suboptimal) to enter C3 even 
if the bit is set.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
