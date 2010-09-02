Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0IBNpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:45:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:38653 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0IBNpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:45:07 -0400
Date: Thu, 2 Sep 2010 14:44:57 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Cc: akpm@linux-foundation.org, dwalker@fifo99.com, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: Checkpatch.pl false positive? "ERROR: return is not a
 function, parentheses are not required"
Message-ID: <20100902134457.GS2406@shadowen.org>
References: <1269804493.7079.14.camel@tuxtm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269804493.7079.14.camel@tuxtm-linux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 10:28:13PM +0300, Olimpiu Pascariu wrote:
> Hi,
> 
> I've used checkpatch.pl to verify drivers/staging/dt3155/dt3155_isr.c,
> in order to provide a patch which fixes the errors and warnings found by
> checkpatch.
> The script returns the following error:
> ERROR: return is not a function, parentheses are not required
> #155: FILE: staging/dt3155/dt3155_isr.c:155:
> +  return (dt3155_fbuffer[m]->ready_head -
> 
> The original code is:
> 
>   return (dt3155_fbuffer[m]->ready_head -
>            dt3155_fbuffer[m]->ready_len +
>            dt3155_fbuffer[m]->nbuffers)%
>           (dt3155_fbuffer[m]->nbuffers);
> 
> I've deleted the the first open parenthesis and the last close
> parenthesis, and now the code looks like this:
> 
>   return (dt3155_fbuffer[m]->ready_head -
>            dt3155_fbuffer[m]->ready_len +
>            dt3155_fbuffer[m]->nbuffers)%
>           (dt3155_fbuffer[m]->nbuffers);
> 
> IMHO the code is correct, though an auxiliary variable could be used to
> avoid this error returned by checkpatch.pl. 

This code is indeed correct.  This is a bug in checkpatch, I think I
have sorted out the bug in the version below (which should be mirrored
out shortly).  If you could test the version below and let me know that
would be helpful:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
