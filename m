Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab1ASKIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 05:08:38 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60992 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab1ASKIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 05:08:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tQ1L8NzUAWmOeUhwicaURJ2nXKIh4IPIJiemjja1o/LbgW1oVLGEAKtDneIwJazNfd
         XsSZV5LrEuR1kA31RpSVm4YBQybnTAFg+hqdosBYM7dwjQwLtjyjSInFNtYeCtyKIz6d
         WpIwq/IQNNx3XPCjJ0UFbYTI3cIazB4eCgBzw=
Date: Wed, 19 Jan 2011 18:08:24 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: netconsole build breakage (Re: [GIT] Networking)
Message-ID: <20110119100824.GD9903@cr0.nay.redhat.com>
References: <20110114.130323.201674039.davem@davemloft.net>
 <20110119095920.GA10543@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119095920.GA10543@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 10:59:20AM +0100, Ingo Molnar wrote:
>
>FYI, there's a .38-rc1 build failure that triggers rather often:
>
> drivers/built-in.o: In function `drop_netconsole_target':
> netconsole.c:(.text+0x130146): undefined reference to `config_item_put'
> drivers/built-in.o: In function `write_msg':
> netconsole.c:(.text+0x1301aa): undefined reference to `config_item_get'
> netconsole.c:(.text+0x130217): undefined reference to `config_item_put'
> drivers/built-in.o: In function `netconsole_netdev_event':
> netconsole.c:(.text+0x1302ab): undefined reference to `config_item_get'
> ...
>
>Triggered by this configuration:
>
> CONFIG_CONFIGFS_FS=m
> CONFIG_NETCONSOLE=y
>

Should be "depends on CONFIGFS_FS=y".
