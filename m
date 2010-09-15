Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab0IOV1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:27:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961Ab0IOV1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:27:50 -0400
Date: Wed, 15 Sep 2010 14:27:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] ihex: Add support for CS:IP/EIP records
Message-Id: <20100915142744.ee5bb928.akpm@linux-foundation.org>
In-Reply-To: <1284039626-30394-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1284039626-30394-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Sep 2010 14:40:26 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> +		data32 = &record->data[0];
> +		*data32 = htonl(*data32);

firmware/ihex2fw.c: In function 'process_ihex':
firmware/ihex2fw.c:231: warning: assignment from incompatible pointer type

And afacit data[] isn't 32-bit aligned and I don't know that all
architectures support htonl() against a misaligned pointer.

I'll drop the patch.
