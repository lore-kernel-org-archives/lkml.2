Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab2HSNcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 09:32:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61970 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2HSNcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 09:32:17 -0400
Message-ID: <5030E95C.1030908@gmail.com>
Date: Sun, 19 Aug 2012 15:25:48 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Dan Luedtke <mail@danrl.de>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lanyfs@librelist.com
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
References: <1345333117-2826-1-git-send-email-mail@danrl.de>  <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>  <1345371135.4441.2.camel@tunafish>  <5030BC7E.3030000@gmail.com> <1345383264.4441.56.camel@tunafish>
In-Reply-To: <1345383264.4441.56.camel@tunafish>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/08/2012 15:34, Dan Luedtke ha scritto:
> On Sun, 2012-08-19 at 12:14 +0200, Marco Stornelli wrote:
>>   what are pros and cons of this fs
>> compared with existing fs?
> Pros:
> - Simplicity. LanyFS avoids any unnecessary complexity.
> Example: I had a lot of problems reading and writing data on the Arduino
> platform. Most of it was, because the platform wasn't capable of dealing
> with FAT32 when files grew. I don't know if LanyFS performs better on
> Arduino, I haven't written a driver for Arduino yet, I am glad I managed
> to get it working on Linux for the moment.
>
> - Interoperability. LanyFS was designed to unite those features which
> are common on most operating systems. [...] All information, including
> file and directory metadata, is stored in the most purposive format
> without honoring the habits of any particular operating system.
> Example: I have a nice FullHD movie file which is about 8GB in size. I
> wanted to play that video file on a RaspberryPI connected to a TV. FAT32
> wasn't able to store the file because it was larger than 4GB. I then
> tried using ext3, but the ownership information from my workstation
> (were the file was copied from) did not match the ones the RaspberryPI
> had, since I usually do not synchronize user profiles between
> workstations and embedded devices. There are workarounds, one might say,
> but shouldn't it be much more easier to transfer files from one device
> to another? There are use cases were modes/permissions and ownership of
> files does not matter, where quota and accounting isn't necessary, where
> access times don't need to be stored since they would never get updated
> anyway.
>
> Flexibility. LanyFS adopts to the underlying storage device by
> adjusting its parameters accordingly. It can address block
> devices starting from 4 KiB up to 64 ZiB with minimal overhead by
> parameterizing the filesystem at formatting time.
> Example: At the university we sometimes work with smart cards and their
> sometimes "strange" filesystems. I am not an expert on smart cards and
> stuff like that, but I was being told that a more simple filesystem
> would be welcome. AFAIK we are talking about "disks" with a size of less
> than 1MB. I don't think this is a big feature, most other fs can be
> adjusted to perfectly fit a particular purpose, too. Yet there still is
> the demand for something "much more simpler".
>
> Cons:
> - LanyFS is featureless. It lacks of features. This is considered a
> feature by some people, and a big con by others :)
>
> - Use of recursion. It may not scale in some cases (e.g. very large
> files on embedded platforms).

Recursion can be a problem, we have got a little stack, I don't know if 
it's a good idea.

>
> - Current restrictions due to early stage. Max blocksize is 4k, but 4MB
> might be better. The LWN article pointed to by Alan talks about this.
>

Ok, I try to do a summary. You are trying to write a new general and 
minimal fs for mobile storage device, minimal enough to be easy ported 
on several fs. So at the end you are trying to replace the solution is 
used today on many platforms (fat32). Without other consideration about 
"no-feature is a feature", it seems to me really challenging because the 
project can fail its goal no because there is design problem, bugs and 
so on but because of limited use. We are talking about interoperability 
problem, and we really know some companies out there from this point of 
view :)

Marco
