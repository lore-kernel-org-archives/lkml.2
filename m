Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1JSXJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:09:10 -0400
Received: from tango.0pointer.de ([85.214.72.216]:48049 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab1JSXJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:09:09 -0400
Date: Thu, 20 Oct 2011 01:09:09 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Ballard <dan@mindstab.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel/sysctl.c: Add cap_last_cap to
  /proc/sys/kernel
Message-ID: <20111019230909.GB32295@tango.0pointer.de>
References: <1318460194-31983-1-git-send-email-dan@mindstab.net>
 <1318690205-2731-1-git-send-email-dan@mindstab.net>
 <20111017153936.c47a27ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017153936.c47a27ff.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17.10.11 15:39, Andrew Morton (akpm@linux-foundation.org) wrote:

> 
> On Sat, 15 Oct 2011 07:50:05 -0700
> Dan Ballard <dan@mindstab.net> wrote:
> 
> > Userspace needs to know the highest valid capability of the running
> > kernel, which right now cannot reliably be retrieved from the header
> > files only.  The fact that this value cannot be determined properly
> > right now creates various problems for libraries compiled on newer
> > header files which are run on older kernels. They assume
> > capabilities are available which actually aren't.
> 
> Specfically, what libraries are we talking about here?

libcap-ng, for example. And we ran into the same problem with systemd too.
> 
> > Now the capability is exported in /proc/sys/kernel/cap_last_cap.
> 
> Ever the optimist: is there any way in which we can avoid 0444
> permissions on this?

Normal users should be able to query this value, and it's not a security
problem if they do. Hence 0444 appears to be the right setting to me.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
