Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab1BZLvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 06:51:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1BZLvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 06:51:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] debugfs: only allow root access to debugging interfaces
Date: Sat, 26 Feb 2011 12:50:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Dan Carpenter <error27@gmail.com>, Greg KH <gregkh@suse.de>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        Eugene Teo <eugeneteo@kernel.sg>,
        Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com> <20110222205847.GA1867@khazad-dum.debian.net> <20110224163844.GC888@home.goodmis.org>
In-Reply-To: <20110224163844.GC888@home.goodmis.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102261250.33914.arnd@arndb.de>
X-Provags-ID: V02:K0:/gZRZ3Vq4eZYxl5H9f6Z1WfoglNoQcwfrW8EGceXhJv
 8POAp9EN/qGtZDen7WuXxIdhWdm/sVLA5Db7++K/RUj+n+7c43
 L7YVyotZeLbo7x0gAUtHLXnFbUU9zGD6uuWfLismt8Nc8uKP1Q
 UfZzaXsa+BbHRVk0+J8OcKAcIG0c9Nimp0eJ/5gBAlr2RFuH6L
 Vfg1NX3eh6O7F8j2aUZtw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 February 2011, Steven Rostedt wrote:
> Currently things are still in a large flux, and I do not know how this
> will play out. Although the changes in /debugfs/tracing has toned down a
> lot, there's also the work going in on how to merge perf and ftrace.
> This may start changes as well, and perhaps deprecate interfaces. I
> don't know.
> 
> Having debugfs as the main interface was not the goal of all this, but
> we seemed to have just gotten stuck with it.

Some time ago, I started a patch set to make it possible to unify a
lot of the pseudo file systems like debugfs, configfs and others, and
to also make it possible to trivially create another file_system_type,
basically creating a new root inode in the same way that you'd create a new
debugfs directory.

The patch set is probably quite outdated now, and I currently don't have
time to finish it, but I'd be happy to help someone else refresh it
to get it upstream.

Once that is done, you could move the tracing files and any other
parts of debugfs that have evolved into a proper API into their own
file systems without changing much code.

This would in particular make it possible to mount the main debugfs
root-only while you can have other rules for parts of it that have
become real interfaces.

	Arnd

