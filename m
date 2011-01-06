Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab1AFWRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:17:17 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45225 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab1AFWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:17:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:user-agent:date:subject:from:to:cc:message-id:thread-topic
         :thread-index:in-reply-to:mime-version:content-type
         :content-transfer-encoding;
        b=QUPcZkXVIvYekx8FIJF80EE6lbzBEtxwu5E9cuqfZ58aYTt50gcA0FiOzsiSRiCfPR
         Cn4cou4cz9F6ke9tJtAeMbVxxRe0p8K0Xu7t3g9xuT7l8vGAzU8k2ZKw83bfFrDNebq9
         0RIz9WaBteUimf37tgo/cIGlFtm+5B5jTfbQs=
User-Agent: Microsoft-Entourage/12.28.0.101117
Date: Thu, 06 Jan 2011 22:17:06 +0000
Subject: Re: [PATCH 6/8] xen/debug: WARN_ON when 1-1 but no _PAGE_IOMAP flag
 set.
From: Keir Fraser <keir@xen.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Jan Beulich <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Message-ID: <C94BEFE2.11452%keir@xen.org>
Thread-Topic: [PATCH 6/8] xen/debug: WARN_ON when 1-1 but no _PAGE_IOMAP flag
 set.
Thread-Index: Acut73OxLKwQLQHZRk6BbPSlgUOCiw==
In-Reply-To: <20110106215952.GB18722@dumpdata.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2011 21:59, "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com> wrote:

>> Always 0x55...55 (for m2p entries that exist), else page fault on access to
>> the non-existent m2p entry (m2p entries only guaranteed to exist for ram).
>> Perhaps the 0xff...ff values come from Linux's own fixup code handling a
>> faulting read access of the m2p array? If so you could return 0x55...55
>> instead and avoid checking for 0xff...ff. I really don't know how you could
>> get 0xff...ff for non-RAM pages from Xen itself.
> 
> The non-RAM pages are assinged to a DOMID_IO (arch_init_memory), for example:
> 
>  298     /* First 1MB of RAM is historically marked as I/O. */
>  299     for ( i = 0; i < 0x100; i++ )
>  300         share_xen_page_with_guest(mfn_to_page(i), dom_io,
> XENSHARE_writable);
> 
> and share_xen_page.. sets that page to INVALID_M2P_ENTRY.
> 
> But I could also be reading the code wrongly?

You're right, I missed that.

 -- Keir


