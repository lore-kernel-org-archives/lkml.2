Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2ACT5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:57:48 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34394 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab2ACT5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:57:46 -0500
Message-ID: <4F035DB1.6000902@linux.vnet.ibm.com>
Date: Tue, 03 Jan 2012 13:57:37 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH] staging: zcache: add crypto API support
References: <1325082113-2843-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1325082113-2843-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12010319-7182-0000-0000-0000007C0A34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Hold off on this one.  I just found a bug in the 32-bit build.

Should have it figured out by the end of the day.

--
Seth

On 12/28/2011 08:21 AM, Seth Jennings wrote:
> This patch allow zcache to use the crypto API for page compression.
> It replaces the direct LZO compress/decompress calls with calls
> into the crypto compression API. The compressor to be used is
> specified in the kernel boot line with the zcache parameter like:
> zcache=lzo or zcache=deflate.  If the specified compressor can't
> be loaded, zcache uses lzo as the default compressor.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/Kconfig       |    7 +-
>  drivers/staging/zcache/zcache-main.c |  189 +++++++++++++++++++++++++++++-----
>  2 files changed, 165 insertions(+), 31 deletions(-)

