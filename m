Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1JJLoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:44:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49316
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746Ab1JJLoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:44:03 -0400
Date: Mon, 10 Oct 2011 07:43:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Staging: hv: util: Invoke cn_netlink_send() in a
 work context
Message-ID: <20111010114358.GA12665@infradead.org>
References: <1318214548-22572-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318214548-22572-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 09, 2011 at 07:42:28PM -0700, K. Y. Srinivasan wrote:
> Invoke cn_netlink_send() in a work context as opposed being called
> in the context of  channel callback. On entry into the channel callback
> code the channel inbound spin lock is held and deferring to a work
> context avoids having to invoke cn_netlink_send() while holding
> the inbound lock. As part of this adjustment, also increase the
> timeout value for waiting for the user level component of KVP.

As told a few times you really need to move away from the connector
before sumitting the KVP support.  What about tackling that instead of
band aiding it?

