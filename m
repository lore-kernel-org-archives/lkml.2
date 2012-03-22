Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab2CVKuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:50:18 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:41012 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2CVKuO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:50:14 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 09/20] Input: atmel_mxt_ts - do not read extra (checksum) byte
Date: Thu, 22 Mar 2012 10:18:20 -0000
Message-ID: <7317DB9644E3CB42BFF8C23FFFF6D0DA0571E32B@hammb01.corp.atmel.com>
In-Reply-To: <4F689D41.9080507@itdev.co.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 09/20] Input: atmel_mxt_ts - do not read extra (checksum) byte
Thread-Index: Ac0GqzkG3H87cU5lQQGfZMu2bMrfewBaXG2g
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org> <1331640263-18935-10-git-send-email-djkurtz@chromium.org> <4F689D41.9080507@itdev.co.uk>
From: "Bowens, Alan" <Alan.Bowens@atmel.com>
To: "Nick Dyer" <nick.dyer@itdev.co.uk>, "Daniel Kurtz" <djkurtz@chromium.org>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Joonyoung Shim" <jy0922.shim@samsung.com>,
        "Valkonen, Iiro" <iiro.valkonen@atmel.com>,
        "Henrik Rydberg" <rydberg@euromail.se>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Benson Leung" <bleung@chromium.org>,
        "Yufeng Shen" <miletus@chromium.org>,
        "Tiwari, Atul" <Atul.Tiwari@atmel.com>
X-OriginalArrivalTime: 22 Mar 2012 10:18:21.0929 (UTC) FILETIME=[1BEA5590:01CD0815]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to confuse things, the checksum byte is available from the chip if
required. Reading it involves a slightly different approach to normal
message processor reads, in that the host needs to write the 16-bit
address of the message processor, with the MSB set. It must then follow
these two bytes with another byte consisting of the checksum of the
previous two bytes.

This functionality was added at a customer's request, although I don't
know if any current customers actually use it.


Alan Bowens
Section Manager / Atmel Corporation
Tel: (+44) (0)1489-553-611
alan.bowens@atmel.com / www.atmel.com

The information contained in this email message may be privileged,
confidential and/or protected from unauthorized disclosure. If you are
not the intended recipient, any dissemination, distribution or copying
is strictly prohibited. Please immediately notify the sender by reply if
you received this email in error. Thank you for your cooperation. 

-----Original Message-----
From: Nick Dyer [mailto:nick.dyer@itdev.co.uk] 
Sent: 20 March 2012 15:08
To: Daniel Kurtz
Cc: Dmitry Torokhov; Joonyoung Shim; Valkonen, Iiro; Henrik Rydberg;
linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Benson Leung;
Yufeng Shen; Tiwari, Atul; Bowens, Alan
Subject: Re: [PATCH 09/20] Input: atmel_mxt_ts - do not read extra
(checksum) byte

Daniel Kurtz wrote:
> It isn't sent, nor checked anyway, so don't bother reading it.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

This is fair enough, although IMO the checksum should be checked.

--
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
