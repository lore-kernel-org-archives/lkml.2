Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1GPCC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 22:02:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40011
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751578Ab1GPCCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 22:02:54 -0400
Date: Fri, 15 Jul 2011 22:02:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 020/117] Staging: hv: vmbus: Support the notion of id
 tables in vmbus_match()
Message-ID: <20110716020250.GA7199@infradead.org>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-20-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-20-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:46:08AM -0700, K. Y. Srinivasan wrote:
> +static bool is_not_null_guid(const __u8 *guid)
> +{
> +	int i;
> +
> +	for (i = 0; i < (sizeof(struct hv_vmbus_device_id)); i++)
> +		if (guid[i] != 0)
> +			return true;
> +	return false;
> +}

would be nice to add uuid_{le,be}_is_nil helpers to uuid.h.  I also
think simply using a memcpy might be more efficient than the hand-rolled
loop.
