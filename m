Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab2BBJXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:23:13 -0500
Received: from natasha.panasas.com ([67.152.220.90]:60603 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab2BBJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:23:08 -0500
Message-ID: <4F2A55B9.4040005@panasas.com>
Date: Thu, 2 Feb 2012 11:22:01 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Andy Grover <agrover@redhat.com>, Clemens Ladisch <clemens@ladisch.de>,
        Chris Boot <bootc@bootc.net>, <target-devel@vger.kernel.org>,
        <linux1394-devel@lists.sourceforge.net>, <linux-scsi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: FireWire/SBP2 Target mode
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de> <4F29978A.3010707@redhat.com> <20120201224156.0773ebc6@stein>
In-Reply-To: <20120201224156.0773ebc6@stein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 11:41 PM, Stefan Richter wrote:
> On Feb 01 Andy Grover wrote:
>> You're saying the sbp2 protocol can theoretically be used other places
>> besides firewire? I'd say put it all in the fabric module for now.
> 
> While SBP-2 is explicitly specified for IEEE 1394 a.k.a. FireWire only,
> it could be used on any bus architecture which implements IEEE 1212
> "Control and Status Registers (CSR) Architecture for Microcomputer
> Buses".  But IEEE 1394 a.k.a. FireWire is nowadays the only remaining IEEE
> 1212 implementation, as far as I know.
> 
> On the other hand, the transport protocol SBP-2 can be used to encapsulate
> various protocols besides SCSI.  A long time ago I heard that there were
> SBP-2 printers that weren't SCSI printers, but I may have confused
> something.
> 

Hmm Interesting. So what do the other FireWire protocols use, like
networking, DV video, audio? they have yet another encapsulating transport
other than SBP-2? What a mess

> The current version of the protocol, SBP-3 which extends SBP-2
> in an upwards compatible way, has been developed specifically in
> order to transport AV/C command sets.  (AV/C is a set of specifications
> from the 1394 Trade Association that build on top of IEC 61883 "Consumer
> audio/video equipment - Digital interface" and is used for camcorders,
> audio interfaces, studio-grade video equipment, TV set top boxes etc.)
> But I am not aware of any existing SBP-3 target or SBP-3 initiator which
> actually implements AV/C.
> 
> So in short,
>   - SBP-2/3 is only used on the FireWire bus.
>   - Potentially there could be SBP-2/3 targets or initiators that
>     implement something else than SCSI.  But stock SBP-2/3 initiator
>     drivers of popular OSs are SCSI initiators, and non-SCSI SBP-2/3
>     targets are extremely rare or don't exist actually.

Thanks that was informative
I'll have a deeper look

Boaz
