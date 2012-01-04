Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2ADX5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:57:05 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43101 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2ADX5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:57:01 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=2TvZ7eE48NdEYeaL5Xf58dNzJU178UzT+2lxUZ5Mhss= c=1 sm=1
 a=nSC6y5WQha8A:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=7ImfPPP0mufTBllIrTUA:9 a=CjuIK1q_8ugA:10
 a=7dktXc3_Sb6ovfMd:21 a=YH_tZIRLjjCR2gth:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH] fs/ext{3,4}: fix potential race when setversion ioctl updates inode
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20120104233254.GH28907@quack.suse.cz>
Date: Wed, 4 Jan 2012 16:56:59 -0700
Cc: Djalal Harouni <tixxdz@opendz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Yongqiang Yang <xiaoqiangnk@gmail.com>,
        ext4 development <linux-ext4@vger.kernel.org>,
        linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <58AD879D-30E3-4FF0-B2A7-E31DBB2295FE@dilger.ca>
References: <20120103013152.GA26455@dztty> <20120104174609.GD28907@quack.suse.cz> <6C16105A-D0EE-413E-B993-F223CFC75307@dilger.ca> <20120104233254.GH28907@quack.suse.cz>
To: Jan Kara <jack@suse.cz>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-04, at 4:32 PM, Jan Kara wrote:
> On Wed 04-01-12 16:15:04, Andreas Dilger wrote:
>> On 2012-01-04, at 10:46 AM, Jan Kara wrote:
>>> On Tue 03-01-12 02:31:52, Djalal Harouni wrote:
>>>> 
>>>> The EXT{3,4}_IOC_SETVERSION ioctl() updates the inode without i_mutex,
>>>> this can lead to a race with the other operations that update the same
>>>> inode.
>>>> 
>>>> Patch tested.
>>> 
>>> OK, so I've taken the patch into my tree, just updated the changelog
>>> which result of our discussion in this thread. I also took the ext4 part
>>> since there is no risk of conflict and the patch looks obvious.
>> 
>> Actually, I'd like to hear more about whether this is a real problem, or
>> if it is just a theoretical problem found during code inspection or from
>> some static code analysis tool?
> 
> As far as I understood that was just a theoretical issue and I applied
> the patch just on the grounds that it is more consistent to use i_mutex for
> i_generation changes.
> 
>> With the metadata checksum feature we were discussing using the inode
>> generation as part of the seed for the directory leaf block checksum, so
>> that it wasn't possible to incorrectly access stale directory blocks from
>> a previous incarnation of the same inode number.
>> 
>> We were discussing just disabling this ioctl on filesystems with metadata
>> checksums, and printing a deprecation warning for filesystems without that
>> feature enabled.  I'm not aware of any real-world use for this ioctl, since
>> NFS cannot use it to reconstruct handles because there's no API to allocate
>> an inode with a specific number, so setting the generation is pointless.
> 
>  OK, I didn't know this. I'm fine with deprecating the ioctl if it's
> useless but since that's going to take a while I think the cleanup still
> makes some sense.

I'm not against landing the patch, and I agree that there is no question
about the performance impact of making this ioctl safe.  My real question
was whether there was a real-world use for this ioctl which might prevent
it from being deprecated.


Cheers, Andreas





