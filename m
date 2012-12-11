Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2LKTIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:08:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32941 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab2LKTIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:08:10 -0500
Message-ID: <50C78486.9070700@zytor.com>
Date: Tue, 11 Dec 2012 11:07:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Enable A20 using KBC for some MSI laptops to fix S3
 resume
References: <201210261056.44225.zary@gsystems.sk> <201211052135.20009.linux@rainbow-software.org> <50C6537A.9090303@zytor.com> <201212111959.15808.linux@rainbow-software.org>
In-Reply-To: <201212111959.15808.linux@rainbow-software.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 10:59 AM, Ondrej Zary wrote:
>
> As I said before, the BIOS probably breaks on resume before any Linux code is
> executed. So any fix must be done before suspending.
>

Well, that code should be independent of A20, being in low memory, but 
if the BIOS itself crashes, then that's... yeah.

> I hate quirks too. A general solution would be to always enable A20 using KBC
> (if KBC is present) but that's probably not acceptable.

I don't see why not.  If so we could just do it as part of the 
initialization of the i8042 driver.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

