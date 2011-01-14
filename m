Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1ANLoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 06:44:05 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34498 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab1ANLn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 06:43:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=d3HfJCq5HreeNSOpW4r+xLO1x2LPXEX8rV4CE1U93ZFqsHQgjT/I4oNzHmnCtlR1my
         UcNRE1HtjGEqk5nH+skc4Ajh/V0XnE/4MSBFP/xphXVlbL8W7XrBvrzj5C20Y5Tv9tV8
         Vd+h83nejbi5di8oA9nsnWMTmCl1RKPBCX/J8=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Hong Xu <hong.xu@atmel.com>
Cc: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com
Subject: Re: [PATCH] MTD: atmel_nand: Add DMA support to access Nandflash
References: <1294997687-12515-1-git-send-email-hong.xu@atmel.com>
Date: Fri, 14 Jan 2011 12:43:52 +0100
In-Reply-To: <1294997687-12515-1-git-send-email-hong.xu@atmel.com> (Hong Xu's
	message of "Fri, 14 Jan 2011 17:34:47 +0800")
Message-ID: <878vynww07.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Hong" == Hong Xu <hong.xu@atmel.com> writes:

 Hong> Some SAM9 chips have the ability to perform DMA between CPU and
 Hong> SMC controller.  This patch adds DMA support for SAM9RL, SAM9G45,
 Hong> SSAM9G46,AM9M10, SAM9M11.

 Hong> Signed-off-by: Hong Xu <hong.xu@atmel.com>

But mtd buffers are not guaranteed to be DMA safe (E.G. might come from
vmalloc), so you'll need to walk the page tables.

-- 
Bye, Peter Korsgaard
