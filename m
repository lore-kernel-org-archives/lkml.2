Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab1EFT5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:57:49 -0400
Received: from dee.erg.abdn.ac.uk ([139.133.204.82]:58845 "EHLO erg.abdn.ac.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932160Ab1EFT5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:57:47 -0400
Date: Fri, 6 May 2011 21:57:33 +0200
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: davem@davemloft.net, dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] dccp: handle invalid feature options length
Message-ID: <20110506195733.GA3527@gerrit.erg.abdn.ac.uk>
Mail-Followup-To: Gerrit Renker <gerrit@erg.abdn.ac.uk>,
	Dan Rosenberg <drosenberg@vsecurity.com>, davem@davemloft.net,
	dccp@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, security@kernel.org
References: <1304688438.29544.16.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304688438.29544.16.camel@dan>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ERG-MailScanner: Found to be clean
X-ERG-MailScanner-From: gerrit@erg.abdn.ac.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dan Rosenberg:
| A length of zero (after subtracting two for the type and len fields) for
| the DCCPO_{CHANGE,CONFIRM}_{L,R} options will cause an underflow due to
| the subtraction.  The subsequent code may read past the end of the
| options value buffer when parsing.  I'm unsure of what the consequences
| of this might be, but it's probably not good.
| 
Please disregard my earlier message, I erred.
Dan is right, his patch is correct and definitively valid.
A length of 0 would be cast to 0xff and then cause buffer overrun.

| Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
| Cc: stable@kernel.org
Acked-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
