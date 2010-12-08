Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab0LHBy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:54:57 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:54434 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab0LHByw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:54:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rmILIPwMYtltHaXhr4idW98WuI9OsIhBRkn1AB/+J8qf12FODQJryLKzJt78avbc30
         zl9u2pmJrfVyado/zDqkp5SzfGYarl6S6CETexp3TD9AslZf8F2wzedZilmKhDu3pnLB
         TbrDtPWIm1e4zP6RQvk1F3XOztrF2Fk+t5DJw=
Message-ID: <4CFEE569.4030204@gmail.com>
Date: Tue, 07 Dec 2010 19:54:49 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jian Peng <jipeng@broadcom.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        ide <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: questions regarding possible violation of AHCI spec in AHCI driver
References: <E18F441196CA634DB8E1F1C56A50A874319F70C1F2@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <E18F441196CA634DB8E1F1C56A50A874319F70C1F2@IRVEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing linux-ide and Tejun.

On 12/07/2010 01:43 AM, Jian Peng wrote:
> Recently, while bringing up a new AHCI host controller, I found out that current AHCI driver (in 2.6.37-rc3) may violate AHCI spec in function libahci.c: ahci_start_engine().
>
>  From end of section 10.1.2 in AHCI 1.3 spec, it claims
>
> Software shall not set PxCMD.ST to '1' until it is determined that a functional device is present on the port
> as determined by PxTFD.STS.BSY = '0', PxTFD.STS.DRQ = '0', and PxSSTS.DET = 3h.
>
> It seems working well on most controller without this extra checking, but does cause problem in our new core. Since toggling PxCMD.SUD already initiated reset process at early time, and by the time of ahci_start_engine() got called, BSY bit may not be cleared yet, and forcing PxCMD.ST bit to 1 will cause problem for HW in this case.
>
> Since I do not know all history about AHCI driver, I really hope that AHCI driver and libata maintainer can comment on this.

Seems like a valid point to me, according to the spec. I'm guessing it 
just hasn't come up previously with other controllers?
