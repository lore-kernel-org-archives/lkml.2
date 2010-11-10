Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab0KJGQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 01:16:28 -0500
Received: from nm5-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.204]:38878 "HELO
	nm5-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751997Ab0KJGQ0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 01:16:26 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 471709.33651.bm@omp1052.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=B3LlQ4sfBRHb4y9TjUREcM7G4Uuz+B6J+B1rTe9dzSghV+0yhu5ZOs7bqPHgXCn8wn781GVa+hTuh0Wxtr5JBR73pAWW8jjOdruoK2sZSyaseiCEiYnyBlQ4N4f0b7FtI9WDVRnRL0a3mjZEHidf2kQyDXVZeNaxLBR5bOR3erA=;
Message-ID: <79124.87409.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: ppeiUucVM1njS8ZAcsDaWXYfPDQcnoKAPQBVKiKLfltOMBJ
 ciV7_MBl7Dnu.vSpkC2wFhrDUlCNnx8yRaLpCA.W8Km7g6u_YuZKESch2bdi
 pTxZry3x3uAy6tP44C6axpYqxFrnCXzDaqHoNULpFBDNiyoPo2urCDbuLlfi
 m.G_k2k56Wqf0wig89xtNlbf3dkol3DOa_2afH6lO_7fy4WXnNKE8ZwVkq1R
 fqAhdA8dyT4asYeGpEDKcHZBvX5wHZ0BuP_VWEv6cldZBt.cKLSZ0L9O..Cl
 EtIhew4RBXyl83m3KifM1Thf4vbsHDRWkRd9TAPwsK0id2QNzLhl4r44-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Tue, 9 Nov 2010 22:16:22 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4 08/12] gpio: add ti-ssp gpio driver
To: Grant Likely <grant.likely@secretlab.ca>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, Cyril Chemparathy <cyril@ti.com>,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, lrg@slimlogic.co.uk
In-Reply-To: <20101110044530.GB4110@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I thought the point of this device was that a single [SSP] device
> hosted a
> pair of multi-function serial interfaces, with each
> implementing a
> separate function.

function chosen based on what the board needs.
Codec interface, SPI, GPIO, etc.

  If so, then it makes sense for the
> base driver to
> register child devices of the appropriate kinds.

I'd normally say board setup registers them; a
"core"driver can't know what children would be needed.

But the point I was making was about code factoring
not driver setup.  When  the functions don't have
much commonality, they might as well just write to
the relevant registers instead of expecting to have
a non-register programming interface (of dubious
generality of a "core" driver, but much complexity).

Easier just to have children use registers directly,
in several similar cases.  Less overhead, too.

- Dave

