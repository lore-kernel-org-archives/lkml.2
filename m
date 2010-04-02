Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab0DBPr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 11:47:58 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:54584 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0DBPrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 11:47:51 -0400
Date: Fri, 2 Apr 2010 11:47:50 -0400 (EDT)
From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: lm-sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org
Message-ID: <1779783481.621270223270264.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <2122967437.461270223106350.JavaMail.root@mail.savoirfairelinux.com>
Subject: regulator: regulator_get behaviour without CONFIG_REGULATOR set
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.88.110.46]
X-Mailer: Zimbra 5.0.19_GA_2995.UBUNTU8_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.19_GA_2995.UBUNTU8_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Working on drivers/hwmon/sht15.c, I noticed it would return bogus temperatures in my case, where CONFIG_REGULATOR is not set.

This is due to the following section in drivers/hwmon/sht15.c:

/* If a regulator is available, query what the supply voltage actually is!*/
        data->reg = regulator_get(data->dev, "vcc");
        if (!IS_ERR(data->reg)) {
            ...

Looking at consumer.h, it appears that regulator_get() returns a pointer to its second argument when CONFIG_REGULATOR is not set.

What would be the proper way to determine if the returned value is a valid regulator ?
Would it be safe to check it against the 2nd argument ?

Regards
Jerome Oufella
