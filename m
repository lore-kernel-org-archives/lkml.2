Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab0LMWMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 17:12:23 -0500
Received: from tservice.net.ru ([195.178.208.66]:56816 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755866Ab0LMWMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 17:12:22 -0500
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 17:12:22 EST
Date: Tue, 14 Dec 2010 01:03:33 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Jesper Juhl <jj@chaosbits.net>, Ky Srinivasan <ksrinivasan@novell.com>
Subject: Re: [PATCH 1/1] hv: Use only one txf buffer per channel and
 kmalloc on initialize
Message-ID: <20101213220333.GA1636@ioremap.net>
References: <1292274861-29673-1-git-send-email-hjanssen@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292274861-29673-1-git-send-email-hjanssen@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 01:14:21PM -0800, Hank Janssen (hjanssen@microsoft.com) wrote:
> +static u8 *shut_txf_buf;
> +static u8 *time_txf_buf;
> +static u8 *hbeat_txf_buf;

Those are accessed without any kind of synchronization. I do not know
exact context, but are you sure it is single-threaded?

-- 
	Evgeniy Polyakov
