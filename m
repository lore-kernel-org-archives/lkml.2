Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0IDNIC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 09:08:02 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35715 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0IDNIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 09:08:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=kYm5hex44VmG1leuniWA+iI0Q9FZy1ZsLx9IeuEXthV6YzcQfCG/19ZPArgwQ2itUK
         dpfg0zUacBEuv871BxdVjvxqOUb23KH5kpA8ofbiI3vFDpG17ZFL7m4OqodeOwm9v5q2
         iYkeMmsIIe0QAymtfNrxe9pcDvF0iXnpLtTzg=
Message-ID: <4C8244AD.6090900@gmail.com>
Date: Sat, 04 Sep 2010 15:07:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: lrg@slimlogic.co.uk
CC: alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>
Subject: tlv320aic3x: potential null dereference
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

stanse found a potential null dereference:
aic3x_i2c_probe
  -> struct aic3x_setup_data *setup = pdata->setup;
  -> -- pdata can't be null now--
  -> if (pdata && pdata->gpio_reset >= 0)

But there is another check for pdata == NULL. Could take a look and fix
it (either remove the check or move the assignement inside the if)?

thanks,
-- 
js
