Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1APXPE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 18:15:04 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:57733 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1APXO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 18:14:59 -0500
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <20110117000659.57352da7@stein>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
	 <20110116141105.59e5b3a2@stein>
	 <1295214807.22813.57.camel@haakon2.linux-iscsi.org>
	 <20110117000659.57352da7@stein>
Content-Type: text/plain
Date: Sun, 16 Jan 2011 15:14:55 -0800
Message-Id: <1295219695.22813.66.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 00:06 +0100, Stefan Richter wrote:
> On Jan 16 Nicholas A. Bellinger wrote:
> > On Sun, 2011-01-16 at 14:11 +0100, Stefan Richter wrote:
> > > On Jan 15 Nicholas A. Bellinger wrote:
> > > > This patch changes configfs to select SYSFS to fix the following:
> > > > 
> > > > warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)
> > > 
> > > Why don't you fix target-core's Kconfig instead?
> > 
> > The thought here was that since modern configfs is mounted
> > at /sys/kernel/config/, selecting SYSFS by default when building
> > CONFIGFS_FS made the most sense for existing configfs consumers.
> 
> I for one think that layered "select" directives will open too many cans
> of worms.
> 
> Best don't use select at all.
> 
> If you use it, select only options that don't depend on anything else.
> 
> If you feel that people really want you to provide a select for them which
> selects something that in turn depends on other things, then I suggest you
> rather let your own option depend on these lower dependencies:
> 
> config HIGHLEVEL_FEATURE
> 	tristate "some driver"
> 	depends on SYSFS  # because CONFIGFS depends on it
> 	select CONFIGFS

I think this is a fair point..  As I don't really have a strong
preference either way, I will have to defer to Randy and Joel's better
judgement here.  Guys, what would you prefer..?

Thanks,

--nab

