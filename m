Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab0C1TgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 15:36:05 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:49477 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab0C1TgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 15:36:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NiH1zFWGCHMN/m+zH2fsIbfoDN91tA78NGHWCVnOhTIbOKOozJWWw8hmPXV0pJ1WLk
         aewMEgQJo+4c1ejv2Xf53NM0BbTjSYrt75TmyFuM0bUYTspU/4jJzLpMgM2ZMbrnkK1b
         VvxPcft6sFtDVFkwUhvI5tQBtFCBuLiXdRjYY=
Date: Sun, 28 Mar 2010 23:09:22 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Cc: apw@canonical.com, akpm@linux-foundation.org, dwalker@fifo99.com,
       joe@perches.com, linux-kernel@vger.kernel.org
Subject: Re: Checkpatch.pl false positive? "ERROR: return is not a
 function, parentheses are not required"
Message-ID: <20100328200922.GB27351@core2>
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

Yes, checkpatch.pl doesn't understand C.
