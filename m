Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0IDLv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 07:51:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61380 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0IDLvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 07:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=m8+pIAemvvsERGafjzrHhiT45dr+XU6ivaCaQLYam8f3bTPX3vu9DG4m4s5XVrjcaE
         k62qdJuqAYxwTOmLpfKnWu1hNtk7YzMY6fDzpNFdDzE8A1nqbHUTdYhgGK1klhRBzJQU
         L/I5lDCdAGYha3KXqMeRB2+yqCQnjYS9s7FQ4=
Message-ID: <4C8232B9.2020005@gmail.com>
Date: Sat, 04 Sep 2010 13:51:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: fenghua.yu@intel.com
CC: "Brown, Len" <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: pkgtemp: double lock
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

stanse found that you double lock pdev_list_mutex:
  -> pkgtemp_device_remove
    -> mutex_lock(&pdev_list_mutex);
    -> pkgtemp_device_add
      -> mutex_lock(&pdev_list_mutex);

Could you fix that?

regards,
-- 
js
