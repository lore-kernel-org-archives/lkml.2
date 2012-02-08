Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab2BHRU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:20:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48292 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2BHRU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:20:27 -0500
Message-ID: <4F32AECE.4010308@zytor.com>
Date: Wed, 08 Feb 2012 09:20:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Paul Parsons <lost.distance@yahoo.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, Kirill Smelkov <kirr@mns.spb.ru>,
        linux-kernel@vger.kernel.org
Subject: Re: No /dev/root with devtmpfs?
References: <1328719440.33661.YahooMailClassic@web29013.mail.ird.yahoo.com>
In-Reply-To: <1328719440.33661.YahooMailClassic@web29013.mail.ird.yahoo.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 08:44 AM, Paul Parsons wrote:
> 
> Could you simply use /etc/fstab to identify the root partition?
> 

That's not a very good thing, as it is much more likely to be wrong.

It would be a good thing to have the /dev/root symlink *IF* a valid root
device exists (defined as a device node appearing which has the same
device number as reported by stat on the root directory), if nothing
else because we have had one available for a very long time and this is
needless breakage.

Obviously, if such a device doesn't exist (btrfs, NFS, tmpfs) then don't.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

