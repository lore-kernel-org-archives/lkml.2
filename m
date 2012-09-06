Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2IFOSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:18:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:43850 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab2IFOSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:18:47 -0400
Subject: Re: [RFC,PATCH v2] efi: Add support for a UEFI variable filesystem
From: Matt Fleming <matt.fleming@intel.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matt Domsch <Matt_Domsch@Dell.com>
In-Reply-To: <1346910035.47691.188651047712.1.gpush@pecola>
References: <1346910035.47691.188651047712.1.gpush@pecola>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 06 Sep 2012 15:18:40 +0100
Message-ID: <1346941120.4244.82.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 13:40 +0800, Jeremy Kerr wrote:
> From: Matthew Garrett <mjg@redhat.com>
> 
> The existing EFI variables code only supports variables of up to 1024
> bytes. This limitation existed in version 0.99 of the EFI specification,
> but was removed before any full releases. Since variables can now be
> larger than a single page, sysfs isn't the best interface for this. So,
> instead, let's add a filesystem. Variables can be read, written and
> created, with the first 4 bytes of each variable representing its UEFI
> attributes. The create() method doesn't actually commit to flash since
> zero-length variables can't exist per-spec.
> 
> Updates from Jeremy Kerr <jeremy.kerr@canonical.com>.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> ---
> v2: Add check for < 4-byte writes

Am I correct in thinking that this filesystem doesn't handle deletion of
authenticated variables?

