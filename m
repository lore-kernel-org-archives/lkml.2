Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1HRH0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:26:35 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:42676 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755119Ab1HRH0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:26:33 -0400
Subject: Re: [PATCH] checkpatch: do not test/warn of leading whitespace
 before signature tags
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: linux-kernel@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Andy Whitcroft <apw@canonical.com>
In-Reply-To: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>
References: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 00:26:30 -0700
Message-ID: <1313652390.32547.53.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 23:48 -0700, Jeff Kirsher wrote:
> From: Bruce Allan <bruce.w.allan@intel.com>
> 
> Commit 2011247 introduced additional style checks for signature tags in
> patches which is good.  Unfortunately, now whenever patches are checked
> by piping the output of 'git show' or 'stg show' through checkpatch it
> warns not to use whitespace before all signature tags since these (and the
> rest of the patch description) are indented.  Remove this test/warning.

I think this is not a good idea.

checkpatch is meant for patches not git log output.
indenting signatures can cause other problems later.

I think you can avoid this easily by using checkpatch
option --ignore=BAD_SIGN_OFF when using git log output
as input.

You could also use:

git log --format="commit %H%nAuthor: %an <%ae>%nDate:   %aD%n%n%s%n%n%b"

so that you get the current default --format=medium
output without indenting the commit log body.


