Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab0GGAvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 20:51:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42166 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0GGAvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 20:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lKsz7nhM/X3H4R9k2wCpctXp6otlB5CXusy2VuQYmdQWIea7PQQ1ihoWix5B9MFp1E
         T/k4qzRKDI9aPsXWCK0SxVvfEv8KL/sYg/k33BPZxfv7fN5qZsQRVg2ZBrM5dMfk2mri
         q3Nsefyk5gLlTUymW0igEvahfd47KqLhmMgGQ=
MIME-Version: 1.0
In-Reply-To: <1278463901.20082.34.camel@dwillia2-linux>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	<4C29420D.2010406@intel.com>
	<AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	<4C2A8879.8010000@intel.com>
	<AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	<4C2AC55E.3040303@intel.com>
	<AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	<1277923422.16256.8.camel@localhost>
	<4C2B9DAC.1030806@intel.com>
	<1277928125.18854.0.camel@localhost>
	<4C2BBACF.3080405@intel.com>
	<1277965264.18854.16.camel@localhost>
	<4C2C3B07.7050200@intel.com>
	<1277968336.4945.3.camel@localhost>
	<4C2C4319.6090906@intel.com>
	<1277972137.12558.2.camel@localhost>
	<4C2CCE67.6070600@intel.com>
	<AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>
	<AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>
	<1278324973.16975.68.camel@localhost>
	<AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>
	<1278463901.20082.34.camel@dwillia2-linux>
Date: Tue, 6 Jul 2010 17:51:19 -0700
X-Google-Sender-Auth: GbPoM2Vt0LPagv3oX8sB_5ONeKo
Message-ID: <AANLkTilnrdghkK1y7vc2Zi0C7KMXHYXpI_whecRxTD_8@mail.gmail.com>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: Chris Li <lkml@chrisli.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 6, 2010 at 5:51 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> No, it should be PCI_DEVICE_ID_INTEL_IOAT_SNB (0x402f) for the dma
> engine at 00:0f.0 .  PCI_DEVICE_ID_INTEL_ESB2_0 is the LPC controller at
> 00:1f.0,
>
>> That seems to be the reason preventing the warning to be print out. I am not
>> sure the warning should be always print out. Just curious why it did
>> not trigger.
>
> It should always trigger, and I have verified as much with the attached
> replacement patch (by forcing the error on a working system), but we run
> into a new problem.  dma_pool_alloc() assumes that any dma_mapping error
> is transient.  Do we need a new type of dma_mapping_error() that
> indicates permanent failure versus ENOMEM?  The driver can handle the
> allocation failure, but it never gets the chance.

Should I test your V2 patch instead?

Chris
