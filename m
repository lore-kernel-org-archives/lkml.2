Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1AFUSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:18:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39085 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1AFUSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:18:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:user-agent:date:subject:from:to:cc:message-id:thread-topic
         :thread-index:in-reply-to:mime-version:content-type
         :content-transfer-encoding;
        b=PAbfykzuDhoNddS9Q4tVmgfw2rlNzmIX8GsQca6SMRMaSndknA2JqmfUAga5PdHd6+
         BlguA/mQ6JaeXpz0ZXBzyyAH6NHOMigZAhMigzPsai1sNp3dp8zHYywbS8aCLMvCp/uk
         wWN6lw2gPjVKLUeBUSbGw16eNfGO91l0ckrvE=
User-Agent: Microsoft-Entourage/12.28.0.101117
Date: Thu, 06 Jan 2011 20:17:38 +0000
Subject: Re: [PATCH 6/8] xen/debug: WARN_ON when 1-1 but no _PAGE_IOMAP flag
 set.
From: Keir Fraser <keir@xen.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Jan Beulich <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Message-ID: <C94BD3E2.11441%keir@xen.org>
Thread-Topic: [PATCH 6/8] xen/debug: WARN_ON when 1-1 but no _PAGE_IOMAP flag
 set.
Thread-Index: Acut3sM7bPsuIasjvUmOAukRZamReg==
In-Reply-To: <alpine.DEB.2.00.1101061935070.2390@kaball-desktop>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2011 19:50, "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>
wrote:

>> Perhaps this ties in with the m2p overlay which Stefano+Jeremy have been
>> working on to deal with granted foreign pages? I/O pages are a bit like
>> foreign memory (if you squint enough)...
>  
> In theory the m2p overlay could be used for this purpose but in practice
> the current m2p overlay API needs a struct page, also it might end up
> stressing the hashtable too much.
> 
> Besides I think Konrad's solution might be simpler: if the m2p returns
> one of the two special values we just return mfn from pte_mfn_to_pfn.
> 
> Keir, could you confirm that the m2p entries of DOM_IO pages are always
> 0xffffff or 0x55555?

Always 0x55...55 (for m2p entries that exist), else page fault on access to
the non-existent m2p entry (m2p entries only guaranteed to exist for ram).
Perhaps the 0xff...ff values come from Linux's own fixup code handling a
faulting read access of the m2p array? If so you could return 0x55...55
instead and avoid checking for 0xff...ff. I really don't know how you could
get 0xff...ff for non-RAM pages from Xen itself.

 -- Keir


