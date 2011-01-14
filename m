Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab1ANWef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:34:35 -0500
Received: from nm15.bullet.mail.sp2.yahoo.com ([98.139.91.85]:23757 "HELO
	nm15.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751431Ab1ANWee convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:34:34 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 14209.3320.bm@omp1024.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=5VK4RMmoCVtgy993z9XgRqLvmZH3oGAnyc3pnv1xzzYaGWUogzWSHj4sdxqjsGK8CR3qcEbYOQCQpjv44YRnbjCPYhTm0qkN3jOuVpaYrdsdnnLAZhdZLEtBvI+iqKHc00l7TJxspLL+2iLqNgUfJ5WA5RwnBtyNfdoZSIZ+DIg=;
Message-ID: <605049.78283.qm@web180310.mail.gq1.yahoo.com>
X-YMail-OSG: fZoW7lIVM1lhayRIeGoH9e.EtqMqkrgjaXXNPJbsxfoTcHn
 vwgMYkUn.8w0u6fai7bMRbVuZvmqs9diL3mBE7zanbJdP5dQEFGFbLrkBItM
 dJEBqG5O6pSmUMTAMxN3C7Tox.zyiP005jVgy0dys2EeWHEoLvexBrfyKrMy
 7mdrqEd9P_ZCbfHWpH__s6og9J3eu_bp3xJ2BRwJPAtlJbKONBsWpZ1rv6tH
 o2LIJB3vOvFu7up6Ta85WhbXynJsXlXih6RUjRGVP4JCzbxB2XF1u7et0Ocp
 JGqEzOwXWRELxZx0wlzy86ipgcRzbyPdxy88a_MBgS2UxjkNb9URrG.JqARL
 svpyyNQoLZULyyIuumginW5uFzO3bKofxEokrLyU29CMw6pTdKb7JilRueJZ
 ENOtYHc3XqWs-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Fri, 14 Jan 2011 14:34:33 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] mtd: sst25l: fix reads with broken spi-masters
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        David Woodhouse <dwmw2@infradead.org>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>
In-Reply-To: <20110114222401.GA10504@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 1/14/11, Grant Likely <grant.likely@secretlab.ca> wrote:

> > The bug _is_ in the spi peripheral on the ep93xx.
> > 

> 
> No, David is correct.  The fault is in the master
> driver.  It is perfectly valid (and common) for spi
> peripherals to required the SS line to remain asserted over
> the entire transfer. 

And that's what the Linux SPI stack requires,
so any master driver that doesn't keep the
slave selected during the entiretransfer is buggy.
