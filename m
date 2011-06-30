Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1F3Tdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:33:51 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60860
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131Ab1F3Tdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:33:50 -0400
Date: Thu, 30 Jun 2011 15:33:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: Re: [PATCH 00/40] Staging: hv: Driver cleanup
Message-ID: <20110630193346.GA22707@infradead.org>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309358301-8488-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 07:38:21AM -0700, K. Y. Srinivasan wrote:
> Further cleanup of the hv drivers:
> 
> 	1) Cleanup the reference counting mess for both stor and net devices.

I really don't understand the need for reference counting on the storage
side, especially now that you only have a SCSI driver.  The SCSI
midlayer does proper counting on it's objects (Scsi_Host, scsi_device,
scsi_cmnd), so you'll get that for free given that SCSI drivers just
piggyback on the midlayer lifetime rules.

For now your patches should probably go in as-is, but mid-term you
should be able to completely remove that code on the storage side.

