Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2HCSd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:33:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60140 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753318Ab2HCSdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:33:22 -0400
Message-ID: <1344018801.10710.17.camel@joe2Laptop>
Subject: Re: [PATCH] scripts/get_maintainer.pl: Default to --no-rolestats
 when output not a terminal
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Alex Kelly <alex.page.kelly@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Date: Fri, 03 Aug 2012 11:33:21 -0700
In-Reply-To: <20120803182706.GA4637@jtriplet-mobl1>
References: <20120803182706.GA4637@jtriplet-mobl1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-03 at 11:27 -0700, Josh Triplett wrote:
> scripts/get_maintainer.pl defaults to showing --rolestats, which
> provides annotations explaining why each person or list might want to
> know about a patch.  This works well for interactive use, but breaks
> when used with git send-email's --to-cmd or --cc-cmd, resulting in
> malformed email headers and mails sent to some but not all recipients.
> 
> To avoid the need to explicitly pass --no-rolestats for batch use,
> enable --rolestats by default only when outputting to a terminal.

Hi Josh.

I think it's preferable to add --no-rolestats
to the uses that need them.

I have different scripts that I use for git send-email
options --to-cmd and --cc-cmd

$ cat ~/bin/to.sh
#!/bin/bash

opts="--nogit --nogit-fallback --norolestats --pattern-depth=1"

if [[ $(basename $1) =~ ^0000- ]] ; then
    ./scripts/get_maintainer.pl --nom $opts  $(dirname $1)/*
else
    maint=$(./scripts/get_maintainer.pl --nol $opts $1)
    if [ "$maint" == "" ] ; then
	echo "linux-kernel@vger.kernel.org"
    else
	echo "$maint"
    fi
fi

$ cat ~/bin/cc.sh
#!/bin/bash

opts="--nogit --nogit-fallback --norolestats"

if [[ $(basename $1) =~ ^0000- ]] ; then
    ./scripts/get_maintainer.pl --nom $opts  $(dirname $1)/*
else
    ./scripts/get_maintainer.pl $opts $1
fi


