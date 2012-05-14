Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab2ENQN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:13:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50211 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab2ENQNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:13:23 -0400
Date: Mon, 14 May 2012 09:13:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@opensource.wolfsonmicro.com, thomas.abraham@linaro.org,
        grant.likely@secretlab.ca, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Extcon: MAX8997: Add support irq domain for
 MAX8997 muic
Message-ID: <20120514161319.GA21735@kroah.com>
References: <1336698621-10907-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336698621-10907-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 10:10:21AM +0900, Chanwoo Choi wrote:
> This patch add support irq domain for Maxim MAX8997 muic
> instead of irq_base in platform data and max8997 driver
> private data are instead. It is tested on TRATS board.
> 
> v2
> - Fix typo when free_irq() in max8997_muic_probe()
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c |   28 +++++++++++++++++-----------
>  1 files changed, 17 insertions(+), 11 deletions(-)

This patch breaks the build on my system:

  CC [M]  drivers/extcon/extcon-max8997.o
drivers/extcon/extcon-max8997.c: In function ‘max8997_muic_probe’:
drivers/extcon/extcon-max8997.c:456:3: error: implicit declaration of function ‘irq_create_mapping’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

So I can't accept these two patches, sorry.  Please fix this up.

greg k-h
