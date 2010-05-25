Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab0EYO3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 10:29:53 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:50333 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758228Ab0EYO3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 10:29:52 -0400
Subject: Re: Deadlock in NFSv4 in all kernels
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "William A. (Andy) Adamson" <androsadamson@gmail.com>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       salvet@ics.muni.cz
In-Reply-To: <AANLkTimfHrXViu0Zm75i4cFED7pXqAvv2edmKRpIi4me@mail.gmail.com>
References: <20100507153920.GP28167@ics.muni.cz>
	 <AANLkTimsQTYWndbQo2nU01pcJfTRSZlPCMEY8m-CnksM@mail.gmail.com>
	 <20100525140240.GG9731@ics.muni.cz>
	 <AANLkTimfHrXViu0Zm75i4cFED7pXqAvv2edmKRpIi4me@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 10:29:45 -0400
Message-ID: <1274797785.5377.50.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-2.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 12 msgs/h 2 sum rcpts/h 21 sum msgs/h 3 total rcpts 374 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 27836CBC720C8C957E50346DF586333FE42F6748
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 176 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 10:10 -0400, William A. (Andy) Adamson wrote: 
> 2010/5/25 Lukas Hejtmanek <xhejtman@ics.muni.cz>:
> > On Tue, May 25, 2010 at 09:45:32AM -0400, William A. (Andy) Adamson wrote:
> >> Not get into the problem in the first place: this means
> >>
> >> 1) determine a 'lead time' where the NFS client declares a context
> >> expired even though it really as 'lead time' until it actually
> >> expires.
> >>
> >> 2) flush all writes on any contex that will expire within the lead
> >> time which needs to be long enough for flushes to take place.
> >
> > I think you cannot give any guarantees that the flush happens on time. There
> > can be server overload, network overload, anything and you are out of luck.
> 
> True - but this will be the case no matter what scheme is in place.
> The above is to handle the normal working situation. When this fails
> due to network, server overload, server reboot, i.e. not-normal
> situation, then use the machine credential.

Use of the machine credential also requires help from the rpc.gssd
daemon. It's not a solution to the deadlock Lukas is describing.

Trond

