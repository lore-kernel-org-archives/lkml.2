Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1LMJus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:50:48 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39256 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1LMJuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:50:46 -0500
Date: Tue, 13 Dec 2011 09:50:41 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Joe Perches <joe@perches.com>
Cc: roel <roel.kluin@gmail.com>, Jamie Iles <jamie@jamieiles.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>
Subject: Re: drivers/crypto/picoxcell_crypto.c: boolean and / or confusion
Message-ID: <20111213095041.GA2496@totoro>
References: <4EE688FC.8090606@gmail.com>
 <1323733493.1812.10.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323733493.1812.10.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Mon, Dec 12, 2011 at 03:44:53PM -0800, Joe Perches wrote:
> On Tue, 2011-12-13 at 00:06 +0100, roel wrote:
> > The test not [val1] or not [val2] always evaluates to true
> 
> Hey Jamie and Roel
> 
> Looking at drivers with:
> 
> $ grep -rP --include=*.[ch] "(\b[\w\[\]\>\._\-]+)\s*\!\=\s*[\w\[\]\>\._\-]+\s*\|\|\s*\1\s*\!\=" drivers
> 
> drivers/crypto/picoxcell_crypto.c:	if ((len != AES_KEYSIZE_128 || len != AES_KEYSIZE_256) &&
> drivers/crypto/picoxcell_crypto.c:	} else if ((len != AES_KEYSIZE_128 || len != AES_KEYSIZE_256) &&
> 
> Most likely these should be && not ||.

Yup, the original code was incorrect.  Patch to follow.  Thanks Joe!

Jamie
