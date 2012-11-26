Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2KZQaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:30:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:56491 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2KZQa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:30:28 -0500
Message-ID: <50B39921.6090308@linutronix.de>
Date: Mon, 26 Nov 2012 17:30:25 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
In-Reply-To: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 09:35 AM, Andrzej Pietrasiewicz wrote:
> In some parts of the kernel (e.g. planned configfs integration into usb
> gadget) there is a need to programmatically create config groups
> (directories) but it would be preferable to disallow creating them by
> the user. This is more or less what default_groups used to be for.
> But e.g. in the mass storage gadget, after storing the number of
> luns (logical units) into some configfs attribute, the corresponding lun#
> directories should be created, their number is not known up front so
> default_groups are no good for this.
>
> Example:
>
> $ echo 3>  /cfg/..../mass_storage/luns
>
> causes
>
> /cfg/....../mass_storage/lun0
> /cfg/....../mass_storage/lun1
> /cfg/....../mass_storage/lun2

I though we did not want the luns file but instead use

mkdir /cfg/....../mass_storage/lun0
mkdir /cfg/....../mass_storage/lun1

directly.

> to be created. Yet
>
> $ mkdir /cfg/..../mass_storage/<any name>
>
> should not be allowed.
>
> With create_group exported it is very easily achieved: make_group and make_item
> are set to NULL in mass_storage's config_group, yet the kernel can
> create_groups at will.
>
> I kindly ask for comments. In particular, I would like to discuss
> if this is the right approach. A counterpart to remove config groups
> is also required. It is not implemented in this patch, though. What are
> your opinions?

Could you please at the tcm gadget? This is a mass storage gadget using
target as backend and target is using configfs. Here is a snippet how
you setup it:

|mkdir -p $FABRIC/naa.6001405c3214b06a/tpgt_1
|mkdir $FABRIC/naa.6001405c3214b06a/tpgt_1/lun/lun_0
|mkdir $FABRIC/naa.6001405c3214b06a/tpgt_1/lun/lun_1

So you setup two luns without this patch. Would that work for you?

Sebastian
