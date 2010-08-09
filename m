Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab0HIIwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:52:01 -0400
Received: from compulab.co.il ([67.18.134.219]:53275 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab0HIIv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:51:59 -0400
Message-ID: <4C5FC19D.6050100@compulab.co.il>
Date: Mon, 09 Aug 2010 11:51:41 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
Subject: Re: linux-next: build failure after merge of the mfd tree
References: <20100809114042.7beb076a.sfr@canb.auug.org.au>
In-Reply-To: <20100809114042.7beb076a.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/mfd/tps6586x.c: In function 'tps6586x_add_subdevs':
> drivers/mfd/tps6586x.c:272: error: dereferencing pointer to incomplete type
> drivers/mfd/tps6586x.c:273: error: dereferencing pointer to incomplete type
> drivers/mfd/tps6586x.c:275: error: dereferencing pointer to incomplete type
> drivers/mfd/tps6586x.c:275: error: dereferencing pointer to incomplete type
> drivers/mfd/tps6586x.c:278: error: dereferencing pointer to incomplete type
> drivers/mfd/tps6586x.c: In function 'tps6586x_i2c_probe':
> drivers/mfd/tps6586x.c:324: warning: passing argument 2 of 'tps6586x_add_subdevs' from incompatible pointer type
> drivers/mfd/tps6586x.c:265: note: expected 'struct tps6586x_platform_data *' but argument is of type 'struct tps6586x_platform_data *'
> drivers/mfd/tps6586x.c:330: error: dereferencing pointer to incomplete type
> 
> Caused by commit 8232c2794cf0e39b38d089eff49500461ecdbb8f ("mfd: Add
> TPS6586x driver").  "struct tps6586x_platform_data" is not defined
> anywhere ...

It seems to me that the include/linux/mfd/tps6586x.h was omitted from your 
commit to the mfd tree. Can you please check?

> I have used the mfd tree from next-20100807 for today.


-- 
Sincerely yours,
Mike.
