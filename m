Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab2EVWLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:11:34 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:60865 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab2EVWLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:11:32 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: kconfig-frontends-3.4.0-0 released
Date: Wed, 23 May 2012 00:11:28 +0200
User-Agent: KMail/1.13.5 (Linux/3.4.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201205222221.05548.yann.morin.1998@free.fr> <20120522211941.GA30024@home.goodmis.org>
In-Reply-To: <20120522211941.GA30024@home.goodmis.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205230011.29257.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven, All,

On Tuesday 22 May 2012 23:19:41 Steven Rostedt wrote:
> >   - some side utilities have been added from the Linux kernel tree:
> >     - kconfig-diff      show differences between two .config files
> 
> I'm curious, how is this different than scripts/diffconfig ?

It's exactly the same.

The kconfig-frontends package is created by extracting the needed files from
the linux kernel. So, kconfig-diff is exactly scripts/diffconfig. Also, it's
what the line just above says: "added _from_ the Linux kernel tree" ;-)

But the kconfig toolss in the linux tree are not using a common naming
scheme. For example we have:
    scripts/config
    scripts/diffconfig
    scripts/kconfig/merge_config.sh
    scripts/kconfig/kxgettext
    scripts/kconfig/conf
    scripts/kconfig/mconf

So, kconfig-frontends tries to use a meaningful naming scheme for all the
programs it installs. Some are renamed, and they all get prefixed by default
with 'kconfig-' (although that can be overriden at ./configure time with
--program-prefix=...).

In the package, the file scripts/kernel2kfrontends.list has the
correspondence for what comes from the linux tree, and how it's named in
the kconfig-frontends tree. For example, we have:
    scripts/config                      -->  utils/tweak
    scripts/diffconfig                  -->  utils/diff
    scripts/kconfig/merge_config.sh     -->  utils/merge
    scripts/kconfig/kxgettext.c         -->  utils/gettext.c

The script scripts/ksync.sh (in kconfig-frontends) uses that file to
automatically sync from a linux tree.

There is virtually zero code written in the package (except for a few patches
required for the packaging), so the behavior is exactly the same as if using
the corresponding kconfig tools from the kernel.

Please note, however, that this is only the second release of
kconfig-frontends, and that things can still be improved upon! ;-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
