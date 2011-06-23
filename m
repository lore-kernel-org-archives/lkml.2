Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729Ab1FWQ57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:57:59 -0400
Received: from mail.perches.com ([173.55.12.10]:3166 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab1FWQ57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:57:59 -0400
Subject: Re: __packed vs. __attribute__((packed)) in kernel headers
From: Joe Perches <joe@perches.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
In-Reply-To: <20110623150209.GA12413@x4.trippels.de>
References: <20110622063441.GA1740@x4.trippels.de>
	 <20110623134209.GA10813@elliptictech.com>
	 <20110623150209.GA12413@x4.trippels.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 09:57:57 -0700
Message-ID: <1308848277.6688.7.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 17:02 +0200, Markus Trippelsdorf wrote:
> On 2011.06.23 at 09:42 -0400, Nick Bowler wrote:
> > On 2011-06-22 08:34 +0200, Markus Trippelsdorf wrote:
> > > One possible solution would be to let the "scripts/headers_install.pl"
> > > script automatically substitute __packed with __attribute__((packed)):
> > > 
> > > diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
[]
> I'm not an expert of Perl regular expressions, but maybe this:
>  $line =~ s/\s__packed;$/ __attribute__((packed));/g
> is a little bit closer to the intention?

Maybe:

s/\b__packed\b/__attribute__((packed))/g

though this argues against redefining
gcc __attributes__ in the first place. 

