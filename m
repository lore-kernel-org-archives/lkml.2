Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1J0NzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 09:55:09 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:36985 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753251Ab1J0NzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 09:55:08 -0400
Message-ID: <4EA962B2.3030402@tao.ma>
Date: Thu, 27 Oct 2011 21:54:58 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: "Ted Ts'o" <tytso@mit.edu>, ext4 development <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V1 00/17] ext4: Add inline data support.
References: <4EA7B788.3040503@tao.ma> <7941.1319699422@turing-police.cc.vt.edu>
In-Reply-To: <7941.1319699422@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.39.32 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 03:10 PM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 26 Oct 2011 15:32:24 +0800, Tao Ma said:
> 
>> Currently I use all the space between i_extra_isize and inode_size if
>> inode_size = 256. For inode_size > 256, half of that space is used so as
>> to leave some space for other xattrs.
> 
> I didn't check the code too closely - does this code DTRT if the user tries to
> then attach a moby-sized xattr (or set of xattrs - if it's got a security.selinux
> tag on it, and a security.capabilities xattr, and a user xattr or two, things are
> going to be getting full).
sure, it will work and all these stuff will be inserted to the external
xattr block since the in-inode space is full.
> 
>> This is only a V1 and there are still something to do(e.g. I am thinking
>> of using unused extent space), but I'd like to send it out earlier so
>> that it can be reviewed ASAP.
> 
> If this works out, would it make sense to investigate doing this for all
> tails in a V2?  So if your file was 4099 bytes long, you could save allocating
> a second block.  Assuming random distribution of tail sizes, this wil save
> an average of (space avail for tail)/(blocksize) per file.
uh, it seems like a good suggestion, but it will make the code a little
bit complicated(at least compared to the current version) and I am not
sure whether the maintainer like it or not ;) . So Ted and Andreas, What
do you think of this?

Thanks
Tao

