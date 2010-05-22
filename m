Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0EVOHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 10:07:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41451 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0EVOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 10:07:43 -0400
Date: Sat, 22 May 2010 15:07:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       phillip@lougher.demon.co.uk, alain@knaff.lu, hpa@zytor.com
Subject: Re: [PATCH]: bunzip2: Fix warning in get_next_block()
Message-ID: <20100522140741.GM31073@ZenIV.linux.org.uk>
References: <20100522135933.28675.17356.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100522135933.28675.17356.sendpatchset@prarit.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 10:04:07AM -0400, Prarit Bhargava wrote:
> Fix checkstack compile warning in get_next_block():
> 
> lib/decompress_bunzip2.c: In function `get_next_block':
> lib/decompress_bunzip2.c:511: warning: the frame size of 1920 bytes is larger than 1024 bytes
 
>  	int dbufCount, nextSym, dbufSize, groupCount, selector,
> -		i, j, k, t, runPos, symCount, symTotal, nSelectors,
> -		byteCount[256];
> -	unsigned char uc, symToByte[256], mtfSymbol[256], *selectors;
> +		i, j, k, t, runPos, symCount, symTotal, nSelectors;
> +	static int byteCount[256];
> +	unsigned char uc, *selectors;
> +	static unsigned char symToByte[256], mtfSymbol[256];
>  	unsigned int *dbuf, origPtr;

Um...  Some details might be useful, starting with "why can't that function
be called from several processes at once"...
