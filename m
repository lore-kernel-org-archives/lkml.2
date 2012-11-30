Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030497Ab2K3OwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 09:52:12 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53673 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030480Ab2K3OwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 09:52:09 -0500
Message-ID: <1354287129.11903.3.camel@joe-AO722>
Subject: Re: [PATCH 2/3] cifs: Make CIFS_DEBUG possible to undefine
From: Joe Perches <joe@perches.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2012 06:52:09 -0800
In-Reply-To: <20121130064919.373547f4@tlielax.poochiereds.net>
References: <cover.1354217746.git.joe@perches.com>
	 <26f6f4e1a1fb5091784fb1a6919e214994a6dc88.1354217746.git.joe@perches.com>
	 <20121130064919.373547f4@tlielax.poochiereds.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-30 at 06:49 -0500, Jeff Layton wrote:
> On Thu, 29 Nov 2012 11:37:19 -0800
> Joe Perches <joe@perches.com> wrote:
> 
> > Make the compilation work again when CIFS_DEBUG is not #define'd.
> > 
> > Add format and argument verification for the various macros when
> > CIFS_DEBUG is not #define'd.
[]
> Would it be better to simply make those the standard
> 
> "do { ; } while(0)" noop macros?
> 
> I'm not sure I see the point in keeping the printk statements in there...

Actually, that's not standard.
Look at printk.h

It prevents developers from adding code that compiles
without warnings in one mode but compiles with warnings
in another.

The idea is to make sure that format and arguments always
match regardless of whether or not you are compiling
debug or non-debug.


