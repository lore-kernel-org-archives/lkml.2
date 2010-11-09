Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0KIQmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:42:14 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:49816 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753199Ab0KIQmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:42:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=eQeam8pYwEhXDqVbruabY2eCxB4Xqs9RaPkp+UefxHI0vxVfLNl5MJCFC+R4mqdLAC3FWM7B6XSdvQIXE6vDHX/yTVWQWH745+QhssER6GvnoXM953Unei6kGEf/SwRt;
Date: Tue, 9 Nov 2010 08:42:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Martin Wilck <martin.wilck@ts.fujitsu.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wichert, Gerhard" <gerhard.wichert@ts.fujitsu.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] fix size checks for mmap() on /proc/bus/pci files
 (resent)
Message-ID: <20101109084206.1b6ac66a@jbarnes-desktop>
In-Reply-To: <4CD917AB.6070705@ts.fujitsu.com>
References: <4cbffbf8.Qhs/h1a0ymU/N8ON%martin.wilck@ts.fujitsu.com>
	<4CD917AB.6070705@ts.fujitsu.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Nov 2010 10:43:07 +0100
Martin Wilck <martin.wilck@ts.fujitsu.com> wrote:

> Hi Jesse & linux-pci,
> 
> may I kindly ask if anyone has had a look at this patch yet?
> 
> https://patchwork.kernel.org/patch/270271/
> http://kerneltrap.org/mailarchive/linux-kernel/2010/10/21/4635039

Yes I looked at it, and then promptly lost it in my inbox.

Thanks for fixing this; /proc/bus/pci semantics are definitely
different than /sys so we definitely want this.

I don't really like the new int argument to pci_mmap_fits (it's not
obvious from reading callers what that arg would do), maybe you could
make it into an enum that better describes the API or semantic being
used for the check?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
