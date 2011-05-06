Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab1EFUFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:05:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40147
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185Ab1EFUFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:05:20 -0400
Date: Fri, 06 May 2011 13:04:47 -0700 (PDT)
Message-Id: <20110506.130447.183054252.davem@davemloft.net>
To: gerrit@erg.abdn.ac.uk
Cc: drosenberg@vsecurity.com, dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] dccp: handle invalid feature options length
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110506195733.GA3527@gerrit.erg.abdn.ac.uk>
References: <1304688438.29544.16.camel@dan>
	<20110506195733.GA3527@gerrit.erg.abdn.ac.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Date: Fri, 6 May 2011 21:57:33 +0200

> Quoting Dan Rosenberg:
> | A length of zero (after subtracting two for the type and len fields) for
> | the DCCPO_{CHANGE,CONFIRM}_{L,R} options will cause an underflow due to
> | the subtraction.  The subsequent code may read past the end of the
> | options value buffer when parsing.  I'm unsure of what the consequences
> | of this might be, but it's probably not good.
> | 
> Please disregard my earlier message, I erred.
> Dan is right, his patch is correct and definitively valid.
> A length of 0 would be cast to 0xff and then cause buffer overrun.
> 
> | Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> | Cc: stable@kernel.org
> Acked-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>

Great, I'll apply this, thanks!
