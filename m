Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2HUIrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:47:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64982 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab2HUIre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:47:34 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] Fixes for dw_dmac and atmel-mci for AP700x
Date: Tue, 21 Aug 2012 08:47:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Hein Tibosch <hein_tibosch@yahoo.es>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, "spear-devel" <spear-devel@list.st.com>
References: <502BC31E.4070200@yahoo.es> <201208210834.53544.arnd.bergmann@linaro.org> <CAKohpokhM5WkUK6ww8Neu+fx554+-4uBCsNzBxB9q5rcqSf6cw@mail.gmail.com>
In-Reply-To: <CAKohpokhM5WkUK6ww8Neu+fx554+-4uBCsNzBxB9q5rcqSf6cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208210847.18700.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:Z0giR3l2R/bw2OkEp/eu1tJvYgbtRJSvRO9a5ZP2/85
 q/ufHSN/85zXns0Bm2OAGb0bjjuL4cUb92wQdb0Caq//ZTkwrW
 6f5wg8gTYKXRRW8LJnpRKauphuYLNcK0Yx/UgegMaz7LgAN2zp
 FwVeF9iBvtDOTvje1KzjLDOjdA6v/va4kQANcfiTe2Czjf78eR
 myaDmUUbkPdI9y8KqxEo3FDUNEMiSx04zklY0QeFHKVewGXXr+
 +tBvd0QgW094DEQg90hF2vjI8j4rgOODnr4ZPaxRTJUmnWwGRC
 lJ4SyKdtBkBtj4oDCfuMX+Kt6Rl98St7tpZ6lkoDPI0P77ao45
 BJxweNXk6SQpdE8G7qePpwGky63c1899I24LzVbXp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2012, Viresh Kumar wrote:
> On 21 August 2012 14:04, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:
>
> > Yes, this is very strange. Maybe the compiler already splits the
> > access into two 16-byte loads and that confuses the device?
>
> @Arnd: Is compiler allowed to do that even when we have volatile specified
> for the access? It shouldn't optimize the access at all i believe.

Yes. The "volatile" keyword implies that the compiler has to do the access
exactly once and that it cannot reorder the access with others on the same
address, or read more data than is specified, but it can (and does) split
the access if there is a reason for that, e.g. when the address might
be misaligned and the architecture cannot do misaligned loads.
	
	Arnd
