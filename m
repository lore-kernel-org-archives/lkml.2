Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1ADRHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:07:17 -0500
Received: from mail.perches.com ([173.55.12.10]:2948 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab1ADRHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:07:15 -0500
Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
From: Joe Perches <joe@perches.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Dan Carpenter <error27@gmail.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20110104164414.GX5875@const.bordeaux.inria.fr>
References: <20110104055900.GA5062@bicker>
	 <20110104163836.GA30317@fieldses.org>
	 <20110104164414.GX5875@const.bordeaux.inria.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 09:07:14 -0800
Message-ID: <1294160834.6617.51.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 17:44 +0100, Samuel Thibault wrote:
> J. Bruce Fields, le Tue 04 Jan 2011 11:38:36 -0500, a écrit :
> > On Tue, Jan 04, 2011 at 08:59:00AM +0300, Dan Carpenter wrote:
> > > This patch makes checkpatch.pl complain if you break up conditions in
> > > the wrong way.
> > > Wrong:
> > > 	if ((really_long_condition)
> > > 		&& (second_condition)) { ...
> > > Right:
> > > 	if ((really_long_condition) &&
> > > 		(second_condition)) { ...
> > As far as I can tell, the convention in mathematical typesetting is to
> > put operators on the left, not the right.  When the conditions are short
> > of there are more lines, that allows you to left-align on the repeated
> > operator.
> I personally find the left approach more readable.

As do I, but perhaps coding style in a project like this
shouldn't be personal but collective.

The trailing style outnumbers the leading style ~ 5:1.

$ grep -rP --include=*.[ch] "(\|\||&&)[ \t]*$" * | wc -l
39890
$ grep -rP --include=*.[ch] "^[ \t]*(\|\||&&)" * | wc -l
8244

If you take out drivers/staging, trailing is used ~ 6:1.

I think that high enough to be declared the preferred style.

