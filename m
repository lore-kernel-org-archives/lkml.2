Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2DBSvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:51:12 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:53041 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab2DBSvK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:51:10 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 95.21.41.4
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18TfNdzHRFbEa74Cthx0/Il
Date: Mon, 2 Apr 2012 20:50:57 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Shea Levy <shea@shealevy.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hang opening a pipe written to by a child, with SIGCHLD
Message-ID: <20120402185057.GB3029@vicerveza.homeunix.net>
References: <20120402144611.GY3029@vicerveza.homeunix.net>
 <4F79BC66.3010902@shealevy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4F79BC66.3010902@shealevy.com>
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 10:49:10AM -0400, Shea Levy wrote:
> On 04/02/2012 10:46 AM, Lluís Batlle i Rossell wrote:
> >Can anyone reproduce this?
> 
> I've reproduced this on my system as well (3.3). No idea about cause though.
> 

Thank you Shea,

with a little change, adding "sleep 0.1" makes it hang early in all (few)
linuces I tried: Let me know if this helps you reproduce the problem.

As before, hangs under strace, does not hang under 'strace -f'. Sorry if I'm
misunderstanding something.

New script:
----------
#!/bin/sh
                                                                                                                   
PIPE=/tmp/pipe
                                                                                                                   
rm -f $PIPE
mkfifo $PIPE
set -x
                                                                                                                   
spawn() {
    sleep 0.1
    echo DONE > $PIPE
}

spawn &

while true; do
    while read LINE < $PIPE; do
        echo $LINE
        spawn &
    done
done
-----------

Regards,
Lluís.
