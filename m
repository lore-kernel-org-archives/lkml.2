Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2DBUUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 16:20:09 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:12983 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2DBUUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 16:20:08 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 95.21.41.4
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ovh/Ax95Z1q5RksfEvP/u
Date: Mon, 2 Apr 2012 22:20:02 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Shea Levy <shea@shealevy.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hang opening a pipe written to by a child, with SIGCHLD
Message-ID: <20120402202002.GD3029@vicerveza.homeunix.net>
References: <20120402144611.GY3029@vicerveza.homeunix.net>
 <4F79BC66.3010902@shealevy.com>
 <20120402185057.GB3029@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120402185057.GB3029@vicerveza.homeunix.net>
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 08:50:57PM +0200, Lluís Batlle i Rossell wrote:
> On Mon, Apr 02, 2012 at 10:49:10AM -0400, Shea Levy wrote:
> > On 04/02/2012 10:46 AM, Lluís Batlle i Rossell wrote:
> > >Can anyone reproduce this?
> > 
> > I've reproduced this on my system as well (3.3). No idea about cause though.
> > 
> 
> Thank you Shea,

All clear. I had a race condition; sorry for the noise. Proper synchronization
through close() in the child and read() = 0 in the parent fixes all.
