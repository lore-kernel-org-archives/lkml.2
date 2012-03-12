Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab2CLWQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:16:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab2CLWQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:16:42 -0400
Date: Mon, 12 Mar 2012 23:16:37 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
Message-ID: <20120312221637.GA8386@host2.jankratochvil.net>
References: <4F5A3A4D.1020008@redhat.com>
 <20120309172934.GA18173@host2.jankratochvil.net>
 <4F5DE6A4.2030303@redhat.com>
 <20120312165359.GA32400@host2.jankratochvil.net>
 <4F5E4757.705@redhat.com>
 <20120312190818.GA25523@host2.jankratochvil.net>
 <4F5E526B.2020406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5E526B.2020406@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012 20:45:47 +0100, Denys Vlasenko wrote:
> On 03/12/2012 08:08 PM, Jan Kratochvil wrote:
> >	Try: yum --disablerepo='*' --enablerepo='*-debuginfo' install /usr/lib/debug/.build-id/ec/1fd70dbee0db36eff9527254d9d2bbfd260f13
> 
> My network is down. "yum install" won't work.

Now I think you mean that you want to just find /usr/bin/md5sum without ever
using /usr/lib/debug/usr/bin/md5sum.debug, right?

Then you can create your local build-id -> filename database specific to your
machine in some /var/lib/build-id/ .  Such database has nothing to do with the
core file itself.  Core file can be easily transferred to other hosts as it is
machine independent.  Core file is dependent only on the specific binaries
_content_ (not _names_) which is uniquely identified by their build-id.

/var/lib/build-id/ can be created/updated either during 'rpm -i' time or from
'/proc/sys/kernel/core_pattern' hook or via some inotify daemon watching /bin,
/usr/bin and other directories updates etc. etc.


Regards,
Jan
