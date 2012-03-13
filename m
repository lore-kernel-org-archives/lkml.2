Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030229Ab2CMA1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:27:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965247Ab2CMA1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:27:40 -0400
Date: Tue, 13 Mar 2012 01:27:25 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
Message-ID: <20120313002725.GA17828@host2.jankratochvil.net>
References: <4F5A3A4D.1020008@redhat.com>
 <20120309172934.GA18173@host2.jankratochvil.net>
 <4F5DE6A4.2030303@redhat.com>
 <20120312165359.GA32400@host2.jankratochvil.net>
 <4F5E76CE.4030601@zytor.com>
 <20120312223144.GA9636@host2.jankratochvil.net>
 <4F5E91DE.80609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5E91DE.80609@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 01:16:30 +0100, H. Peter Anvin wrote:
> That's quite absurd if you think about it... we're talking about each
> individual library, not necessarily the root binary.

Denys is also working on ABRT which already dumps a lot of useful info
associated with a core file:
	abrt_version analyzer architecture cmdline component coredump count
	dso_list environ executable hostname kernel maps os_release package
	pid pwd reason time uid username uuid var_log_messages

I find the local copy instances of the files of specific build the same or
even less less useful info than those files above.

One should start implementing dumping all the info above info Linux kernel
before the filenames are worth it.


The problem with filenames is they work in the most common end-user host
cases.  Which means tools get built on top of it that way - like what AFAIK
happened in the Ubuntu Apport case.  The resulting toolchain is then not
applicable for the longterm running server setups, it is that 99% working
solution which needs to be rewritten from scratch for that final 1%.


Regards,
Jan
