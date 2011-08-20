Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1HTJsN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 05:48:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1HTJsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 05:48:09 -0400
Message-ID: <4E4F814B.5070202@gmail.com>
Date: Sat, 20 Aug 2011 11:41:31 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
In-Reply-To: <1309275199-10801-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Il 28/06/2011 17:33, Josef Bacik ha scritto:
> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
> using fiemap in things like cp cause more problems than it solves, so lets try
> and give userspace an interface that doesn't suck.  We need to match solaris
> here, and the definitions are
>
> *o* If /whence/ is SEEK_HOLE, the offset of the start of the
> next hole greater than or equal to the supplied offset
> is returned. The definition of a hole is provided near
> the end of the DESCRIPTION.
>
> *o* If /whence/ is SEEK_DATA, the file pointer is set to the
> start of the next non-hole file region greater than or
> equal to the supplied offset.
>

I'm implementing the SEEK_DATA/SEEK_HOLE management for pramfs and I've 
got some doubts about the right behavior:

1) when we use SEEK_DATA/SEEK_HOLE, the offset used in lseek means 
always the offset from the start of the file, right?

2) in case of a file with hole at the beginning and data at the end, if 
I do lseek(fd, 0, SEEK_HOLE) I should receive the end of the file 
because the idea is to search the *next* hole and we have always a 
virtual hole at the end of the file, right?

3) about the last sentence of point 2), is it always true even if we 
have a case of block allocation beyond the end of file (fallocate with 
keep size option)?

Thanks.

Regards,

Marco
