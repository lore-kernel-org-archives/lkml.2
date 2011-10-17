Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab1JQWOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:14:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38727 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1JQWOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:14:43 -0400
Date: Mon, 17 Oct 2011 17:14:28 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dan McGrath <troubledaemon@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Alexey Starikovsky <aystarik@gmail.com>
Subject: Re: [PATCH] x86: mpparse: fix mp_bus_not_pci handling
Message-ID: <20111017221428.GB9543@elie.hsd1.il.comcast.net>
References: <20110925212900.10713.67058.stgit@bhelgaas.mtv.corp.google.com>
 <CAErSpo6UyfP4mHUK7-wpvDUQ75n4z+rtgWQj-4NSvPCBK_KKbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAErSpo6UyfP4mHUK7-wpvDUQ75n4z+rtgWQj-4NSvPCBK_KKbQ@mail.gmail.com>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Sun, Sep 25, 2011 at 3:29 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:

>> Dan bisected a Dell PowerEdge 4200 boot regression to commit f8924e770.
>> Prior to that commit, 32-bit kernels set mp_bus_not_pci for all buses
>> except PCI.  Afterwards, we set mp_bus_not_pci only for ISA.  But ISA is
>> not the only non-PCI bus, so it's better to always set mp_bus_not_pci
>> and clear it only for PCI.
[...]
>> +++ b/arch/x86/kernel/mpparse.c
>> @@ -95,8 +95,8 @@ static void __init MP_bus_info(struct mpc_bus *m)
[...]
>> +       set_bit(m->busid, mp_bus_not_pci);
>>        if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
>> -               set_bit(m->busid, mp_bus_not_pci);
[...]
> Ping?  I don't see this in linux-next, so I don't know if it got
> dropped or if there's something wrong with it.

For what it's worth (not much, of course):

 Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
