Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab1LADRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:17:19 -0500
Received: from ozlabs.org ([203.10.76.45]:35271 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab1LADRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:17:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: jim.cromie@gmail.com, jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 18/25] dynamic_debug: Introduce global fake module param module.ddebug
In-Reply-To: <1322683014-13285-19-git-send-email-jim.cromie@gmail.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com> <1322683014-13285-19-git-send-email-jim.cromie@gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 01 Dec 2011 12:49:33 +1030
Message-ID: <8739d5t4ne.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011 12:56:47 -0700, jim.cromie@gmail.com wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
> 
> Rework Thomas Renninger's $module.ddebug boot-time debugging feature,
> from https://lkml.org/lkml/2010/9/15/397
> 
> Dynamic Debug allows enabling of pr_debug and dev_dbg messages at
> runtime.  This is controlled via $DBGFS/dynamic_debug/control.  One
> major drawback is that the whole initialization of a module cannot be
> tracked, because ddebug is only aware of debug strings of loaded
> modules.  But this is the most interesting part...
> 
> This patch introduces a fake module parameter module.ddebug (not shown
> in /sys/module/*/parameters, thus it does not use any resources).  If
> a module passes ddebug as a module parameter (e.g. via module.ddebug
> kernel boot param or via "modprobe module ddebug"), all debug strings
> of this module get activated by issuing "module module_name +p"
> internally (not via sysfs) when the module gets loaded.
> A later patch extends this with an arg: module.ddebug="+mfp"

I think you're missing a neat trick here: we should be able to handle
ddebug in the handle_unknown parameter to parse_args().

Or am I missing something?

Thanks,
Rusty.
