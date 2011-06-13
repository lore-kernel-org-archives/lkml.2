Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1FMOuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab1FMOuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:50:19 -0400
Date: Mon, 13 Jun 2011 10:50:12 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI, APEI, Add APEI _OSC support
Message-ID: <20110613145012.GA1924@redhat.com>
References: <1306303538-30524-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306303538-30524-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 02:05:38PM +0800, Huang Ying wrote:
> In APEI firmware first mode, hardware error is reported by hardware to
> firmware firstly, then firmware reports the error to Linux in a GHES
> error record via POLL/SCI/IRQ/NMI etc.
> 
> This may result in some issues if OS has no full APEI support.  So
> some firmware implementation will work in a back-compatible mode by
> default.  Where firmware will only notify OS in old-fashion, without
> GHES record.  For example, for a fatal hardware error, only NMI is
> signaled, no GHES record.
> 
> To gain full APEI power on these machines, a special APEI _OSC needs
> to be evaluated to tell firmware that Linux has full APEI support.
> This patch add the APEI _OSC support.

Using an Intel box I have over at RedHat, I was able to use this patch to
get error injection (EINJ) to provide me a GHES record.  Prior to this 
patch I would just get unknown NMIs.

Talking with Matthew Garret, I guess it seems that uuids like this are
typical for ACPI.

I can't speak for all the ACPI parts, but the patch looks simple and
corret from my perspective.

Reviewed-and-Tested-by: Don Zickus <dzickus@redhat.com>
