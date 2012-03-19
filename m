Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab2CSQCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:02:25 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:53527 "EHLO
	homiemail-a55.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755194Ab2CSQCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=D3SvZFHShsGlrC2fy2Fcm4cnVSg0ozSxUCjB2IcwUS8pkkBomlwK8RE9KgDYd
	KqK0T40qkaOvk2RnDxbLdgaUpslyvIhsBXZiS2fQUuy4nTyQT7QrFgqx3cVfIgYD
	qzp5DruXazWVx0WQJD5yh42fP4k/LYKD+ZssFg3NVn1e84=
Message-ID: <4F67588D.3080704@shealevy.com>
Date: Mon, 19 Mar 2012 12:02:21 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: EFI Boot Stub Early Console
References: <4F5E46EA.7020602@shealevy.com> <4F5E47E4.2070303@shealevy.com> <4F5E74A0.60001@zytor.com> <4F5E761B.7010608@shealevy.com> <4F5E775D.7080702@zytor.com> <4F648DD3.3000405@shealevy.com> <1332069701.4041.42.camel@mfleming-mobl1.ger.corp.intel.com> <4F65D09B.4050807@shealevy.com> <1332146834.4041.46.camel@mfleming-mobl1.ger.corp.intel.com> <20120319155639.7cff5df6@pyx>
In-Reply-To: <20120319155639.7cff5df6@pyx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/12 11:56 AM, Alan Cox wrote:
>>> any bootloader (including the bootstub) will call ExitBootServices()
>>> before any printk'ing actually happens?? Or am I misunderstanding the
>>> spec somehow? I suppose I could just try it and see what happens...
>> Oops. Good point, that isn't going to work.
> Surely it works fine if you are using bootstub directly from EFI ?

ConOut will work before the call to ExitBootServices(), but any 
bootloader (including the boot stub) calls that before starting the 
normal kernel boot process. I'm working on a generic earlyprintk that 
provides the same functionality as the existing earlyprintks that will 
work for any EFI boot. Matt already submitted a patch for an efi_printk 
that will be sufficient for the boot stub itself before the call to 
ExitBootServices().

~Shea
