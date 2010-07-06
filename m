Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0GFTYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 15:24:25 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39553 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab0GFTYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 15:24:24 -0400
To: David Howells <dhowells@redhat.com>
Cc: viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <26200.1278439363@redhat.com> (message from David Howells on Tue,
	06 Jul 2010 19:02:43 +0100)
Subject: Re: [PATCH 1/7] cachefiles: use path_get instead of lone dget
References: <20100706172926.065118640@szeredi.hu> <20100706172913.165416302@szeredi.hu> <26200.1278439363@redhat.com>
Message-Id: <E1OWDkX-0002mT-0t@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 06 Jul 2010 21:24:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jul 2010, David Howells wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Dentry references should not be acquired without a corresponding
> > vfsmount ref.
> 
> Which we have: current->fs holds one.  Or is this unsafe due to CLONE_FS?

current->fs doesn't change, but the contents can (e.g. another thread
does chdir()).

Thanks,
Miklos
