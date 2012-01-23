Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab2AWNtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 08:49:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab2AWNti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 08:49:38 -0500
Date: Mon, 23 Jan 2012 14:46:43 +0100
From: Andrew Jones <drjones@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rientjes@google.com, mingo@elte.hu, david.woodhouse@intel.com,
        linux-kernel@vger.kernel.org, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, arnd@arndb.de, holt@sgi.com,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com,
        jesper nilsson <jesper.nilsson@axis.com>, dhowells@redhat.com,
        takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake koichi <yasutake.koichi@jp.panasonic.com>, jonas@southpole.se,
        kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org,
        chris@zankel.net, greg@kroah.com, davej@redhat.com, airlied@linux.ie,
        jkosina@suse.cz, mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120123134632.GA8235@turtle.usersys.redhat.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
 <b6315f9b-0ead-4de4-a8f5-ed619f852c6c@zmail13.collab.prod.int.phx2.redhat.com>
 <20120118122830.037f1e29.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118122830.037f1e29.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 12:28:30PM -0800, Andrew Morton wrote:
> time.  But I suggest that we tip both CONFIG_EXPERT and CONFIG_EMBEDDED
> into the ole bit bucket.  What do you guys think would be the negative
> consequences of doing this?

I thought EXPERT was the best way to manage the visibility of expert
options, but probably not, since it's prone to silent default changing. I
think it would be safer if the kconfig language had more support for this
visibility control. Maybe we need another miscellaneous option, like
'option visibility=<level>', level = {low, normal, high, experimental}.
low means practically grayed out (hopefully allowing the eye of the user
to effectively not see it), normal would be a noop, high makes it stand
out, and experimental would be like high, except also throw a canned
sentence in that says it's not ready for production. (This additional
focus on EXPERIMENTAL was inspired by your comments on it possibly
deserving a special color or something.) Of course, additional or
different levels could be conceived of, but in general I think we need
better ways to supply hints to kconfig frontends about visibility.
Something that can't get tangled up with default values.

Drew
