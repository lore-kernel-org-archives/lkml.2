Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab2CGV1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:27:21 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56963 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786Ab2CGV1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:27:15 -0500
MIME-Version: 1.0
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Date: Wed, 7 Mar 2012 15:27:14 -0600
Message-ID: <CAH2r5mv+Dc6SbhGQ1Cna+dFHq6UNuj2NBWYYwGTcYDVGT3mT8w@mail.gmail.com>
Subject: Re: [PATCH 00/25] vfs: atomic open RFC
From: Steve French <smfrench@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, sage@newdream.net,
        ericvh@gmail.com, mszeredi@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 3:22 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> This series allows clean implementation of atomic lookup+(create)+open and
> create+open operations that previously were done via ->lookup and ->create using
> open intents.
>
> Testing and review is welcome, but at this stage mainly I'd like to hear
> opinions on the overall design of the new interfaces.

This could be great for network file systems like cifs/smb2

Historically mapping the multistage lookup/create/open to an atomic
opencreate protocol operation (for cifs, and now smb2 and smb2.2)
has always been hard.   We go from an atomic syscall to
lookup intents, but it was tricky to make this atomic on the wire in every case.

It will be interesting to review this.

-- 
Thanks,

Steve
