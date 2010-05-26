Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab0EZLyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:54:15 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43266 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0EZLyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rSXeK/8O7boU4TcWQbhZCtWXsLcORaBbE9aFj3ZMqO04rWc6iZvYpoGzkRLzRM3pFv
         cWhSQCbmX27zMFT9f3rF8nc95IYn4uy8fhipXejwt3qrI1VWNeIuOb+5d0H2te0hx+BV
         9l4ouX+01LqZkLkgAN6JdEkJ/+/hI3U5GJDo4=
MIME-Version: 1.0
In-Reply-To: <E1OHDru-0000Ge-Lr@pomaz-ex.szeredi.hu>
References: <1274867768-3011-1-git-send-email-xiaosuo@gmail.com> 
	<E1OHDru-0000Ge-Lr@pomaz-ex.szeredi.hu>
From: Changli Gao <xiaosuo@gmail.com>
Date: Wed, 26 May 2010 19:53:53 +0800
Message-ID: <AANLkTildR17ccf4TAT0GavB6BoethCqg8BrqBPFu8s0N@mail.gmail.com>
Subject: Re: [PATCH 2/3] splice: allow non-block splice only when in file is 
	seekable
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 6:29 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, 26 May 2010, Changli Gao wrote:
>> allow non-block splice only when in file is seekable.
>>
>> do_splice_to() is split to two parts: read data from in file to spd, and move
>> data from spd to pipe. If there isn't much space in pipe for the data in spd,
>> and the splice is called with non-block flag, the data dropped due to non
>> enough space in pipe will be lost forever when in file isn't seekable.
>
> This is a gratuitous ABI change.  I don't think we should hold the
> hand of application writers,

Yea, it is an ABI change. But without that, we'll fail user silently
currently. Some fundamental change is needed to fix this issue fully,
if you think it is a bug.

> maybe they _know_ the splice will not
> block.
>

If they know the splice won't block, why he specifies a non-block flag?

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
