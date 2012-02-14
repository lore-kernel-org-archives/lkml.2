Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779Ab2BNUO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:14:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43806 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760635Ab2BNUOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:14:55 -0500
Message-ID: <4F3AC0B4.1020203@intel.com>
Date: Tue, 14 Feb 2012 12:14:44 -0800
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Organization: Intel Corporation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Tony Luck <tony.luck@intel.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 21/21] posix_types: Remove fd_set macros
References: <CA+8MBb+rMJqJAyDnnkB=x794F3MAQJfwTi29=4oN4-6=g5uDFw@mail.gmail.com> <4F32A98F.7030400@zytor.com> <1328677745-20121-22-git-send-email-hpa@zytor.com> <1328677745-20121-1-git-send-email-hpa@zytor.com> <8328.1328703626@redhat.com> <16325.1328736262@redhat.com> <4F32E98F.2090909@zytor.com> <30935.1329247114@redhat.com> <4F3AB99E.5040705@zytor.com>
In-Reply-To: <4F3AB99E.5040705@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 11:44 AM, H. Peter Anvin wrote:
> 
> We can do that, but we'd almost certainly have to #include
> <linux/select.h> in <linux/time.h>.  The following macros are defined in
> <linux/time.h> and *exported to userspace*:
> 
> #define NFDBITS                 __NFDBITS
> 
> #define FD_SETSIZE              __FD_SETSIZE
> #define FD_SET(fd,fdsetp)       __FD_SET(fd,fdsetp)
> #define FD_CLR(fd,fdsetp)       __FD_CLR(fd,fdsetp)
> #define FD_ISSET(fd,fdsetp)     __FD_ISSET(fd,fdsetp)
> #define FD_ZERO(fdsetp)         __FD_ZERO(fdsetp)
> 

Note: yes, those macros are completely useless, obviously, since all
they do is take what is already defined in userspace and reflect it back
out.  Still, removing them is a userspace-visible change and really
should be its own change with nothing else.

	-hpa

