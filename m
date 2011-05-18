Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1ERGTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 02:19:22 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38759 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1ERGTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 02:19:20 -0400
Date: Wed, 18 May 2011 08:19:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: Only generate config_is_xxx for bool and
	tristate options
Message-ID: <20110518061919.GA18763@merkur.ravnborg.org>
References: <1305646532-29114-1-git-send-email-mmarek@suse.cz> <20110517195310.GA17003@merkur.ravnborg.org> <20110518051645.GB15292@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518051645.GB15292@game.jcrosoft.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 07:16:45AM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 21:53 Tue 17 May     , Sam Ravnborg wrote:
> > On Tue, May 17, 2011 at 05:35:32PM +0200, Michal Marek wrote:
> > > For strings and integers, the config_is_xxx macros are useless and
> > > sometimes misleading:
> > > 
> > >   #define CONFIG_INITRAMFS_SOURCE ""
> > >   #define config_is_initramfs_source() 1
> > 
> > I'm late with this comment....
> > Could we introduce "config_is_foo" using a syntax that
> > does not break grepability?
> > 
> > Maybe a syntax like this?
> > 
> >     #ifdef CONFIG_FOO
> > 
> > and
> > 
> >     if (KCONFIG_FOO())
> > 
> > Grepping for the use of a symbol is a very typical thing,
> > so we should try to keep this.
> > And with the suggested syntax above I expect fixdep to
> > catch up both usage types.
> I'll prefer kconfig_foo()
> not uppercase
> 
> but if we use KCONFIG_FOO no need to touch fixdep

fixdep is easy to fix - albeit it may cost a bit of processing time.
wht I worry much more about is users that miss uses of CONFIG_ symbols, because
they do not show up in "git grep CONFIG_FOO".

Using "if (KCONFIG_FOO()) users are also awre this is a configuration
decided condition - which is nice to stand out.

	Sam
