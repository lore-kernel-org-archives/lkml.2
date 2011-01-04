Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050Ab1ADAlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 19:41:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51789 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1ADAlE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 19:41:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gIs9sMI6EAHjKMc1zy/xzR2YFFSyNLo/0WOQJ48FdtBSEc3Jdh7YyZaOXWXdjFp9qR
         Wx7swjSJ0D/eBS9THIad6BDi7uhuNw5ogenvqEnpG7+R1CMip5qlVvXlXaG6mNKKjDYi
         CNRhYY2Kj3A3YdDCaXRVf8EQfpdmzkGcON0Xo=
MIME-Version: 1.0
In-Reply-To: <20110103151944.GA32508@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<20101221182037.GA4783@n2100.arm.linux.org.uk>
	<20101222122904.GC14693@n2100.arm.linux.org.uk>
	<AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com>
	<20110103151944.GA32508@n2100.arm.linux.org.uk>
Date: Tue, 4 Jan 2011 09:41:02 +0900
Message-ID: <AANLkTik2_qFoT-CUhhWL6o5PN9m8RyE-R+0t1HUo9+oq@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 12:19 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> I've not decided whether it should be possible to resume an ETIMEOUT'd
> pause request (in theory with pl08x, that's just a matter of clearing
> the HALT bit) or whether an ETIMEOUT'd pause request should restore
> the previous HALT bit setting (possibly re-enabling transfers on the
> channel.)  Allowing it to be re-enabled in some way would be the safest
> thing in terms of data integrity for the reason mentioned in the
> "important note" above.

Not sure if every DMAC could resume cleanly from exact pause point.
Perhaps the upper layer of client driver should take care of that, just
like ALSA which emulates pause/resume if the 'optional' capability is
not advertised by the audio dma driver.
