Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab2APNoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:44:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab2APNoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:44:24 -0500
Message-ID: <4F1429B6.9080104@suse.cz>
Date: Mon, 16 Jan 2012 14:44:22 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Cong Wang <amwang@redhat.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Davidlohr Bueso <dave@gnu.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, Wang YanQing <udknight@gmail.com>
Subject: Re: [PATCH] menuconfig: fix a regression when canceling the prompt
 dialog at exit
References: <4F13CB49.8030004@cn.fujitsu.com> <1326698421.4151.4.camel@cr0> <4F13D216.3060705@cn.fujitsu.com> <4F13D873.4070808@cn.fujitsu.com>
In-Reply-To: <4F13D873.4070808@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.1.2012 08:57, Li Zefan wrote:
> This commit fixes a bug, while introducing a new one..
> 
> commit 7203ddbd4be9720649e47d756a001e0c7d7f8ae2
> Author: Wang YanQing <udknight@gmail.com>
> Date:   Thu Jan 12 11:31:32 2012 +0800
> 
>     menuconfig: let make not report error when not save configuration
> 
> Pressing ESC should cancel the yes/no dialog and return back to
> the main menu, but not exit from menuconfig.

Thanks, applied. Note that in the Ctrl-C case, ESC still exits with an
error. Changing sig_handler() to only exit if res != KEY_ESC is not
sufficient, as the dialog is not redrawn. Hm.

Michal
