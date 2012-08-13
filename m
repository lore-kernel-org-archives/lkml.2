Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2HMWCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:02:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36073 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab2HMWCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:02:15 -0400
Message-ID: <5029794F.1050302@zytor.com>
Date: Mon, 13 Aug 2012 15:01:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Betty Dall <betty.dall@hp.com>
CC: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, pci: Fix all early PCI scans to check the vendor
 ID first
References: <1344464246-14618-1-git-send-email-andi@firstfloor.org>  <1344551691.10751.12.camel@ejdallLaptop> <50259FCE.4070205@zytor.com>  <20120811104352.GI2644@tassilo.jf.intel.com> <1344895094.23469.37.camel@ejdallLaptop>
In-Reply-To: <1344895094.23469.37.camel@ejdallLaptop>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 02:58 PM, Betty Dall wrote:
> 
> I checked the PCI specification, and Peter is right that function
> numbers can be sparse. Please go with version 1 of the patch, as Andi
> suggested. I will follow up by looking at why the three scans are not
> consistent and send a patch, if appropriate. The scans could be improved
> by stopping the function scan if function 0 does not exist because
> function 0 is required, and if it is not there then none of the other
> functions will be implemented.
> 

Yes, if function 0 doesn't exist we could, and *should* skip functions
1-7; in fact, we should not process functions 1-7 unless the
multifunction bit is set in function 0.  This matters on real devices in
the field.

	-hpa

