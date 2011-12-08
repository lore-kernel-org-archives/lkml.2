Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1LHQeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 11:34:11 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:21822 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1LHQeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 11:34:08 -0500
X-Authority-Analysis: v=2.0 cv=Q75QEvKa c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=zQGhUK9Iw4MA:10 a=H9EZrR9EDZgA:10 a=8nJEP1OIZ-IA:10 a=4iYZgdKEE8gfmc8FkXgA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4EE0C8DB.7070904@cfl.rr.com>
Date: Thu, 08 Dec 2011 09:25:31 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Add BLKPG_GET_PARTITION operation
References: <cover.1322709471.git.psusi@cfl.rr.com> <4ED6F340.9050000@cfl.rr.com> <20111208123534.GB16493@nb.redhat.com>
In-Reply-To: <20111208123534.GB16493@nb.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/8/2011 7:35 AM, Karel Zak wrote:
> On Wed, Nov 30, 2011 at 10:23:44PM -0500, Phillip Susi wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Add a new operation to the BLKPG ioctl to read the partition.
>> This allows user space to find the current start and length
>> of a partition without having to open the partition and use
>> the long depreciated HDIO_GETGEO ioctl.
>
>   $ cat /sys/block/sda/sda1/{size,start}
>   4096000
>   2048
>
>   ...is probably the best way if you want to avoid problems with
>   permissions and deprecated (or all) ioctls :-)

Yes, I patched parted to grab the values from sysfs and only use 
HDIO_GETGEO if that fails, but I thought an ioctl would be preferable ( 
no need to muck about with appending partition numbers to paths and 
parsing text and such ), and it seemed an orthogonal operation to the 
other BLKPG ops.

