Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab1CVSWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:22:54 -0400
Received: from nbd.name ([46.4.11.11]:43142 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1CVSWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:22:52 -0400
Message-ID: <4D88E8EF.8000001@openwrt.org>
Date: Tue, 22 Mar 2011 19:22:39 +0100
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, neilb@suse.de
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
References: <20110322152602.053930811@szeredi.hu> <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
In-Reply-To: <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-22 6:36 PM, Linus Torvalds wrote:
> On Tue, Mar 22, 2011 at 8:26 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> Here's an updated version of the overlay filesystem.  I'd like to
>> propose it for inclusion into mainline.
> 
> So on the whole it looked pretty small and simple. And most of the VFS
> level changes looked fine and I just reacted to the odd calling
> convention for open (I really think you should aim for ->open to have
> the basically same arguments as you made __dentry_open have: 'struct
> path', 'struct filp' and 'struct cred').
> 
> But I'd want Al's ack on the series. And also hear who uses it and how
> it's been tested?
We're using it in OpenWrt (an Embedded Linux distribution) for devices
with tiny amounts of flash for the entire system (e.g. 4 MB).
We're using it to provide a writable on-flash root filesystem with
squashfs for the read-only part and jffs2 for the writable overlay. This
saves some precious flash space compared to using only jffs2, and it
makes it easy for users to reset their device to defaults without having
to reflash.
With a backport of v6 of this series + my fixes that went into v7 this
is working quite well on 2.6.37 and 2.6.38 - I'm using it on a few
wireless access points at home.

- Felix
