Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1GRMXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:23:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:60603 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1GRMXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:23:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,222,1309762800"; 
   d="scan'208";a="28903203"
Subject: Re: [PATCH] net: can: remove custom hex_to_bin()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <201107182041.EHB78622.VOFSHFMOOFtLJQ@I-love.SAKURA.ne.jp>
References: <1310977597-9666-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <201107182041.EHB78622.VOFSHFMOOFtLJQ@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: Intel Finland Oy
Date: Mon, 18 Jul 2011 15:23:16 +0300
Message-ID: <1310991796.3903.6.camel@smile>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 20:41 +0900, Tetsuo Handa wrote: 
> Andy Shevchenko wrote:
> >  	for (i = 0, dlc_pos++; i < cf.can_dlc; i++) {
> > -
> > -		tmp = asc2nibble(sl->rbuff[dlc_pos++]);
> > -		if (tmp > 0x0F)
> > +		tmp = hex_to_bin(sl->rbuff[dlc_pos++]);
> > +		if (tmp < 0)
> >  			return;
> >  		cf.data[i] = (tmp << 4);
> > -		tmp = asc2nibble(sl->rbuff[dlc_pos++]);
> > -		if (tmp > 0x0F)
> > +		tmp = hex_to_bin(sl->rbuff[dlc_pos++]);
> > +		if (tmp < 0)
> >  			return;
> >  		cf.data[i] |= tmp;
> >  	}
> 
> What about changing
> 
>   void hex2bin(u8 *dst, const char *src, size_t count)
> 
> to
> 
>   bool hex2bin(u8 *dst, const char *src, size_t count)
> 
> in order to do error checks like
> 
> bool hex2bin_with_validation(u8 *dst, const char *src, size_t count)
> {
> 	while (count--) {
> 		int c = hex_to_bin(*src++);
> 		int d;
> 		if (c < 0)
> 			return false;
> 		d = hex_to_bin(*src++)
> 		if (d < 0)
> 			return false;
> 		*dst++ = (c << 4) | d;
> 	}
> 	return true;
> }
> 
> and use hex2bin() rather than hex_to_bin()?
Perhaps, good idea. Could you submit a patch?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
