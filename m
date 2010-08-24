Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0HXVjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:39:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48068 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab0HXVjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:39:53 -0400
Message-ID: <4C743C0F.2010101@zytor.com>
Date: Tue, 24 Aug 2010 14:39:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Jack Steiner <steiner@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
        lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] - Mapping ACPI tables as CACHED
References: <20100722152220.GA18290@sgi.com> <20100724001449.GA9618@khazad-dum.debian.net>
In-Reply-To: <20100724001449.GA9618@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 05:14 PM, Henrique de Moraes Holschuh wrote:
> 
> Well, as it was raised in this thread, ACPI tables are likely to be near RAM
> regions used for IPC with the firmware or SMBIOS, and we have no idea of the
> kind of crap that could happen if we enable caching on those areas.
> 

I'm really not sure I buy that argument -- at least not on x86: if that
is the case, then when PAT is off (and we fall down to MTRR-only
control) then we'd have the same failures.  If we mark them cacheable
and the MTRRs say uncachable, then we will *still* not cache them (since
MTRR UC overrides PAT WB -- in fact "PAT off" really just means ALL the
pagetables are marked WB.)

In that sense it is probably *safer* to map them WB, since the firmware
if it uses page tables at all is extremely likely to have all the cache
control bits at zero (meaning WB) -- and if it doesn't use page tables,
they are functionally zero by default (MTRR control only.)

So I think it'd be safer to map them cacheable -- regardless of if we
want to copy them to RAM or not.

	-hpa


