Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0FONO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:14:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51462 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751943Ab0FONOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:14:54 -0400
Date: Tue, 15 Jun 2010 14:14:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Liam Girdwood'" <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, sameo@linux.intel.com
Subject: Re: [PATCH v2] drivers: regulator: add Maxim 8998 driver
Message-ID: <20100615131452.GF14510@rakim.wolfsonmicro.main>
References: <1276603388-8022-1-git-send-email-m.szyprowski@samsung.com>
 <20100615121226.GE14510@rakim.wolfsonmicro.main>
 <00d801cb0c87$aae7b020$00b71060$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00d801cb0c87$aae7b020$00b71060$%szyprowski@samsung.com>
X-Cookie: Keep on keepin' on.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 02:38:26PM +0200, Marek Szyprowski wrote:

> Are global exports preferred over the callbacks? I saw both in different
> MFD drivers and was not sure which one to use.

> I've selected callbacks, because they are a bit nicer and don't pollute
> the name space for each single driver. In my opinion the cost of these
> 3 max8998_reg_{read,write,update} inline functions in regulator/max8998.c
> is not so significant.

The dereferences looked fairly painful reading the code.  You can always
do the global stuff as static inlines in the header file which avoids
namespace pollution while keeping the code looking like a function call.
