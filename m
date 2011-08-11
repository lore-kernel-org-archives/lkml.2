Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1HKLKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:10:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:47344 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1HKLKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 07:10:14 -0400
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Thu, 11 Aug 2011 12:10:10 +0100
In-Reply-To: <4E4399B3.3020909@suse.cz>
References: <1312067499.22074.59.camel@i7.infradead.org>
	  <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	  <4E4140B3.7090802@suse.cz>
	  <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>
	  <4E4280BA.9050109@suse.cz> <1312981658.2989.39.camel@i7.infradead.org>
	  <CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>
	  <1312985888.2989.46.camel@i7.infradead.org>
	  <CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com>
	  <1312993987.2989.53.camel@i7.infradead.org>
	  <CACqU3MXC_eDqgWDwnVe8KsqoAMTPQNiP6YMHD5G+1sMBhMwXzA@mail.gmail.com>
	  <1312999168.2989.61.camel@i7.infradead.org>
	  <CACqU3MWB+4n5Acd-GboH5WbCzfZFiAc0wNvOkn_5O+--7jLE8A@mail.gmail.com>
	  <1313002322.2989.88.camel@i7.infradead.org>
	  <CACqU3MU2J25q-wWJ8LNcMkwi3uMigz_+0=XcrNiPC0TGiJHZqA@mail.gmail.com>
	  <1313018232.2989.114.camel@i7.infradead.org>
	  <CACqU3MVyjzr47N9v23SGaSjiEOGoEaP1-TZ4Z_RyVNgVXgPEwg@mail.gmail.com>
	 <1313052168.18037.9.camel@i7.infradead.org> <4E4399B3.3020909@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313061012.18037.17.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 10:58 +0200, Michal Marek wrote:
> I would much rather see include/config/auto.conf reset all configuration
> variables to match what kconfig computed. I.e. use 'undefine CONFIG_FOO'
> instead of '# CONFIG_FOO is not set'. 

That would be cute, but I'm not sure how to undefine something set on
the command line:

$ cat > Makefile <<EOF
undefine BAR

foo:
	echo $(BAR)
EOF
$ make foo BAR=hh
echo hh
hh

Arguably, if someone *does* try something like Arnaud's 
 "make CONFIG_FOO_BAR=y oldconfig bzImage"
.. and it *wasn't* able to set CONFIG_FOO_BAR, then the nicest behaviour
would be to fail, rather than to attempt to build it.

So perhaps we should clean up only those settings inherited from the
environment, and still (as in the patch I sent earlier) refuse to allow
build targets in conjunction with CONFIG overrides on the command line?

-- 
dwmw2

