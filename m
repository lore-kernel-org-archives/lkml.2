Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1A0Pvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:51:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33208 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab1A0Pvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:51:54 -0500
Date: Thu, 27 Jan 2011 16:51:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        James Bottomley <James.Bottomley@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>
Subject: Re: netconsole build breakage (Re: [GIT] Networking)
Message-ID: <20110127155130.GA8318@elte.hu>
References: <20110114.130323.201674039.davem@davemloft.net>
 <20110119095920.GA10543@elte.hu>
 <20110119100824.GD9903@cr0.nay.redhat.com>
 <1295433231.21351.17.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1295433231.21351.17.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:

> On Wed, 2011-01-19 at 18:08 +0800, Américo Wang wrote:
> > On Wed, Jan 19, 2011 at 10:59:20AM +0100, Ingo Molnar wrote:
> > >
> > >FYI, there's a .38-rc1 build failure that triggers rather often:
> > >
> > > drivers/built-in.o: In function `drop_netconsole_target':
> > > netconsole.c:(.text+0x130146): undefined reference to `config_item_put'
> > > drivers/built-in.o: In function `write_msg':
> > > netconsole.c:(.text+0x1301aa): undefined reference to `config_item_get'
> > > netconsole.c:(.text+0x130217): undefined reference to `config_item_put'
> > > drivers/built-in.o: In function `netconsole_netdev_event':
> > > netconsole.c:(.text+0x1302ab): undefined reference to `config_item_get'
> > > ...
> > >
> > >Triggered by this configuration:
> > >
> > > CONFIG_CONFIGFS_FS=m
> > > CONFIG_NETCONSOLE=y
> > >
> > 
> > Should be "depends on CONFIGFS_FS=y".
> 
> Sorry for breaking this one folks..
> 
> Where this was left yesterday was to change NETCONSOLE_DYNAMIC, DLM and
> OCFS2_FS symbols to use 'select configfs' instead of 'depends on SYSFS
> && CONFIGFS':
> 
> http://marc.info/?l=linux-kernel&m=129539400709508&w=2
> 
> but unfortuately this did not make it into .38-rc1 in time..
> 
> Using 'select CONFIGFS_FS' here for NETCONSOLE_DYNAMIC with the
> following patches should do the trick.
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-linus
> 
> Thanks,
> 
> Nicholas Bellinger (3):
>   net: Make NETCONSOLE_DYNAMIC use select CONFIGFS_FS
>   dlm: Make DLM use select CONFIGFS_FS
>   ocfs2: Make OCFS2_FS use select CONFIGFS_FS
> 
>  drivers/net/Kconfig |    3 ++-
>  fs/dlm/Kconfig      |    4 ++--
>  fs/ocfs2/Kconfig    |    3 ++-
>  3 files changed, 6 insertions(+), 4 deletions(-)

Ping? This is still broken in Linus's tree as of today ... simple builds like 
allmodconfig still fail.

Thanks,

	Ingo
