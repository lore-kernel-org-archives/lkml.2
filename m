Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab2EJRWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:22:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46503 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759420Ab2EJRVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:21:39 -0400
Date: Thu, 10 May 2012 18:21:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Anbu Manikandan <canbumanikandan@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Kmemleak feature
Message-ID: <20120510172116.GB20860@arm.com>
References: <CAAGB47OajENL-g-CvdAgp1k2XKU4dOWbHz=mDy79mPOvi-eEmQ@mail.gmail.com>
 <CAAGB47PiZ0cveWvObEjS8OPB++M3s1dENybnjoxyhQ8K_T4SpA@mail.gmail.com>
 <CAAGB47PmB8o=mrnSoU1jYt_ecjH2WBLEzGRFqZWhWZXWQkTHaA@mail.gmail.com>
 <CAAGB47PpTx9-eFz6ppbCYshA5yp293Tm1X-cAaBkZ+xX05_UUg@mail.gmail.com>
 <CAAGB47N3oPkK1WhwzB7q4_6rvzKbnx3Ugwdr+aUuwTqiNX2oog@mail.gmail.com>
 <alpine.LFD.2.02.1205090925420.1879@tux.localdomain>
 <20120509082248.GA11099@arm.com>
 <CAAGB47NxugPZbV2ma-G7Aok5Xky=6AuyBGtis9U3hzNw8LDT0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAGB47NxugPZbV2ma-G7Aok5Xky=6AuyBGtis9U3hzNw8LDT0w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 05:42:35PM +0100, Anbu Manikandan wrote:
> As suggested by you, I have executed Kmemleak on 2.6.35-kernel and 3.0-RT
> kernel.
> I have noticed that Kmemleak behavior is little different between 2.6.35 and
> 3.0-RT kernel for vmalloc allocation memory leak. There is no entry for vmalloc
> allocation memory leak in 3.0-RT kernel.
...
> I tried modifying min_count value for vmalloc allocation from "3" to "4" as
> below in 3.0-RT kernel:

I can reproduce the missing vmalloc report on a non-rt 3.4-rc3 kernel as
well, so something must have changed in the vmalloc code in the past
months. A suspecting commit is f5252e00 but I need to investigate
whether a third reference to the vmalloc'ed pointer is stored in the
generic code somewhere before we decide to bump the min_count to 4.

-- 
Catalin
