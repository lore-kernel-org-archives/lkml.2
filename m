Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2CRMKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 08:10:07 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:33907 "EHLO
	homiemail-a50.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751581Ab2CRMKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 08:10:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=PLVGTBM2PYjFxkJxRkRfVkATcp9abxPMaJ1wxl4vRbJZTh62xdA6hUHX07Zrb
	SIUN8B6oIwnAx+xB1x+MCO+ruWlF1Qvy5pA+8lb28D5rT0u/3LYkp2Gs8ST99p9b
	n3EcRQcyC35YOmKL/w3dL12L294LMIH5ewmUV++2wiLbYQ=
Message-ID: <4F65D09B.4050807@shealevy.com>
Date: Sun, 18 Mar 2012 08:10:03 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: EFI Boot Stub Early Console
References: <4F5E46EA.7020602@shealevy.com> <4F5E47E4.2070303@shealevy.com>  <4F5E74A0.60001@zytor.com> <4F5E761B.7010608@shealevy.com>  <4F5E775D.7080702@zytor.com>  <4F648DD3.3000405@shealevy.com> <1332069701.4041.42.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1332069701.4041.42.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 3/18/12 7:21 AM, Matt Fleming wrote:
> I don't think you'll need to use the graphics protocols, you should 
> just be able to put something together using the 'output_string' 
> function from the EFI simple text output protocol, e.g. something like 
> this, https://lkml.org/lkml/2012/3/16/193 

 From the UEFI 2.3.1 spec:

> Prior to a call to ExitBootServices(), all of the fields of the EFI 
> System Table are valid. After an operating system has taken control of 
> the platform with a call to ExitBootServices(), only the Hdr, 
> FirmwareVendor, FirmwareRevision, RuntimeServices, 
> NumberOfTableEntries, and ConfigurationTable fields are valid.

Doesn't this mean that ConOut can't be used for the earlyprintk, since 
any bootloader (including the bootstub) will call ExitBootServices() 
before any printk'ing actually happens?? Or am I misunderstanding the 
spec somehow? I suppose I could just try it and see what happens...

Cheers,
Shea

