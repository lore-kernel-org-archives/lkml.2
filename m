Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472Ab2HJX5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 19:57:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55006 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760066Ab2HJX51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 19:57:27 -0400
Message-ID: <50259FCE.4070205@zytor.com>
Date: Fri, 10 Aug 2012 16:57:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Betty Dall <betty.dall@hp.com>
CC: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86, pci: Fix all early PCI scans to check the vendor
 ID first
References: <1344464246-14618-1-git-send-email-andi@firstfloor.org> <1344551691.10751.12.camel@ejdallLaptop>
In-Reply-To: <1344551691.10751.12.camel@ejdallLaptop>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 03:34 PM, Betty Dall wrote:
> 
> I thought this should be a break instead of a continue since the code
> does a break if the class is 0xffffffff. If the function does not have a
> valid VENDOR_ID, then the remaining function numbers do not have to be
> scanned because functions are required to be implemented in order (no
> skipping a function number.)
> 

Is that true?  This is certainly not true in PCI in general: there is
required to be a function 0, but there is no guarantee that functions
1-7 don't have gaps.

	-hpa

