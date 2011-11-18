Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab1KRSqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:46:33 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:8057 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616Ab1KRSqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:46:31 -0500
Date: Fri, 18 Nov 2011 10:46:31 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        opensuse-kernel@opensuse.org, Sergiu Iordache <sergiu@chromium.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Andrei Warkentin <andreiw@vmware.com>
Message-ID: <1406726419.275227.1321641991149.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <20111117150549.15528e81.akpm@linux-foundation.org>
Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- Original Message -----
> From: "Andrew Morton" <akpm@linux-foundation.org>
> To: "Andrei Warkentin" <andreiw@vmware.com>
> Cc: linux-kernel@vger.kernel.org, "Rolf Eike Beer" <eike-kernel@sf-tec.de>, opensuse-kernel@opensuse.org, "Sergiu
> Iordache" <sergiu@chromium.org>, "Marco Stornelli" <marco.stornelli@gmail.com>, "Eddie Wai"
> <eddie.wai@broadcom.com>, "Jayamohan Kallickal" <jayamohan.kallickal@emulex.com>, "Guennadi Liakhovetski"
> <g.liakhovetski@gmx.de>
> Sent: Thursday, November 17, 2011 6:05:49 PM
> Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
> 
> 
> I assume that nobody has gone off and checked whether all current
> callers will survive this change.  If they had, they'd have looked in
> drivers/char/ramoops.c and seen:
> 
> 	rounddown_pow_of_two(pdata->mem_size);
> 	rounddown_pow_of_two(pdata->record_size);
> 
> These operations are no-ops.  It should be
> 
> 	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
> 	pdata->record_size = rounddown_pow_of_two(pdata->record_size);
> 
> Marco or Sergio: please fix, test and send it over sometime?

I did quickly look through for code that expected rounddown_pow_of_two(1) to give 0,
but I didn't apparently look close enough for other issues.

A
