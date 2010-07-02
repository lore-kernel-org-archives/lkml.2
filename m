Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab0GBKpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 06:45:01 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42379 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0GBKpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 06:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LEqoF2plib4WF5T7KTfheG6eqdw5y+LY4mFUQp8MC+mp11wpcGxGtZ1ei77lkAWlSw
         DgHmBf3cBE+dts8+RTePVgPt50Q0/xlEUKDFV8aCzavvD+KmVLahwx6IDEQ3NXfoIFgz
         Lgjp9VLwfWLeW/j1KMSB+JvXyz1JYMfUweS0A=
Message-ID: <4C2DC327.1090007@redhat.com>
Date: Fri, 02 Jul 2010 12:44:55 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: stefano@stabellini.net
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Stefano.Stabellini@eu.citrix.com, sheng@linux.intel.com,
       ddutile@redhat.com, jeremy@goop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 10/13] Do not try to disable hpet if it hasn't been initialized
 before
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop> <1277136847-13266-10-git-send-email-stefano@stabellini.net>
In-Reply-To: <1277136847-13266-10-git-send-email-stefano@stabellini.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2010 06:14 PM, stefano@stabellini.net wrote:
> -	if (is_hpet_capable()) {
> -		unsigned int cfg = hpet_readl(HPET_CFG);
> +	unsigned int cfg;

You changed this earlier from unsigned long to unsigned int, but it is 
wrong (though it works because bits 32-63 of the HPET_CFG register are 
unused).  Can you please make a note to change it back sometime?

Thanks,

Paolo
