Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668Ab0EDNNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:13:54 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:35122 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab0EDNNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:13:52 -0400
Subject: Re: [patch] sunrpc: add missing return statement
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jw@emlix.com, davem@davemloft.net, batsakis@netapp.com,
       linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <201005042203.DAJ09881.tFQOJFHSOLVOMF@I-love.SAKURA.ne.jp>
References: <20100504115759.266396633@emlix.com>
	 <1272976042.7559.24.camel@localhost.localdomain>
	 <201005042203.DAJ09881.tFQOJFHSOLVOMF@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 09:13:35 -0400
Message-ID: <1272978815.7559.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 7 msgs/h 1 sum rcpts/h 10 sum msgs/h 2 total rcpts 174 max rcpts/h 14 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: ED21DFA9359FA562DFCC953C4345EDA4A5C7DDEE
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 88 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 22:03 +0900, Tetsuo Handa wrote: 
> Trond Myklebust wrote:
> > On Tue, 2010-05-04 at 13:59 +0200, Johannes Weiner wrote: 
> > > f300bab "nfsd41: sunrpc: add new xprt class for nfsv4.1 backchannel"
> > > introduced an error case branch that lacks an actual `return' keyword
> > > before the return value.  Add it.
> > > 
> > > Signed-off-by: Johannes Weiner <jw@emlix.com>
> > > Cc: Alexandros Batsakis <batsakis@netapp.com>
> > > ---
> > >  net/sunrpc/xprtsock.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > --- a/net/sunrpc/xprtsock.c
> > > +++ b/net/sunrpc/xprtsock.c
> > > @@ -2444,7 +2444,7 @@ static struct rpc_xprt *xs_setup_bc_tcp(
> > >  	struct svc_sock *bc_sock;
> > >  
> > >  	if (!args->bc_xprt)
> > > -		ERR_PTR(-EINVAL);
> > > +		return ERR_PTR(-EINVAL);
> > >  
> > >  	xprt = xs_setup_xprt(args, xprt_tcp_slot_table_entries);
> > >  	if (IS_ERR(xprt))
> > 
> > No. It should either be a BUG_ON(), or else be removed entirely.
> > Returning an error value for something that is clearly a programming bug
> > is not a particularly useful exercise...
> > 
> Removing NULL check is wrong because it will NULL pointer dereference later.

Wrong. Removing NULL check is _right_ because calling this function
without setting up a back channel first is a major BUG. Returning an
error value to the user is pointless, since the user has no control over
this. It is entirely under control of the sunrpc developers...

Trond

