Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3AJJfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:35:41 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:53272 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3AJJfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:35:39 -0500
Message-ID: <50EE8B6B.1050204@gmail.com>
Date: Thu, 10 Jan 2013 10:35:39 +0100
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Eric Wong <normalperson@yhbt.net>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dave Chinner <david@fromorbit.com>, Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [v2] fadvise: perform WILLNEED readahead asynchronously
References: <20121225022251.GA25992@dcvr.yhbt.net>
In-Reply-To: <20121225022251.GA25992@dcvr.yhbt.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Il 25/12/2012 03:22, Eric Wong ha scritto:
 > Any other (Free Software) applications that might benefit from
 > lower FADV_WILLNEED latency?

Not with fadvise but with madvise. Libreoffice / Openoffice.org have 
this comment:

// On Linux, madvise(..., MADV_WILLNEED) appears to have the undesirable
// effect of not returning until the data has actually been paged in, so
// that its net effect would typically be to slow down the process
// (which could start processing at the beginning of the data while the
// OS simultaneously pages in the rest); on other platforms, it remains
// to be evaluated whether madvise or equivalent is available and
// actually useful:

See:
http://cgit.freedesktop.org/libreoffice/core/tree/sal/osl/unx/file.cxx#n1213

May the same approach be extended to madvise MADV_WILLNEED?

thanks,
riccardo magliocchetti

