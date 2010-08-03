Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0HCKJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:09:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45078 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab0HCKJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:09:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rMJEJxWFvXdr3VWq+rQG1yCg5FulAFUhHmsiLCPdWSLuHmO7GVtsN/145O5UomMnEA
         Z5KiZh7b2IsDV13REMlYbBwuSrKOihVNpIKSUG9/E9Gfqx9nYJkbXdF1QlpEwbT6/mIC
         3jISIc3xqeUY16OM6HpkA7EwlUH/4jG/F37Go=
Date: Tue, 3 Aug 2010 18:12:20 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: hacklu <embedway.linux@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: how about KBUILD_MODNAME
Message-ID: <20100803101220.GI5129@cr0.nay.redhat.com>
References: <201008031037022524247@gmail.com>
 <201008031511572638256@gmail.com>
 <201008031735377545190@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008031735377545190@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 05:35:40PM +0800, hacklu wrote:
>
>I am compiling the boardcom's driver now.
>the driver had defined EXTRA_CFLAGS = -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags) 
>in the a.makefile.
>and the a.makefile was included by b.makefile.
>when in the b.makefile,
>there is this command.
> $(CC) $(DEPS_OPT) $(CFLAGS) $(EXTRA_CFLAGS) -o $@ -c $< ;) 
>
>I had add "echo $(EXTRA_CFLAGS)" before this line;but returns NULL;
>
>so I suspicion the $(EXTRA_CFLAGS) hasn't been work.
>


You don't need to write this line by yourself, you just
need to provide a correct: obj-$(XXXXX) += your_module.o,
kbuild will automatically compile it with proper flags.
(If not, try CFLAGS_MODULE.)

If you insist to do this, I think you can just append
-D"KBUILD_MODNAME=your_module" to that line by hand.

Hope this helps.
