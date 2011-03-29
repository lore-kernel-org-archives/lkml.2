Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1C2PX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:23:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40440 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1C2PXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oGg5ER3qxKDD4xexotR2nSvnDehOMIQEEFezOU4F3pBWzKB7uuX+W+vsIWDL8J2rFs
         qwpMlLjiktQ2z+Rsn6diloD/kRVzG9NUO8b7vvuzGrH5rNUy/J8Sv4YoCPEkMGAWhRak
         zUsy0he53RVVl5OLB8mF+tMdLQuFk9nvCU3RQ=
MIME-Version: 1.0
In-Reply-To: <1301409864.5615.98.camel@wangqingchuan>
References: <1301310995.5615.92.camel@wangqingchuan>
	<1301336010.2217.20.camel@workstation>
	<AANLkTikMJszEyv8-SMMjD-MeykSwmsKf=gmezcMgySoP@mail.gmail.com>
	<1301409864.5615.98.camel@wangqingchuan>
Date: Tue, 29 Mar 2011 11:23:23 -0400
Message-ID: <AANLkTi=fcWBpmQ66a3+vQwgFOXn=0rJAviNzR4a0mfcJ@mail.gmail.com>
Subject: Re: GEM-related desktop sluggishness due to linear-time arch_get_unmapped_area_topdown()
From: Jerome Glisse <j.glisse@gmail.com>
To: r6144 <rainy6144@gmail.com>
Cc: Lucas Stach <dev@lynxeye.de>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/29 r6144 <rainy6144@gmail.com>:
> 在 2011-03-29二的 10:22 -0400，Jerome Glisse写道：
>
>> Killer solution would be to have no mapping and a decent
>> upload/download ioctl that can take userpage.
>
> Doesn't this sound like GEM's read/write interface implemented by e.g.
> the i915 driver?  But if I understand correctly, a mmap-like interface
> should still be necessary if we want to implement e.g. glMapBuffer()
> without extra copying.
>
> r6144
>
>
glMapBuffer should not be use, it's really not a good way to do stuff.
Anyway the extra copy might be unavoidable given that sometime the
front/back might either be in unmappable vram or either have memory
layout that is not the one specify at buffer creation (this is very
common when using tiling for instance). So even considering MapBuffer
or a like function i believe it's a lot better to not allow buffer
mapping in userspace but provide upload/download hooks that can use
userpage to avoid as much as possible extra copy.

Cheers,
Jerome
