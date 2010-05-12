Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab0ELW25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:28:57 -0400
Received: from mail.perches.com ([173.55.12.10]:2203 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab0ELW24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:28:56 -0400
Subject: Re: [PATCH] get_maintainer.pl: improve config-file support
From: Joe Perches <joe@perches.com>
To: florian@mickler.org
Cc: akpm@linux-foundation.org, Stephen Hemminger <shemminger@vyatta.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1273698720-4010-1-git-send-email-florian@mickler.org>
References: <1273698720-4010-1-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 15:28:53 -0700
Message-ID: <1273703333.20514.392.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 23:12 +0200, florian@mickler.org wrote:
> This changes the syntax of the config-file introduced in the commit
> "scripts/get_maintainer.pl: add .get_maintainer.conf default options
> file".
> Entries are now of the more commonly found form:
> 	key = value
> where keys are cmd-line arguments without the "--" prefixed.

I don't have a strong opinion one way or another about the
.conf file format.

Another option which could be useful:  --noconf, don't read the file.

> as well as warn if unrecognized options are
> specified.

The old approach does that as well.

> +if (!GetOptions( \%prefs,

I think you don't need to repeat the options.
Doesn't this work?
	if (!GetOptions(\%prefs)) {
	    die "$P: invalid argument - use --help if necessary\n";


