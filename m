Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab2LQU7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:59:03 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54056 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752571Ab2LQU7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:59:01 -0500
Message-ID: <1355777940.19706.11.camel@joe-AO722>
Subject: Re: [PATCH 1/2] MCE, AMD: Make MC2 decoding part of amd_decoder_ops
 as well
From: Joe Perches <joe@perches.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Dec 2012 12:59:00 -0800
In-Reply-To: <20121217204317.GA32760@jshin-Toonie>
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
	 <1355774221.13361.48.camel@joe-AO722> <20121217200535.GF31866@liondog.tnic>
	 <1355775376.19706.1.camel@joe-AO722> <20121217202214.GG31866@liondog.tnic>
	 <1355776475.19706.6.camel@joe-AO722> <20121217204011.GH31866@liondog.tnic>
	 <20121217204317.GA32760@jshin-Toonie>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-17 at 14:43 -0600, Jacob Shin wrote:
> On Mon, Dec 17, 2012 at 09:40:11PM +0100, Borislav Petkov wrote:
> > On Mon, Dec 17, 2012 at 12:34:35PM -0800, Joe Perches wrote:
> > > decode_mc2_mce does
> > > 
> > > 	pr_emerg(HW_ERR "MC2 Error: ");
> > > calls
> > > 	fam_ops->mc2_mce()
> > > which may not emit anything
> > > and if it doesn't, does
> > > 	pr_emerg(HW_ERR "Corrupted ...");
> > > on another line leaving a trailing colon without
> > > newline from the pr_emerg above.
> > 
> > Ok, this is in Jacob's patch AFAICT, I'll review those tomorrow but
> > thanks for the heads-up.
> 
> Okay, I'll wait until your feedback before sending V2
> 
> > 
> > > I believe the second pr_emerg should be pr_cont
> > 
> > Actually, it should be
> > 
> > pr_emerg(HW_ERR "\nCorrupted...\n");
> > 
> > to finish the initial pr_emerg.
> 
> Okay, all of the other decode_mc*_mce functions needs to change then.

Hi Jacob.

I don't think that's necessary.

Using any pr_<level>("\n...") is just not good form.
I think the pr_cont would be fine, it's the same
form as all the other decoded continuations.

The new pr_emerg is effectively a termination of the
previous one.  There's no need for 2 consecutive uses
of pr_emerg(HW_ERR ...) here.

cheers, Joe

