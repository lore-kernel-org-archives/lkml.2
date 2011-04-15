Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1DOMsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 08:48:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58916 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1DOMsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 08:48:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:date
         :message-id:subject:from:to:cc:content-type;
        b=I+MFIREno9KObdD024COEM5R0X6q/YWKiFOlvB3vKvnNAkwXpfSqwwaQgybjMIJZXr
         KrYhpoZyNU18WRSmD3MJS7zwHwrgSiDq7/QtF/Qpeou+OHfnmOlyZYBRK22237mfbLKE
         tgbCvjcNaeF0PwniwjPqsp7gOaeDVDVkKuWXQ=
MIME-Version: 1.0
X-Originating-IP: [88.209.222.127]
In-Reply-To: <BANLkTikHKGLQvShJBL0P7XJ9XQ3EpgYxuQ@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
	<BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
	<BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
	<BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
	<BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com>
	<BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
	<BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
	<BANLkTikHKGLQvShJBL0P7XJ9XQ3EpgYxuQ@mail.gmail.com>
Date: Fri, 15 Apr 2011 14:48:05 +0200
Message-ID: <BANLkTinmWtL0U2L7+DFeHW0R9Kpy-JevcA@mail.gmail.com>
Subject: Re: Unionmount status?
From: Miklos Szeredi <miklos@szeredi.hu>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Ric Wheeler <ricwheeler@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 2:34 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
> On 15 April 2011 14:29, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> 2) take whiteout/opaque support from union mounts and use that
>
> How far from importing full unionmount is that?

Whiteout/opaque support is quite separate from the rest of union
mounts, and could be reusable for overlayfs.

There are several reasons why I didn't want to go that way with:

- lots of filesystems would have to be updated
- it introduces incompatibility in the filesystem format, which can be
a real pain (not for tmpfs, obviously, since tmpfs doesn't have a
persistent backing)

There *are* advantages to doing whiteouts in the filesystem, for
example it makes file removal atomic.  But atomicity is something that
needs to be addressed in lots of other places (e.g. copy up) not just
during whiteout, and there are other ways to do that than push the
responsibility into each and every filesystem.

Thanks,
Miklos
