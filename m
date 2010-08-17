Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab0HQP0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:26:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:37238 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab0HQP0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:26:13 -0400
Message-ID: <4C6AA923.4040302@kernel.org>
Date: Tue, 17 Aug 2010 17:22:11 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: Jeff Garzik <jgarzik@pobox.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Linux IDE <linux-ide@vger.kernel.org>,
        Gwendal Grignou <gwendal@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.35 libata support for > 512 byte sectors (e.g. 4K
 Native)
References: <AANLkTikSSmP5f1csa=xPTR=EqY4D5a=6t2oDVkZ7cA-v@mail.gmail.com>	<CAC4B8726E86A142B27A9E9A2F2F12470149041A4E@rrsmsx505.amr.corp.intel.com>	<AANLkTik4RNvaE5OrFq3NmZ+-9DKhAAaNQ3cdPg38zOr2@mail.gmail.com>	<4C699455.6020200@pobox.com> <AANLkTi=R4GQGVE5AvU9hdWXdtqZzaOswrGQA+cPgO58W@mail.gmail.com>
In-Reply-To: <AANLkTi=R4GQGVE5AvU9hdWXdtqZzaOswrGQA+cPgO58W@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 17 Aug 2010 15:25:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/16/2010 10:24 PM, Grant Grundler wrote:
> I suspect legacy tools might be needed to update firmware and those
> might continue to function if DRQ block size is still 512 byte.  I'd
> like to leave this hardcoded to ATA_SECT_SIZE until someone can
> demonstrate a need to change it. Ok?

I agree it'll be best to leave it 512bytes.  We'll just cause more
confusion by overriding the sector size there.  Another possible
approach would be simply failing the ioctl if logical sector size
isn't 512 byte.  The ioctl should probably be deprecated one day
anyway.

Thanks.

-- 
tejun
