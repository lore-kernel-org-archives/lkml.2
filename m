Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab1GRKvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 06:51:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39452 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753310Ab1GRKvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 06:51:01 -0400
Date: Mon, 18 Jul 2011 19:50:54 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg KH <greg@kroah.com>, Grant Likely <grant@secretlab.ca>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] regmap: Add generic non-memory mapped register
 access API
Message-ID: <20110718105053.GD7775@opensource.wolfsonmicro.com>
References: <20110718100444.GD423@opensource.wolfsonmicro.com>
 <1310983663-6404-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <s5hsjq3kh61.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hsjq3kh61.wl%tiwai@suse.de>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 12:38:14PM +0200, Takashi Iwai wrote:

> In most cases, val = map->work_buf + map->format.reg_bytes.
> How about a bit optimization?

> 	if (ret == -ENOTSUPP) {

Indeed, I'd had an additional optimization there in mind but it was to
do the checking before we try the gather write rather than after since
generally it'll be cheaper to do the pre-gathered write than the
gathered write (sometimes noticably cheaper as some controllers have an
appreciable overhead for starting transfers, especially at high data
rates).

I mostly didn't implement it yet because I was trying to minimize the
code complexity of the initial submission in order to aid review so was
avoiding non-essential features.
