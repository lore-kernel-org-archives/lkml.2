Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1KNAAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:00:06 -0500
Received: from smtp.newsguy.com ([74.209.136.69]:56463 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab1KNAAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:00:05 -0500
Message-ID: <4EC067CE.4050805@newsguy.com>
Date: Sun, 13 Nov 2011 16:58:54 -0800
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110917 Lightning/1.0b3pre Thunderbird/3.1.12
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/16] mtd/docg3: add OOB layout to mtdinfo
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>	<1320912342-30147-8-git-send-email-robert.jarzmik@free.fr>	<4EBECB89.2020102@newsguy.com> <87vcqoiavr.fsf@free.fr>
In-Reply-To: <87vcqoiavr.fsf@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2011 02:18 AM, Robert Jarzmik wrote:
> I took a different approach.  I check an internal docg3 register to see if the
> page was written. Or I could had have checked the Hamming code, as I don't think
> it can be 0xff whatever the pagesize 7 bytes values.
>
> The reason behind is that the Hamming code is Ham(64, 57), ie. Ham(2^6,
> 2^6-6-1). The means the 6 bits are enough to cover all codewords possibilities,
> and 0xff is not one of them.
>
> So unless a bitflip in Hamming code, 0xff in it means blank page.


Clever!


>  And I think
> the ECC engine is even smarter, with the ECCCONF1_PAGE_IS_WRITTEN.


I forgot about this.  If the hardware can indeed tell you, I guess this is the
best way.  Sounds like I'll be updating my blank page detection.

Mike

