Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab1LBBcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:32:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60816 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab1LBBcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:32:15 -0500
MIME-Version: 1.0
In-Reply-To: <20111202005150.2e9fde43@bob.linux.org.uk>
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
	<1322783258-20443-2-git-send-email-paul.gortmaker@windriver.com>
	<20111202005150.2e9fde43@bob.linux.org.uk>
Date: Thu, 1 Dec 2011 20:32:13 -0500
X-Google-Sender-Auth: bQfYHaUEJrrCeMsRGJU_HVgTNFE
Message-ID: <CAP=VYLpn7kJJ6we3diqhCR+QzjQtzTmkEzSP-uw07=udJKYK6g@mail.gmail.com>
Subject: Re: [PATCH 1/3] serial: make bugs field not specific to 8250 type uarts.
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Alan Cox <alan@linux.intel.com>
Cc: gregkh@suse.de, galak@kernel.crashing.org, scottwood@freescale.com,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 7:51 PM, Alan Cox <alan@linux.intel.com> wrote:
>> Make the bugs field part of the globally visible struct
>> uart_port and remove the 8250 specific one.
>
> Except all the bits in it are 8250 specific things or names that are
> meaningless in generic form - no. I also don't want to encourage flags
> and bug bits. We already have too many and its making the code a mess.
> So right now we want less not more.

The bits in "bugs" are only passed through -- the idea is that there is
no "interpretation" of them by any generic layer -- only that they prop
from the arch down to the driver which knows what they mean.

I can understand the "want less not more" mentality -- I was thinking
the same thing when I was looking at the replication of fields between
uart_port and uart_8250_port, and toying with the idea of helping clean
that up....  (separate topic, to be sure.)

If you have an idea in mind how arch/platform code should cleanly
pass data about known uart bugs to the uart driver, then let me know
what you have in mind.  I've no real attachment to what I proposed
here -- it just happened to be the solution I thought would be the least
offensive.  If there is a better idea floating around, I'll go ahead and
try to implement it.

Thanks,
Paul.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-serial" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
