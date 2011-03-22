Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1CVSts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:49:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49728 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1CVStq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:49:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Yumiur8mKKXmWRRNVFVbcNxUbfI5Hj30A3XqZtDT6D4h7+S3wWN8qkXhNj39+7gGg/
         pEI4ko4A/5M34Ye3RXi+4CysEUCZuXMxeYab1PGHjBVttnJGO54jbYnSKyJFK0zX1FAM
         jeiAqErLYtFCx5UnZleonMYOhTsh2rZVzQGB8=
MIME-Version: 1.0
In-Reply-To: <4D88E8EF.8000001@openwrt.org>
References: <20110322152602.053930811@szeredi.hu>
	<AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
	<4D88E8EF.8000001@openwrt.org>
Date: Tue, 22 Mar 2011 13:49:44 -0500
Message-ID: <AANLkTim-_h9_mp3hPQXndTc3gR+AJKj+keoN2yDZV2Sr@mail.gmail.com>
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 1:22 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-03-22 6:36 PM, Linus Torvalds wrote:
>> On Tue, Mar 22, 2011 at 8:26 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> Here's an updated version of the overlay filesystem.  I'd like to
>>> propose it for inclusion into mainline.
>>
>> So on the whole it looked pretty small and simple. And most of the VFS
>> level changes looked fine and I just reacted to the odd calling
>> convention for open (I really think you should aim for ->open to have
>> the basically same arguments as you made __dentry_open have: 'struct
>> path', 'struct filp' and 'struct cred').
>>
>> But I'd want Al's ack on the series. And also hear who uses it and how
>> it's been tested?
> We're using it in OpenWrt (an Embedded Linux distribution) for devices
> with tiny amounts of flash for the entire system (e.g. 4 MB).
> We're using it to provide a writable on-flash root filesystem with
> squashfs for the read-only part and jffs2 for the writable overlay. This
> saves some precious flash space compared to using only jffs2, and it
> makes it easy for users to reset their device to defaults without having
> to reflash.
> With a backport of v6 of this series + my fixes that went into v7 this
> is working quite well on 2.6.37 and 2.6.38 - I'm using it on a few
> wireless access points at home.
>
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

how is this filesystem related to mini_fo and unionfs?
