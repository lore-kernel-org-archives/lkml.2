Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab0EMH5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:57:01 -0400
Received: from ist.d-labs.de ([213.239.218.44]:38254 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047Ab0EMH5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:57:00 -0400
Date: Thu, 13 May 2010 09:56:52 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, Stephen Hemminger <shemminger@vyatta.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: improve config-file support
Message-ID: <20100513095652.34aea727@schatten.dmk.lab>
In-Reply-To: <1273703333.20514.392.camel@Joe-Laptop.home>
References: <1273698720-4010-1-git-send-email-florian@mickler.org>
	<1273703333.20514.392.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 15:28:53 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2010-05-12 at 23:12 +0200, florian@mickler.org wrote:
> > This changes the syntax of the config-file introduced in the commit
> > "scripts/get_maintainer.pl: add .get_maintainer.conf default options
> > file".
> > Entries are now of the more commonly found form:
> > 	key = value
> > where keys are cmd-line arguments without the "--" prefixed.
> 
> I don't have a strong opinion one way or another about the
> .conf file format.
> 
> Another option which could be useful:  --noconf, don't read the file.
> 
> > as well as warn if unrecognized options are
> > specified.
> 
> The old approach does that as well.

True.

> 
> > +if (!GetOptions( \%prefs,
> 
> I think you don't need to repeat the options.
> Doesn't this work?
> 	if (!GetOptions(\%prefs)) {
> 	    die "$P: invalid argument - use --help if necessary\n";
> 
No, GetOpts::Long needs a special markup for parsing the cmdline
string, like =s for specifying that that option is accompanied by a
string value or the ! for specifying that it is a flag. 
Also there are aliases defined for config-options.

Cheers,
Flo

p.s.: maybe there is a GetOpts feature to use config-files?
