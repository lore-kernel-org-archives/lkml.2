Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0DUKSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:18:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53047 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0DUKSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:18:07 -0400
To: Jamie Lokier <jamie@shareable.org>
CC: miklos@szeredi.hu, jblunck@suse.de, vaurora@redhat.com,
       dwmw2@infradead.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       tytso@mit.edu, linux-ext4@vger.kernel.org
In-reply-to: <20100421095221.GD13114@shareable.org> (message from Jamie Lokier
	on Wed, 21 Apr 2010 10:52:21 +0100)
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
References: <1271682168.14748.718.camel@macbook.infradead.org> <20100419132344.GI10776@bolzano.suse.de> <20100419133028.GA3631@shareable.org> <20100419141248.GK10776@bolzano.suse.de> <20100419142315.GA2688@shell> <E1O3sLi-0008EA-QW@pomaz-ex.szeredi.hu> <20100420213450.GM11723@shareable.org> <20100421084211.GB22741@bolzano.suse.de> <20100421092235.GB13114@shareable.org> <E1O4WKa-0003Pp-0y@pomaz-ex.szeredi.hu> <20100421095221.GD13114@shareable.org>
Message-Id: <E1O4X02-0003UN-IV@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 21 Apr 2010 12:17:42 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010, Jamie Lokier wrote:
> Sorry, no: That does not work for bind mounts.  Both layers can have
> the same st_dev.

Okay.

>  Nor does O_NOFOLLOW stop traversal in the middle of
> a path, there is no handy O_NOCROSSMOUNTS, and no st_mode flag or
> d_type to say it's a bind mount.  Bind mounts are really a big pain
> for i_nlink+inotify name counting.

I'm confused.  You are monitoring a specific file and would like to
know if something is happening to any of it's links, right?

Why do you need to know about bind mounts for that?

Count the number of times you encounter that d_ino and if that matches
i_nlink then every directory is monitored.  Simple as that, no?

Thanks,
Miklos
