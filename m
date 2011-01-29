Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1A2It0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 03:49:26 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52406 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab1A2ItZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 03:49:25 -0500
Subject: Re: [PATCH 6/7] zram: Return zero'd pages on new reads
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110128150042.GG2062@linux.vnet.ibm.com>
References: <20110128145602.GA2062@linux.vnet.ibm.com>
	 <20110128150042.GG2062@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 29 Jan 2011 10:49:24 +0200
Message-ID: <1296290964.30654.10.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 09:00 -0600, Robert Jennings wrote:
> Currently zram will do nothing to the page in the bvec when that page
> has not been previously written.  This allows random data to leak to
> user space.  That can be seen by doing the following:
> 
>  ## Load the module and create a 256Mb zram device called /dev/zram0
>  # modprobe zram
>  # echo $((256*1024*1024)) > /sys/class/block/zram0/disksize
> 
>  ## Initialize the device by writing zero to the first block
>  # dd if=/dev/zero of=/dev/zram0 bs=512 count=1
> 
>  ## Read ~256Mb of memory into a file and hope for something interesting
>  # dd if=/dev/zram0 of=file
> 
> This patch will treat an unwritten page as a zero-filled page.  If a
> page is read before a write has occurred the data returned is all 0's.
> 
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>

