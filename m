Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab3AIVdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:33:23 -0500
Received: from sunsite.ms.mff.cuni.cz ([195.113.15.26]:32975 "EHLO
	sunsite.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933417Ab3AIVdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:33:19 -0500
X-Greylist: delayed 1941 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2013 16:33:18 EST
Date: Wed, 9 Jan 2013 21:59:48 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org, dwalsh@redhat.com, dmalcolm@redhat.com,
        sds@tycho.nsa.gov, segoon@openwall.com,
        linux-security-module@vger.kernel.org
Subject: Re: Friendlier EPERM - Request for input
Message-ID: <20130109205947.GE26036@sunsite.ms.mff.cuni.cz>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <1357747463.2593.28.camel@localhost>
 <1357760637.2593.55.camel@localhost>
 <50EDCFC0.3010401@schaufler-ca.com>
 <1357763560.1342.7.camel@localhost>
 <50EDD8D4.60003@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EDD8D4.60003@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 12:53:40PM -0800, Casey Schaufler wrote:
> I'm suggesting that the string returned by get_extended_error_info()
> ought to be the audit record the system call would generate, regardless
> of whether the audit system would emit it or not.

What system call would that info be for and would it be reset on next
syscall that succeeded, or also failed?

The thing is, various functions e.g. perform some syscall, save errno, do
some other syscall, and if they decide that the first syscall should be what
determines the whole function's errno, just restore errno from the saved
value and return.  Similarly, various functions just set errno upon
detecting some error condition in userspace.
There is no 1:1 mapping between many libc library calls and syscalls.
So, when would it be safe to call this new get_extended_error_info function
and how to determine to which syscall it was relevant?

	Jakub
