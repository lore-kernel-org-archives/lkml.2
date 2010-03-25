Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab0CYPob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:44:31 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:45136 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab0CYPoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:44:30 -0400
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4BAB2937.6050703@panasas.com>
References: <4BAA3493.1030802@panasas.com>
	 <20100324160037.GP30031@ZenIV.linux.org.uk>	<4BAA3828.2070506@panasas.com>
	 <20100324160754.GQ30031@ZenIV.linux.org.uk>	<4BAA398C.5050901@panasas.com>
	 <20100324163948.GR30031@ZenIV.linux.org.uk>	<4BAA48A3.1030801@panasas.com>
	 <4BAA4CAC.6060104@panasas.com>  <4BAA5035.1060906@panasas.com>
	 <1269453756.5982.33.camel@localhost.localdomain>
	 <1269454208.5982.34.camel@localhost.localdomain>
	 <4BAB2937.6050703@panasas.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 11:44:22 -0400
Message-ID: <1269531862.3648.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 13 msgs/h 3 sum rcpts/h 17 sum msgs/h 4 total rcpts 2627 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 0752C37FA574AE7A211FC62568455209FBBF330C
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 3 total 262 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 11:13 +0200, Boaz Harrosh wrote: 
> On 03/24/2010 08:10 PM, Trond Myklebust wrote:
> > On Wed, 2010-03-24 at 14:02 -0400, Trond Myklebust wrote: 
> >> I'd say you have a corruption issue either on the server side or on your
> >> client.
> > 
> 
> It is surely a corruption on the client. I've tested with an old server
> and it fails just the same.

Yes, but we should not be seeing crap like that in the XDR decoding of a
revalidate request. I strongly suspect the server should be returning an
error here, probably NFS4ERR_BAD_HANDLE... After we fix the client side,
I'd like to take a look at the server and see why you are getting bogus
info for your GETATTR.

Trond



