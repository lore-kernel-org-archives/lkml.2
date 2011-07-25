Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1GYUs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:48:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40098 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab1GYUsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:48:24 -0400
Message-ID: <4E2DD662.9060404@zytor.com>
Date: Mon, 25 Jul 2011 13:47:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        akpm@linux-foundation.org, Jens Axboe <jaxboe@fusionio.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH v3 1/2] init: add root=PARTUUID=UUID/PARTNROFF=%d support
References: <1309468207-24199-1-git-send-email-wad@chromium.org>
In-Reply-To: <1309468207-24199-1-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 02:10 PM, Will Drewry wrote:
> Expand root=PARTUUID=UUID syntax to support selecting a root partition
> by integer offset from a known, unique partition.  This approach
> provides similar properties to specifying a device and partition number,
> but using the UUID as the unique path prior to evaluating the offset.
> 
> For example,
>   root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B/PARTNROFF=1
> selects the partition with UUID 99DE.. then select the next
> partition.
> 
> This change is motivated by a particular usecase in Chromium OS where
> the bootloader can easily determine what partition it is on (by UUID)
> but doesn't perform general partition table walking.
> 
> That said, support for this model provides a direct mechanism for the
> user to modify the root partition to boot without specifically needing
> to extract each UUID or update the bootloader explicitly when the root
> partition UUID is changed (if it is recreated to be larger, for
> instance).  Pinning to a /boot-style partition UUID allows the arbitrary
> root partition reconfiguration/modifications with slightly less
> ambiguity than just [dev][partition] and less stringency than the
> specific root partition UUID.
> 

Obklibcsnark:

Does anyone still doubt that as long as this kind of code exists in the
kernel that it will not get continually added to?

	-hpa

