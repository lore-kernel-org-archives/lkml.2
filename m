Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1EBTpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:45:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59397 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab1EBTpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:45:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Kara <jack@suse.cz>
Subject: Re: Allow setting of number of raw devices as a module parameter
Date: Mon, 2 May 2011 21:44:31 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1304029469-19672-1-git-send-email-jack@suse.cz> <201104301415.02349.arnd@arndb.de> <20110502193937.GM4556@quack.suse.cz>
In-Reply-To: <20110502193937.GM4556@quack.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105022144.31612.arnd@arndb.de>
X-Provags-ID: V02:K0:jagalk7hpvh7zoasUiah8rcoaM6083N4czgcsvdEoG8
 gvQk7C1g8VWGW17M2ZLF7Tz6C7loFhwfjMYwmMzGBNU+7+zL1W
 wLl8r5/kfLcnqUWjnCSDUIwvGnlzSZd7er6u7JDIYIfPTvQLm+
 Tl4zjUX62hlfq9v0hIvSeP3AlP4LR4iE3rIhNd5Lag/+UPBXq4
 MyZpr+1iySeFrv+m09A3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 May 2011, Jan Kara wrote:
> On Sat 30-04-11 14:15:02, Arnd Bergmann wrote:
> > On Friday 29 April 2011 00:24:29 Jan Kara wrote:
> > > Allow setting of maximal number of raw devices as a module parameter. This
> > > requires changing of static array into a vmalloced one (the array is going to
> > > be too large for kmalloc).
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > Why don't you get rid of the global raw_devices array instead?
> > 
> > I suppose if you embed the struct cdev in raw_device_data and
> > register it during RAW_SETBIND separately for each raw device
> > instead of globally at raw_init time, you can support any number
> > of devices while making the code smaller and simpler. I suppose
> > you can even remove the raw_mutex then.
>   OK, I see. This might be a reasonable option. I'd then use kobj_lookup()
> to find my structure where I need it instead of array indexing, right? 
> I have really zero experience with writing device drivers so I'm asking
> simple questions :).

The character device layer uses kobj_lookup internally when opening
the device. When you are inside the driver, you can access it through
file->f_path.dentry->d_inode->i_cdev, from where you go to your own data
structure using container_of.

	Arnd
