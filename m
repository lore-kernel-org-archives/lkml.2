Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0ELN7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:59:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37813 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0ELN7r (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 12 May 2010 09:59:47 -0400
Date: Wed, 12 May 2010 09:58:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Len Brown <lenb@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, linux-kernel@vger.kernel.org,
       gpxe-devel@etherboot.org, Peter Jones <pjones@redhat.com>
Subject: Re: [LKML] Re: [PATCH 1/2] ibft: Update iBFT handling for v1.03 of
	the spec.
Message-ID: <20100512135843.GA5686@phenom.dumpdata.com>
References: <1270822888-13192-1-git-send-email-konrad@kernel.org> <1270822888-13192-2-git-send-email-konrad@kernel.org> <alpine.LFD.2.00.1005120125170.5297@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005120125170.5297@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BEAB41D.000C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 01:26:59AM -0400, Len Brown wrote:
> 
> >  #define IBFT_SIGN "iBFT"
> ...
> > +#ifdef CONFIG_ACPI
> > +	/*
> > +	 * One spec says "IBFT", the other says "iBFT". We have to check
> > +	 * for both.
> > +	 */
> 
> Really?
> Which one do you see in the field?

The one machine I do remember seeing this in the ACPI tables was the IBM
HS20, but I can't remember which one it was. Mike, Peter - any
recollection? Don't know about about Intel ones.

For cases where there was no ACPI, the 'iBFT' was definitly the string I saw.

> any reason to #define "iBFT" above and not use it below?
> 
> > +	if (!ibft_addr)
> > +		acpi_table_parse(ACPI_SIG_IBFT, acpi_find_ibft);
> > +	if (!ibft_addr)
> > +		acpi_table_parse("iBFT", acpi_find_ibft);

Could definitly use the IBFT_SIGN here.

Thanks for taking a look!
