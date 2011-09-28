Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1I1RL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:11:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37611 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab1I1RL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:11:27 -0400
Date: Wed, 28 Sep 2011 19:11:17 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: MAC firmware does not load due to (commit 288d5abe
 usermodehelper)
Message-ID: <20110928171115.GA5909@netboy.at.omicron.at>
References: <20110928120630.GB9456@netboy.at.omicron.at>
 <CA+55aFy4aZPdUNBR0O3SP1iRRJyeF9kPZxH9G_eYdxueYskF4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy4aZPdUNBR0O3SP1iRRJyeF9kPZxH9G_eYdxueYskF4g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 08:21:05AM -0700, Linus Torvalds wrote:
> 
> Something seems to be calling ioctl() befor rest_init() has even
> completed. Which sounds odd, but I wonder if the schedule() there
> before it might have let 'init' get going.

It does look like it. The init is busybox, and the startup script does
mount, syslogd, and then ifup, so that all can go by quickly.

> Does something like the attached (UNTESTED) fix it?

Yup, problem cured.

Thanks,
Richard

