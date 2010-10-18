Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab0JRLkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:40:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab0JRLkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:40:46 -0400
Date: Mon, 18 Oct 2010 13:40:42 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-lab-213.englab.brq.redhat.com
To: Lukas Czerner <lczerner@redhat.com>
cc: Ric Wheeler <rwheeler@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Discard benchmarking tool for SSD's and thinly provisioned
 devices
In-Reply-To: <alpine.LFD.2.00.1010181247330.6517@dhcp-lab-213.englab.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.1010181336130.6517@dhcp-lab-213.englab.brq.redhat.com>
References: <alpine.LFD.2.00.1010181247330.6517@dhcp-lab-213.englab.brq.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Lukas Czerner wrote:

> Hi all,
> 
> I would like to present you a tool for benchmarking discard performance
> on SSD's and thinly provisioned devices (or virtually any device
> supporting TRIM command).
> 
> You can download the tool here:
> 
> http://sourceforge.net/projects/test-discard/
> 
> there is also git repository available.
> 
> The tool is called "test-discard" (yes, very imaginative I know).
> 
> 
> DESCRIPTION
> -----------
>   This is a simple tool for benchmarking device discard (TRIM)
> performance. According to benchmark parameters the tool will
> repetitively call BLKDISCARD ioctl on the specified device with
> specified parameters collecting performance statistics.
> 
>   You can specify several parameter for the test. First of all you can
> specify the overall amount of Bytes to discard, the bigger the value
> is, the bigger discard ranges you can test, the more precise result
> you will obtain, and the longer will the test take. Then you can
> specify device LBA to start with discard test and record size. There
> are three modes of the test: sequential test, random I/O test and test
> where we are discarding already discarded blocks (discard2).
> 
>   There is also support for automated testing of range of record sizes.
> You just need to specify starting, ending and step record size and the
> tool will automatically survey the whole range. In addition you can get
> more script-friendly output for using this tool in scripts.
> 
>   You can also generate nice graphs with gnuplot (script included), but
> you will probably need to alter it to match your needs.
> 
> 
> FUNCTION PRINCIPLE
> ------------------
>   Invoke ioctl with BLKDISCARD flag and defined range repetitively until
> the specified amount of data is discarded. Running time of each ioctl
> invocation is measured and stored (also min and max) as well as number
> of invocations and range size.From collected data we can compute
> average ioctl running time, overall ioctl running time (sum) and
> throughput.
> 
>   In random IO mode discard range is not determined sequentially but
> picked randomly anywhere on the disk, but it is of course aligned to
> the range_size. Already discarded blocks are stored in the list. Before
> each discard operation random block is generated and added to the list,
> possibly altered if the block was already discarded. There is one
> limitation though, if the record size is to low and disk size is too
> high, only a part of disk will be used. To be specific :
> 
> 	max_tested_disk_size = INT_MAX * record_size;
> 
> 
> Please, see README file included in sources for more information.
> 
> 
> WARNING
> -------
>  * !!!! It WILL DESTROY all your data on the device !!!!
>  * I am using the tool quite often, thus it was properly tested and
>    should be stable, though I do NOT PROVIDE ANY WARRANTY.
> 
> 
> Thanks!
> 
> -Lukas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Also note that there might be some devices with buggy firmware which may
be damaged beyond repair by the TRIM command, especially with TRIM
performed in random IO pattern (from first-hand experience).

-Lukas
