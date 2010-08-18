Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0HRKft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 06:35:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:48659 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0HRKfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 06:35:46 -0400
Subject: Re: [PATCH 0/8] [Resend] ideapad: using EC command to control
 rf/camera power
From: David Woodhouse <dwmw2@infradead.org>
To: Ike Panhc <ike.pan@canonical.com>
Cc: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 11:35:19 +0100
Message-ID: <1282127719.2747.211.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 09:36 +0100, Ike Panhc wrote:
> 
> Once the rfkill of a laptop is set to block, it is no way to unblock with Linux
> without driver. Thanks for David Woodhouse wrote the first driver solving this.
> 
> But the \_SB_.GECN and \_SB_.DECN are only available on Lenovo ideapad S10-3.
> Using EC command to control rf/camera power is better because I believe every
> ideapads which has VPC2004 device in its DSDT has this common method.
> 
> This driver is tested and work fine on Lenovo ideapad B550 and ideapad S10-3.

Works for me too (on S10-3); thanks.

It all looks good, although should we have a delay or a schedule or at
least a cpu_relax() in the read_ec_data() and write_ec_cmd() loops?
Those loops should be using time_before() too, rather than open-coding
the comparison.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

