Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab1HKEgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 00:36:40 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:47925 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944Ab1HKEgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 00:36:38 -0400
Message-ID: <4E435C53.6080701@dsn.okisemi.com>
Date: Thu, 11 Aug 2011 13:36:35 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
CC: "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
Subject: mtd/m25p80: Device search issue
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question.
We've faced issue when connecting SPI Flash memory "SST25VF016B" via
SPI_TOPCLIFF_PCH, the Flash is not detected.
The cause is that jedec_probe fails in m25p80.


m25p80.c
static const struct spi_device_id *__devinit jedec_probe(struct
spi_device *spi)
{

...

	jedec = id[0];
	jedec = jedec << 8;
	jedec |= id[1];
	jedec = jedec << 8;
	jedec |= id[2];

...

After the above calculation,
jedec becomes "bf25".

I think jedec must be "bf2541", right ?
Let me know what's wrong?

Thanks in advance.
-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
