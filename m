Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936467Ab0COPeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:34:20 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:41971 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab0COPeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:34:17 -0400
X-Greylist: delayed 1950 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 11:34:17 EDT
Message-ID: <4B9E4BD7.1000104@grupopie.com>
Date: Mon, 15 Mar 2010 15:01:43 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Andrew <nick@nick-andrew.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] vsprintf.c: remove stack variable ksym from
References: <cover.1267682641.git.joe@perches.com>	 <alpine.LFD.2.00.1003041504080.3751@localhost.localdomain>	 <1267911399.849.39.camel@Joe-Laptop.home>	 <alpine.LFD.2.00.1003061356420.31447@localhost.localdomain>	 <1267914654.849.81.camel@Joe-Laptop.home>	 <alpine.LFD.2.00.1003061445490.31447@localhost.localdomain>	 <alpine.LFD.2.00.1003061455590.31447@localhost.localdomain>	 <1267918554.849.89.camel@Joe-Laptop.home>	 <alpine.LFD.2.00.1003061540470.23804@localhost.localdomain>	 <alpine.LFD.2.00.1003061547490.23804@localhost.localdomain>	 <alpine.LFD.2.00.1003061556420.23804@localhost.localdomain>	 <1267924214.1937.12.camel@Joe-Laptop.home>	 <alpine.LFD.2.00.1003061755400.23804@localhost.localdomain>	 <1267929215.1937.18.camel@Joe-Laptop.home>	 <20100312162559.a8e51777.akpm@linux-foundation.org>	 <alpine.LFD.2.00.1003130734420.3719@i5.linux-foundation.org>	 <1268502295.30289.44.camel@Joe-Laptop.home> <1268510079.30289.69.camel@Joe-Laptop.home>
In-Reply-To: <1268510079.30289.69.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Sat, 2010-03-13 at 09:44 -0800, Joe Perches wrote:
>> On Sat, 2010-03-13 at 07:35 -0800, Linus Torvalds wrote:
>>> On Fri, 12 Mar 2010, Andrew Morton wrote:
>>>> nice.
>>> But the kallsyms_lookup()/sprint_symbol() functions don't take a 
>>> length parameter, so we have to do the worst-case thing (which itself has 
>>> tons of unnecessary padding).
>> Perhaps a new snprint_symbol function with the
>> other kallsyms... functions changed as necessary.
> 
> Perhaps something like this:

Just one minor nit:

[...]
>  
> -	*result = '\0';
> +	if (size)
> +		*result = '\0';

This test seems to be here to handle the "size == 0" case, but

>[...]
> +const char *kallsyms_lookup_n(unsigned long addr,
> +			      unsigned long *symbolsize,
> +			      unsigned long *offset,
> +			      char **modname, char *namebuf, size_t size)
> +{
> +	if (size)
> +		namebuf[size - 1] = 0;
> +	namebuf[0] = 0;

here we seem to write the namebuf[0] even if "size == 0". So maybe both
assignments in this function should be inside the "if (size)" test.

Other than that, the patch looks good:

Reviewed-by: Paulo Marques <pmarques@grupopie.com>

-- 
Paulo Marques - www.grupopie.com

"As far as we know, our computer has never had an undetected error."
Weisert
