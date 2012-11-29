Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab2K2VUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:20:46 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36453 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab2K2VUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:20:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com, lenb@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Tang Chen <tangchen@cn.fujitsu.com>
Subject: Re: [RFC PATCH v3 0/3] acpi: Introduce prepare_remove device operation
Date: Thu, 29 Nov 2012 22:25:30 +0100
Message-ID: <7256354.mIkI9CW3OY@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1354222577.7776.22.camel@misato.fc.hp.com>
References: <1353693037-21704-1-git-send-email-vasilis.liaskovitis@profitbricks.com> <1354221570.7776.11.camel@misato.fc.hp.com> <1354222577.7776.22.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 29, 2012 01:56:17 PM Toshi Kani wrote:
> On Thu, 2012-11-29 at 13:39 -0700, Toshi Kani wrote:
> > On Thu, 2012-11-29 at 21:30 +0100, Rafael J. Wysocki wrote:
> > > On Thursday, November 29, 2012 10:03:12 AM Toshi Kani wrote:
> > > > On Thu, 2012-11-29 at 11:15 +0100, Rafael J. Wysocki wrote:
> > > > > On Wednesday, November 28, 2012 11:41:36 AM Toshi Kani wrote:
> > > > > > 1. Validate phase - Verify if the request is a supported operation.  All
> > > > > > known restrictions are verified at this phase.  For instance, if a
> > > > > > hot-remove request involves kernel memory, it is failed in this phase.
> > > > > > Since this phase makes no change, no rollback is necessary to fail.  
> > > > > 
> > > > > Actually, we can't do it this way, because the conditions may change between
> > > > > the check and the execution.  So the first phase needs to involve execution
> > > > > to some extent, although only as far as it remains reversible.
> > > > 
> > > > For memory hot-remove, we can check if the target memory ranges are
> > > > within ZONE_MOVABLE.  We should not allow user to change this setup
> > > > during hot-remove operation.  Other things may be to check if a target
> > > > node contains cpu0 (until it is supported), the console UART (assuming
> > > > we cannot delete it), etc.  We should avoid doing rollback as much as we
> > > > can.
> > > 
> > > Yes, we can make some checks upfront as an optimization and fail early if
> > > the conditions are not met, but for correctness we need to repeat those
> > > checks later anyway.  Once we've decided to go for the eject, the conditions
> > > must hold whatever happens.
> > 
> > Agreed.
> 
> BTW, it is not an optimization I am after for this phase.  There are
> many error cases during hot-plug operations.  It is difficult to assure
> that rollback is successful for every error condition in terms of
> testing and maintaining the code.  So, it is easier to fail beforehand
> when possible.

OK, but as I said it is necessary to ensure that the conditions will be met
in the next phases as well if we don't fail.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
