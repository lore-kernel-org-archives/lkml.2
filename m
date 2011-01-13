Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab1AMUkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:40:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59253 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942Ab1AMUkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:40:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=TBWIYSRbS4CeXRkFtAt2cBk5fLzoaF8uMq6E0WVJF5SzLSB2lhDB2oqllp1i2SmPXc
         qarWplH33ea9d76YKerI6Zhbz7Yp4VhzuUkp2KyyU8JVGy8w1yAZBP46ZFKq3WYApj2k
         kCTkNL2FV7y/BUyT/mcZOo7E9fD+vlgUyqG/s=
MIME-Version: 1.0
In-Reply-To: <60566a54842bcf5974d55ed39f387c32ff9cf5cb.1294917348.git.richard.cochran@omicron.at>
References: <cover.1294917347.git.richard.cochran@omicron.at> <60566a54842bcf5974d55ed39f387c32ff9cf5cb.1294917348.git.richard.cochran@omicron.at>
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Date: Fri, 14 Jan 2011 05:39:31 +0900
Message-ID: <AANLkTimHP1OsWauj6O566WgnxVTjMbNg2PK644QcT9Lq@mail.gmail.com>
Subject: Re: [PATCH V9 02/13] ntp: add ADJ_SETOFFSET mode bit
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 8:32 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> This patch adds a new mode bit into the timex structure. When set, the bit
> instructs the kernel to add the given time value to the current time.

The unix time is a nonlinear timescale and there's no way to predict
how many leap seconds will be inserted/deleted during the given time
interval.  So it is impossible to convert relative time to absolute
time and thus your patch is broken. (More specifically, the
timekeeping_inject_offset function is broken.)

My proposal: Limit the adjustable range of the offset so that leap
seconds will never occur more than once. (2147.5 seconds would be the
best choice. :-)
