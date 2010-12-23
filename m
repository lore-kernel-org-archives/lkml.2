Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab0LWJOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 04:14:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64379 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0LWJO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 04:14:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dgcpCzou7G2ZW4fkvqB1CzXfL0HiJjM/XPxFs5PDg/rDdlZjkDMW9hwQn2J1KavRFn
         iId87uGGI77MSMqnP74q9LSE0vi1MKI0oZjlqbRc0B39FBrXgjkrnDjxr6sB9QU3zIxW
         ReAmAhAZki5no7vlvC7UOp8/cfonOC+U3Hjsk=
Subject: Re: [PATCH] tcp: cleanup of cwnd initialization in
 tcp_init_metrics()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
        Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
In-Reply-To: <alpine.LNX.2.00.1012231002310.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012221938030.16569@pobox.suse.cz>
	 <1293092671.2679.44.camel@edumazet-laptop>
	 <alpine.LNX.2.00.1012231002310.16569@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 10:14:23 +0100
Message-ID: <1293095663.7789.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 23 décembre 2010 à 10:03 +0100, Jiri Kosina a écrit :
> On Thu, 23 Dec 2010, Eric Dumazet wrote:
> 
> > Le mercredi 22 décembre 2010 à 19:39 +0100, Jiri Kosina a écrit :
> > > Commit 86bcebafc5e7f5 ("tcp: fix >2 iw selection") fixed a case when 
> > > congestion window initialization has been mistakenly omitted by 
> > > introducing cwnd label and putting backwards jump from the end of the 
> > > function.
> > > 
> > > This makes the code unnecessarily tricky to read and understand on a first 
> > > sight.
> > > 
> > > Shuffle the code around a little bit to make it more obvious.
> > 
> > Well in fine you have
> > 
> > 	if (inet_csk(sk)->icsk_rto < TCP_TIMEOUT_INIT && !tp->rx_opt.saw_tstamp)
> > 		goto reset;
> > 	goto out;
> > reset:
> > 
> > Is that really more obvious ? ;)
> 
> To me it seems much more obvious than goto from the very end of the 
> function somewhere into the middle and returning from there, but 
> definitely a matter of personal taste.
> 

You dont understand what I said. Please read again.

To me I prefer you _finish_ the cleanup so that we have :

	if (some condition) {
reset:
	}

out:

You remove two "goto" in the process.

Is that clear now ?



