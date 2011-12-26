Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1LZMS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 07:18:59 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:11235 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192Ab1LZMS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 07:18:57 -0500
X-IronPort-AV: E=Sophos;i="4.71,410,1320620400"; 
   d="scan'208";a="136879539"
Date: Mon, 26 Dec 2011 13:18:54 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Samuel Ortiz <sameo@linux.intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] drivers/mfd/88pm860x-i2c.c: introduce missing
 kfree
In-Reply-To: <20111226120855.GB17760@sirena.org.uk>
Message-ID: <alpine.DEB.2.02.1112261318050.1873@localhost6.localdomain6>
References: <1324661974-17281-1-git-send-email-julia@diku.dk> <20111226120855.GB17760@sirena.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Dec 2011, Mark Brown wrote:

> On Fri, Dec 23, 2011 at 06:39:26PM +0100, Julia Lawall wrote:
>> Error handling code following a kzalloc should free the allocated data.  At
>> this point, chip has been allocated and some fields have been initialized,
>> but it has not been stored anywhere, so it should be freed before leaving
>> the function.
>
> With this and probably a bunch of the other corrections in this series a
> conversion to devm_kazlloc() would be a more complete fix as it prevents
> people introducing similar missing cleanup paths in future.  Not sure if
> spatch can generate that automatically though...

I saw a patch for that recently, and looked into it a little bit, but I 
wasn't sure what should be done.  What are the criteria for using 
devm_kzalloc?

julia
