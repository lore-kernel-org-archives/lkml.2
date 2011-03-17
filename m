Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1CQXAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:00:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab1CQXAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:00:53 -0400
Date: Thu, 17 Mar 2011 19:00:12 -0400
From: "J. Bruce Fields" <bfields@redhat.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: Greg KH <gregkh@suse.de>, alan@lxorguk.ukuu.org.uk,
        Roel Kluin <roel.kluin@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [14/17] nfsd: wrong index used in inner loop
Message-ID: <20110317230012.GA4072@pad.home.fieldses.org>
References: <20110311204110.753145113@clark.kroah.org>
 <4D7AA086.3030500@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7AA086.3030500@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 10:21:58PM +0000, Tim Gardner wrote:
> On 03/11/2011 08:40 PM, Greg KH wrote:
> >2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> >
> >------------------
> >
> >From: roel<roel.kluin@gmail.com>
> >
> >commit 3ec07aa9522e3d5e9d5ede7bef946756e623a0a0 upstream.
> >
> >Index i was already used in the outer loop
> >
> >Signed-off-by: Roel Kluin<roel.kluin@gmail.com>
> >Signed-off-by: J. Bruce Fields<bfields@redhat.com>
> >Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
> >
> >---
> >  fs/nfsd/nfs4xdr.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> >--- a/fs/nfsd/nfs4xdr.c
> >+++ b/fs/nfsd/nfs4xdr.c
> >@@ -1114,7 +1114,7 @@ nfsd4_decode_create_session(struct nfsd4
> >
> >  	u32 dummy;
> >  	char *machine_name;
> >-	int i;
> >+	int i, j;
> >  	int nr_secflavs;
> >
> >  	READ_BUF(16);
> >@@ -1187,7 +1187,7 @@ nfsd4_decode_create_session(struct nfsd4
> >  			READ_BUF(4);
> >  			READ32(dummy);
> >  			READ_BUF(dummy * 4);
> >-			for (i = 0; i<  dummy; ++i)
> >+			for (j = 0; j<  dummy; ++j)
> >  				READ32(dummy);
> >  			break;
> >  		case RPC_AUTH_GSS:
> >
> >
> >--
> 
> I agree that fixing the index in this loop is a good thing, but its
> caused me to look at the result:
> 
> for (j = 0; j<  dummy; ++j)
> 	READ32(dummy);
> 
> It seems to me that this loop might never terminate if the original
> buffer is maliciously constructed, e.g., 0, 1, 2, 3, ... Is the data
> in this buffer really that well vetted?

Agreed, the code's still clearly bogus.  In fact, we can just delete
that loop entirely; I have a patch queued up to send to Linus soon.

(But go ahead and apply this anyway, and then you'll get the followup
patch when it lands.)

--b.
